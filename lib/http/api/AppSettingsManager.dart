// import 'dart:convert';
// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:sail/http/http_utils.dart'; // Assuming your HttpUtils class is in http_utils.dart
// import 'package:jwt_decoder/jwt_decoder.dart';
// // import 'package:pointycastle/pointycastle.dart';
// import 'package:sail/http/api/AppSettings.dart';
// class AppSettingsManager {
//   final String apiEndpoint;
//   AppSettingsManager({required this.apiEndpoint});
//   // static final AppSettingsManager _instance = AppSettingsManager._internal();
//   // factory AppSettingsManager() => _instance;
//   // AppSettingsManager._internal();
//
//   final _secureStorage = const FlutterSecureStorage();
//   final _settingsKey = 'appSettings';
//   // Map<String, dynamic>? _cachedSettings;
//   // AppSettings _cachedSettings = AppSettings(
//   //     availableVersions: [1],
//   //     updateIsAvailable: false
//   //   );
//   AppSettings? _cachedSettings ;
//
//   // Encryption/Decryption (Replace with your secure key and IV)
//   final _key = encrypt.Key.fromLength(32);
//   final _iv = encrypt.IV.fromLength(16);
//   // final _salt = SecureRandom('Fortuna').nextBytes(16); // Store salt securely
//   // final _key = _deriveKeyFromPassword('your_user_password', _salt);
//   // final _iv = SecureRandom('Fortuna').nextBytes(16); // Generate a random IV
//   //
//   // Key _deriveKeyFromPassword(String password, Uint8List salt) {
//   //   final keyDerivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
//   //   final params = Pbkdf2Parameters(salt, 10000, 32); // Adjust iterations as needed
//   //   keyDerivator.init(params);
//   //   return Key(keyDerivator.process(Uint8List.fromList(utf8.encode(password))));
//   // }
//   late final encrypt.Encrypter _encrypter = encrypt.Encrypter(encrypt.AES(_key));
//   // AppSettingsManager({required this.apiEndpoint});
//
//   // Future<Map<String, dynamic>?> getSettings() async {
//   Future<AppSettings?> getSettings() async {
//     if (_cachedSettings != null) {
//       return _cachedSettings;
//     }
//
//     final encryptedSettings = await _secureStorage.read(key: _settingsKey);
//     if (encryptedSettings != null) {
//       _cachedSettings = _decryptSettings(encryptedSettings);
//       return _cachedSettings;
//     }
//
//     try {
//       // final response = await HttpUtils.get('your_api_endpoint'); // Use HttpUtils
//       // if (response.statusCode == 200) {
//       //   final settings = response.data; // Assuming response.data is the JSON
//       //   await _saveSettings(settings);
//       //   _cachedSettings = settings;
//       //   return settings;
//       final response = await HttpUtils.get(apiEndpoint); // Use HttpUtils
//       if (response.statusCode == 200) {
//         Map<String, dynamic> decodedToken = JwtDecoder.decode(response.data);
//         final settings = AppSettings.fromJson(decodedToken['data']); // Create AppSettings instance
//         await _saveSettings(settings.toJson()); // Save as JSON
//         // _cachedSettings = settings.toJson();
//         _cachedSettings = settings;
//         return settings; // Return AppSettings object
//       } else {
//         throw Exception('Failed to load settings from API');
//       }
//     } catch (e) {
//       // throw AppSettingsException('Failed to load settings: $e');
//       print('Error fetching settings: $e');
//       return null; // Or throw an exception
//     }
//   }
//
//   Future<void> _saveSettings(Map<String, dynamic> settings) async {
//     final encryptedSettings = _encryptSettings(settings);
//     await _secureStorage.write(key: _settingsKey, value: encryptedSettings);
//   }
//
//   String _encryptSettings(Map<String, dynamic> settings) {
//     final encodedSettings = jsonEncode(settings);
//     final encrypted = _encrypter.encrypt(encodedSettings, iv: _iv);
//     return encrypted.base64;
//   }
//
//   // Map<String, dynamic> _decryptSettings(String encryptedSettings) {
//   AppSettings _decryptSettings(String encryptedSettings) {
//     final decrypted = _encrypter.decrypt64(encryptedSettings, iv: _iv);
//     return jsonDecode(decrypted);
//   }
// }
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sail/constant/app_urls.dart';
import 'package:sail/http/http_utils.dart'; // Assuming your HttpUtils class is in http_utils.dart
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sail/http/api/AppSettings.dart';

class AppSettingsManager {
  String apiEndpoint; // Static base link provided in main.dart
  AppSettings? _cachedSettings;
  final _secureStorage = const FlutterSecureStorage();
  final _settingsKey = 'appSettings';
  final _timestampKey = 'settingsTimestamp';

  // Encryption setup
  // Use consistent key and IV across sessions (replace these with secure values in production)
  final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknowsl');
  final _iv = encrypt.IV.fromUtf8('my16lengthsecret');
  late final encrypt.Encrypter _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  AppSettingsManager({required this.apiEndpoint});
  void logInfo(String message) => print('[INFO] $message');
  /// Ensures the URL has a scheme (http or https). Defaults to https.
  String ensureUrlScheme(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }
  /// Fetch settings from storage or API based on timestamp and availability
  Future<AppSettings?> getSettings(String? url) async {
    this.apiEndpoint = url ?? this.apiEndpoint;
     await _clearSettings();
    final isSettingsValid = await _isSettingsValid();
    if (isSettingsValid) {
      print (" [info] old settings is valid !!");
      return _cachedSettings;
    } else {
      print (" [info] old settings not valid !!");
      final settings = await _fetchAndSaveSettings();
      return settings??null;
    }
  }

