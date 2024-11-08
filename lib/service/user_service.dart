import 'package:sail/constant/app_urls.dart';
import 'package:sail/entity/login_entity.dart';
import 'package:sail/entity/user_entity.dart';
import 'package:sail/entity/user_subscribe_entity.dart';
import 'package:sail/http/api/AppSettings.dart';
import 'package:sail/utils/http_util.dart';
import 'package:sail/http/api/AppSettingsManager.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
class UserService {
  AppSettings? settings;

  UserService({this.settings});
  AppSettings? get appSettings => settings;
  void set setAppSettings (input)=> settings=input;
  void logInfo(String message) => print('[INFO] $message');
  //
  // Future<LoginEntity?> login(Map<String, dynamic> parameters) async {
  // // Future<LoginEntity>? login(Map<String, dynamic> parameters) {
  //   try {
  //     // var options = Options(
  //     //   followRedirects: false,
  //     //   validateStatus: (status) {
  //     //     return status != null && status >= 200 && status < 400;
  //     //   },
  //     // );
  //     //
  //     // HttpUtil.instance.dio.interceptors.add(
  //     //   InterceptorsWrapper(
  //     //     onRequest: (options, handler) {
  //     //       print("[INFO] Requesting URL: ${options.uri}");
  //     //       return handler.next(options);
  //     //     },
  //     //     onResponse: (response, handler) {
  //     //       print("[INFO] Redirected to URL: ${response.realUri}");
  //     //       return handler.next(response);
  //     //     },
  //     //     onError: (DioError e, handler) {
  //     //       print("[ERROR] DioError occurred: ${e.message}");
  //     //       if (e.response != null) {
  //     //         print("[ERROR] Response status: ${e.response?.statusCode}");
  //     //         print("[ERROR] Redirect issue or invalid URL: ${e.response?.realUri}");
  //     //       }
  //     //       return handler.next(e);
  //     //     },
  //     //   ),
  //     // );
  //
  //     // Make the request
  //     // var response = await HttpUtil.instance.dio.post(
  //     //   AppUrls.login,
  //     //   data: parameters,
  //     //   options: options,
  //     // );
  //     var response = HttpUtil.instance
  //         .post(AppUrls.login, parameters: parameters).then((result){return result;});
  //     // return HttpUtil.instance
  //     //     ?.post(AppUrls.login, parameters: parameters)
  //     //     .then((result) {
  //     //   if (result is Response) {
  //     //     print('[INFO] Final Status Code: ${result.statusCode}');
  //     //
  //     //     // Decode the response data if it’s in JSON format as a string
  //     //     final responseData = result.data is String ? jsonDecode(result.data) : result.data;
  //     //
  //     //     // Access and return the data if it exists
  //     //     if (responseData['data'] != null) {
  //     //       return LoginEntity.fromMap(responseData['data']);
  //     //     } else {
  //     //       throw Exception("Failed to retrieve login data after redirects.");
  //     //     }
  //     //   } else {
  //     //     throw Exception("Unexpected response format: Expected Response object but got ${result.runtimeType}");
  //     //   }
  //     //   return LoginEntity.fromMap(result['data']);
  //     // });
  //     // Check if the response is a Dio Response object
  //     if (response is Response) {
  //       print('[INFO] Final Status Code: ${response.statusCode}');
  //
  //       // Decode the response data if it’s in JSON format as a string
  //       final responseData = response.data is String ? jsonDecode(response.data) : response.data;
  //
  //       // Access and return the data if it exists
  //       if (responseData['data'] != null) {
  //         return LoginEntity.fromMap(responseData['data']);
  //       } else {
  //         throw Exception("Failed to retrieve login data after redirects.");
  //       }
  //     } else {
  //       throw Exception("Unexpected response format: Expected Response object but got ${response.runtimeType}");
  //     }
  //   } on DioError catch (e) {
  //     print('[ERROR] DioError: ${e.message}');
  //     if (e.response != null) {
  //       print('[ERROR] Redirect or network issue at URL: ${e.response?.realUri}');
  //     }
  //     throw Exception("Login request failed due to redirection or network issue.");
  //   }
  // }
  Future<LoginEntity>? login(Map<String, dynamic> parameters) {
    return HttpUtil.instance
        ?.post(AppUrls.login, parameters: parameters)
        .then((result) {
      return LoginEntity.fromMap(result['data']);
    });
  }
  Future<String>? getQuickLoginUrl(Map<String, dynamic> parameters) {
    return HttpUtil.instance
        ?.post(AppUrls.getQuickLoginUrl, parameters: parameters)
        .then((result) {
      return result['data'];
    });
  }

