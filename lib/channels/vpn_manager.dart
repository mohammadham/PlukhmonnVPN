import 'package:flutter/services.dart';
import 'package:sail/channels/Platform.dart';
<<<<<<< HEAD
<<<<<<< Updated upstream
import 'package:sail/utils/common_util.dart';
=======
import 'package:sail/channels/V2RayVpnManager.dart';
import 'package:sail/resources/app_strings.dart';
import 'package:sail/utils/common_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> Stashed changes
=======
<<<<<<< HEAD
import 'package:sail/channels/V2RayVpnManager.dart';
import 'package:sail/resources/app_strings.dart';
import 'package:sail/utils/common_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
=======
import 'package:sail/utils/common_util.dart';
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55

enum VpnStatus {
  connected(code: 2),
  connecting(code: 1),
  reasserting(code: 4),
  disconnecting(code: 5),
  disconnected(code: 0),
  invalid(code: 3);

  const VpnStatus({required this.code});

  final int code;
}

class VpnManager {
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
  final MethodChannel _platform = const MethodChannel("com.sail_tunnel.sail/vpn_manager");
  final V2RayVpnManager _v2RayManager = V2RayVpnManager();

  VpnManager() {
    if (Platform.isAndroid) {
      _v2RayManager.initialize();
    }
  }
  Future<VpnStatus> getStatus() async {
    // Native channel
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    if (Platform.isAndroid) {
      bool isFree = await _isFreeAccess();
      if (isFree) {
        return await _v2RayManager.isConnected() ? VpnStatus.connected : VpnStatus.disconnected;
      } else {
        bool? result = await _platform.invokeMethod("getStatus");
        return (result ?? false) ? VpnStatus.connected : VpnStatus.disconnected;
      }
    } else {
      int result;
      try {
        result = await _platform.invokeMethod("getStatus");
      } on PlatformException catch (e) {
        print(e.toString());
        rethrow;
      }
      return VpnStatus.values.firstWhere((e) => e.code == result);
    }
  }
  Future<void> connect() async {
    if (Platform.isAndroid && await _isFreeAccess()) {
      await _v2RayManager.connect();
    } else {
      await _platform.invokeMethod("toggle");
    }
  }