  /// Check if locally stored settings are valid (exists and is less than one day old)
  Future<bool> _isSettingsValid() async {
    logInfo("start settings validation ...");
    final encryptedSettings = await _secureStorage.read(key: _settingsKey);
    final lastUpdatedStr = await _secureStorage.read(key: _timestampKey);


    if (encryptedSettings != null && lastUpdatedStr != null) {
      try {
        final lastUpdated = DateTime.parse(lastUpdatedStr);
        if (DateTime.now().difference(lastUpdated).inDays < 1) {
          _cachedSettings = _decryptSettings(encryptedSettings);
          logInfo("setting is valid");
          return true;
        }
      } catch (e) {
        print('[error] setting validation Decryption failed: $e');
        await _clearSettings();  // Clear storage if decryption fails
      }
    }
    return false;
  }

  /// Fetch settings from server and store if successful
  Future<AppSettings?> _fetchAndSaveSettings() async {
    try {
      // Decide which URL to use based on `xBaseLink` in current settings
      var xbase = _cachedSettings?.supportLinks.xBaseLink ?? [apiEndpoint];
      for (int i = 0; i < xbase.length; i++) {
        String url = ensureUrlScheme(xbase[i]) + AppUrls.appSetting;

        // Make the HTTP request
        final response = await HttpUtils.get(url);

        // Check if the response is a Map or String and decode appropriately
        Map<String, dynamic>? responseMap;
        if (response is String) {
          // If response is a JSON string, decode it
          responseMap = jsonDecode(response);
        } else if (response is Map<String, dynamic>) {
          // If response is already a Map, use it directly
          responseMap = response;
        } else {
          throw Exception('Unexpected response type: ${response.runtimeType}');
        }

        // Ensure the response contains the 'data' field
        if (responseMap!.containsKey('data')) {
          Map<String, dynamic> decodedToken = JwtDecoder.decode(responseMap['data']);
          final innerJsonString = decodedToken['data'];

          // Check if 'data' is a JSON string, then decode it
          if (innerJsonString is String) {
            final innerJson = jsonDecode(innerJsonString);

            if (innerJson is Map<String, dynamic>) {
              await _clearSettings();
              logInfo('Data fetched successfully: ${jsonEncode(innerJson)}');
              final settings = AppSettings.fromJson(innerJson);
              await _saveSettings(settings);
              _cachedSettings = settings;
              return settings;
            } else {
              throw Exception('Decoded inner JSON is not a Map<String, dynamic>');
            }
          } else {
            throw Exception('Expected inner JSON data to be a string');
          }
        } else {
          throw Exception('Unexpected response structure');
        }
      }
      return null;
    } catch (e) {
      print('Error fetching settings: $e');
      return null;
    }
    //   if (response.statusCode == 200) {
    //     Map<String, dynamic> decodedToken = JwtDecoder.decode(response.data);
    //     final settings = AppSettings.fromJson(decodedToken['data']);
    //     await _saveSettings(settings);
    //     _cachedSettings = settings;
    //     return settings;
    //   } else {
    //     throw Exception('Failed to load settings from API');
    //   }
    // } catch (e) {
    //   print('Error fetching settings: $e');
    //   return null;
    // }
  }
  Future<String> firstURLEnable(List<String> urls) async {
    try {
      if (urls.length == 1) {
        return urls[0];
      }
      for (int i = 0; i < urls.length; i++) {
        final response = await HttpUtils.get(urls[i]);

        if (response != null) {
          // Assuming a successful response structure
          return urls[i];
        }
      }
      return AppUrls.baseMasterUrl;
    } catch (e) {
      return AppUrls.baseMasterUrl;
    }
  }
  /// Save settings and the current timestamp to secure storage
  Future<void> _saveSettings(AppSettings settings) async {
    final encryptedSettings = _encryptSettings(settings.toJson());
    await _secureStorage.write(key: _settingsKey, value: encryptedSettings);
    await _secureStorage.write(key: _timestampKey, value: DateTime.now().toIso8601String());
  }

  /// Encrypt settings for storage
  String _encryptSettings(Map<String, dynamic> settings) {
    final encodedSettings = jsonEncode(settings);
    final encrypted = _encrypter.encrypt(encodedSettings, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypt settings after retrieval from storage
  AppSettings _decryptSettings(String encryptedSettings) {
    try {
      final decrypted = _encrypter.decrypt64(encryptedSettings, iv: _iv);
      final decodedSettings = jsonDecode(decrypted) as Map<String, dynamic>;
      return AppSettings.fromJson(decodedSettings);
    } catch (e) {
      print('Decryption failed. Clearing storage. Error: $e');
      _clearSettings();  // Clear if decryption fails due to corrupted data
      rethrow;
    }
  }

  /// Clear settings in case of a decryption error
  Future<void> _clearSettings() async {
    await _secureStorage.delete(key: _settingsKey);
    await _secureStorage.delete(key: _timestampKey);
  }
}
