import 'package:flutter/services.dart';
import 'package:sail/channels/Platform.dart';
<<<<<<< Updated upstream
import 'package:sail/utils/common_util.dart';
=======
import 'package:sail/channels/V2RayVpnManager.dart';
import 'package:sail/resources/app_strings.dart';
import 'package:sail/utils/common_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
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
    double result;
    try {
      if (Platform.isAndroid || Platform.isMacOS) {
        // bool? result = await platform.invokeMethod("getConnectedDate");
        return DateTime.fromMillisecondsSinceEpoch((1 * 1000).toInt());
      }
<<<<<<< Updated upstream
      result = await platform.invokeMethod("getConnectedDate");
=======
      result = await _platform.invokeMethod("getConnectedDate");
>>>>>>> Stashed changes
    } on PlatformException catch (e) {
      print(e.toString());

      rethrow;
    }
    return DateTime.fromMillisecondsSinceEpoch((result * 1000).toInt());
  }

  Future<bool> toggle() async {
    // Native channel
<<<<<<< Updated upstream
    const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    bool result = false;
    try {
      result = await platform.invokeMethod("toggle");
    } on PlatformException catch (e) {
      print(e.toString());

      rethrow;
    }
    return result;
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
  }

  Future<String> getTunnelLog() async {
    // Native channel
<<<<<<< Updated upstream
    const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await platform.invokeMethod("getTunnelLog");
=======
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await _platform.invokeMethod("getTunnelLog");
>>>>>>> Stashed changes
    } on PlatformException catch (e) {
      print(e.toString());

      rethrow;
    }
    return result;
  }

  Future<String> getTunnelConfiguration() async {
    // Native channel
<<<<<<< Updated upstream
    const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await platform.invokeMethod("getTunnelConfiguration");
=======
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await _platform.invokeMethod("getTunnelConfiguration");
>>>>>>> Stashed changes
    } on PlatformException catch (e) {
      print(e.toString());

      rethrow;
    }
    return result;
  }

  Future<String> setTunnelConfiguration(String conf) async {
    // Native channel
<<<<<<< Updated upstream
    const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await platform.invokeMethod("setTunnelConfiguration", conf);
=======
    // const platform = MethodChannel("com.sail_tunnel.sail/vpn_manager");
    String result;
    try {
      result = await _platform.invokeMethod("setTunnelConfiguration", conf);
>>>>>>> Stashed changes
    } on PlatformException catch (e) {
      print(e.toString());

      rethrow;
    }
    return result;
  }
<<<<<<< Updated upstream
=======
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
>>>>>>> Stashed changes
}