  Future<void> disconnect() async {
    if (Platform.isAndroid && await _isFreeAccess()) {
      await _v2RayManager.disconnect();
    } else {
      await _platform.invokeMethod("toggle");
    }
  }
  Future<DateTime> getConnectedDate() async {
    // Native channel
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
=======
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
  Future<VpnStatus> getStatus() async {
    // Native channel
    const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    if (Platform.isAndroid || Platform.isMacOS) {
      bool? result = await platform.invokeMethod("getStatus");
      // print("${result}");
      return (result ?? false) ? VpnStatus.connected : VpnStatus.disconnected;
    }

    int result;
    try {
      // bool xxx = await platform.invokeMethod("getStatus");
      // result = xxx ? 1 : 0;
      result = await platform.invokeMethod("getStatus");
    } on PlatformException catch (e) {
      print(e.toString());

      rethrow;
    }
    return VpnStatus.values.firstWhere((e) => e.code == result);
  }

  Future<DateTime> getConnectedDate() async {
    // Native channel
    const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
<<<<<<< HEAD
=======
  final MethodChannel _platform = const MethodChannel("com.sail_tunnel.sail/vpn_manager");
  final V2RayVpnManager _v2RayManager = V2RayVpnManager();

  VpnManager() {
    if (Platform.isAndroid) {
      _v2RayManager.initialize();
    }
  }
  Future<VpnStatus> getStatus() async {
    // Native channel
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    if (Platform.isAndroid) {
      bool isFree = await _isFreeAccess();
      if (isFree) {
        return await _v2RayManager.isConnected() ? VpnStatus.connected : VpnStatus.disconnected;
      } else {
        bool? result = await _platform.invokeMethod("getStatus");
        return (result ?? false) ? VpnStatus.connected : VpnStatus.disconnected;
      }
    } else {
      int result;
      try {
        result = await _platform.invokeMethod("getStatus");
      } on PlatformException catch (e) {
        print(e.toString());
        rethrow;
      }
      return VpnStatus.values.firstWhere((e) => e.code == result);
    }
  }
  Future<void> connect() async {
    if (Platform.isAndroid && await _isFreeAccess()) {
      await _v2RayManager.connect();
    } else {
      await _platform.invokeMethod("toggle");
    }
  }

  Future<void> disconnect() async {
    if (Platform.isAndroid && await _isFreeAccess()) {
      await _v2RayManager.disconnect();
    } else {
      await _platform.invokeMethod("toggle");
    }
  }
  Future<DateTime> getConnectedDate() async {
    // Native channel
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
>>>>>>> Stashed changes
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    double result;
    try {
      if (Platform.isAndroid || Platform.isMacOS) {
        // bool? result = await platform.invokeMethod("getConnectedDate");
        return DateTime.fromMillisecondsSinceEpoch((1 * 1000).toInt());
      }
<<<<<<< HEAD
<<<<<<< Updated upstream
      result = await platform.invokeMethod("getConnectedDate");
=======
      result = await _platform.invokeMethod("getConnectedDate");
>>>>>>> Stashed changes
=======
<<<<<<< HEAD
      result = await _platform.invokeMethod("getConnectedDate");
=======
      result = await platform.invokeMethod("getConnectedDate");
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    } on PlatformException catch (e) {
      print(e.toString());

      rethrow;
    }
    return DateTime.fromMillisecondsSinceEpoch((result * 1000).toInt());
  }

  Future<bool> toggle() async {
    // Native channel
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
    if (Platform.isAndroid && await _isFreeAccess()) {
      if (await _v2RayManager.isConnected()) {
        await _v2RayManager.disconnect();
        return false;
      } else {
        await _v2RayManager.connect();
        return true;
      }
    } else {
      return await _platform.invokeMethod("toggle");
    }
=======
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    bool result = false;
    try {
      result = await platform.invokeMethod("toggle");
    } on PlatformException catch (e) {
      print(e.toString());

      rethrow;
    }
    return result;
<<<<<<< HEAD
=======
    if (Platform.isAndroid && await _isFreeAccess()) {
      if (await _v2RayManager.isConnected()) {
        await _v2RayManager.disconnect();
        return false;
      } else {
        await _v2RayManager.connect();
        return true;
      }
    } else {
      return await _platform.invokeMethod("toggle");
    }
>>>>>>> Stashed changes
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
  }

  Future<String> getTunnelLog() async {
    // Native channel
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await _platform.invokeMethod("getTunnelLog");
=======
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await platform.invokeMethod("getTunnelLog");
<<<<<<< HEAD
=======
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await _platform.invokeMethod("getTunnelLog");
>>>>>>> Stashed changes
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    } on PlatformException catch (e) {
      print(e.toString());

      rethrow;
    }
    return result;
  }

  Future<String> getTunnelConfiguration() async {
    // Native channel
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await _platform.invokeMethod("getTunnelConfiguration");
=======
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await platform.invokeMethod("getTunnelConfiguration");
<<<<<<< HEAD
=======
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await _platform.invokeMethod("getTunnelConfiguration");
>>>>>>> Stashed changes
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    } on PlatformException catch (e) {
      print(e.toString());

      rethrow;
    }
    return result;
  }

  Future<String> setTunnelConfiguration(String conf) async {
    // Native channel
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await _platform.invokeMethod("setTunnelConfiguration", conf);
=======
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await platform.invokeMethod("setTunnelConfiguration", conf);
<<<<<<< HEAD
=======
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await _platform.invokeMethod("setTunnelConfiguration", conf);
>>>>>>> Stashed changes
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    } on PlatformException catch (e) {
      print(e.toString());

      rethrow;
    }
    return result;
  }
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
=======
<<<<<<< HEAD
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
  Future<bool> _isFreeAccess() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppStrings.isFreeAccess) ?? false;
  }

  Future<String?> getCoreVersion() async {
    return await _v2RayManager.getCoreVersion();
  }

  Future<int?> getServerDelay() async {
    return await _v2RayManager.getServerDelay();
  }
<<<<<<< HEAD
>>>>>>> Stashed changes
=======
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
}