  Future<LoginEntity>? register(parameters) {
    return HttpUtil.instance
        ?.post(AppUrls.register, parameters: parameters)
        .then((result) {
      return LoginEntity.fromMap(result['data']);
      // return result['data'];
    });
  }

  Future<UserSubscribeEntity?>? userSubscribe() {
    print('---------Normal------------load settings');
    return HttpUtil.instance?.get(AppUrls.userSubscribe).then((result) {
      if(result != null && result is Map<String,dynamic> ) {
        print("-----------Plant---------- : "+(jsonEncode(result)).toString());
        if( result['data'] != null)
        {return UserSubscribeEntity.fromMap(result['data']);}

    }
        return  null;

    });
  }
  Future<UserSubscribeEntity?> userFreeSubscribe() async {
    print('---------Free------------loading settings');
    // Load settings to get subscriptionSupportLinks
    var settings;
    if(this.settings != null ) {
      // settings= await settingsManager!.getSettings(null);
      settings = this.settings;
    }else{
      AppSettingsManager settingsManager = AppSettingsManager(apiEndpoint: AppUrls.baseUrl);
      settings= await settingsManager!.getSettings(null);
    }
    if (settings == null) {
      print('Failed to load settings');
      return null;
    }

    // Get the subscription support links
    final subscriptionLinks = settings.supportLinks.subscriptionSupportLinks;
    if (subscriptionLinks.isEmpty) {
      print('No subscription links available');
      return null;
    }

    // Try each link in sequence until one succeeds
    for (var link in subscriptionLinks) {
      try {
        final result = await HttpUtil.instance?.get(link);
        if (result != null) {
          print('---------Free------------subscription success'+jsonEncode(result).toString());
          if(result['data'] != null){
            var fet=UserSubscribeEntity.fromMap(result['data']);
            if(fet != null && fet.subscribeUrl != "" && fet.subscribeUrl != null)
            {
              AppUrls.updateFreeServer(fet.subscribeUrl);
            }
            return fet ;
          }
        }
      } catch (e) {
        print('Failed to fetch data from $link: $e');
      }
    }

    // If no link returned data, return null or handle error
    print('All subscription links failed');
    return null;
  }

  Future<UserEntity>? info() {
    return HttpUtil.instance?.get(AppUrls.userInfo).then((result) {
      if (result.containsKey("data")) {
        final data = result["data"];
        return UserEntity.fromMap(data as Map<String, dynamic>);
        // return UserEntity.fromMap(result['data']);
      }
      throw Exception("Failed to retrieve user info");
    });
  }
  Future<bool> validateToken(String token) async {
    try {
      final response = await HttpUtil.instance.get(
          AppUrls.userSubscribe
      );
      return response['status'] == 'success';
    } catch (_) {
      return false;
    }
  }

  Future<String?> getSubscriptionLink(String accessToken) async {
    final result = await HttpUtil.instance.get(
        AppUrls.userSubscribe
    );
    // ignore: avoid_dynamic_calls
    if (result.containsKey("data")) {
      final data = result["data"];
      if (data is Map<String, dynamic> && data.containsKey("subscribe_url")) {
        return data["subscribe_url"] as String?;
      }
    }

    // 返回 null 或抛出异常，如果数据结构不匹配
    throw Exception("Failed to retrieve subscription link");
  }

  Future<String?> resetSubscriptionLink(String accessToken) async {
    final result = await HttpUtil.instance.get(
        AppUrls.userSubscribe
    );
    if (result.containsKey("data")) {
      final data = result["data"];
      if (data is String) {
        return data; // 如果 'data' 是字符串，直接返回
      }
    }
    throw Exception("Failed to reset subscription link");
  }
}
