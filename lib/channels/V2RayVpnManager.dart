import 'dart:convert';

import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:sail/resources/app_strings.dart';
import 'package:sail/utils/shared_preferences_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class V2RayVpnManager {
  final FlutterV2ray _v2Ray;
  bool _isProxyOnly = false;
  String _remark = "Default Remark";
  List<String> _bypassSubnets =  [
    "0.0.0.0/5",
    "8.0.0.0/7",
    "11.0.0.0/8",
    "12.0.0.0/6",
    "16.0.0.0/4",
    "32.0.0.0/3",
    "64.0.0.0/2",
    "128.0.0.0/3",
    "160.0.0.0/5",
    "168.0.0.0/6",
    "172.0.0.0/12",
    "172.32.0.0/11",
    "172.64.0.0/10",
    "172.128.0.0/9",
    "173.0.0.0/8",
    "174.0.0.0/7",
    "176.0.0.0/4",
    "192.0.0.0/9",
    "192.128.0.0/11",
    "192.160.0.0/13",
    "192.169.0.0/16",
    "192.170.0.0/15",
    "192.172.0.0/14",
    "192.176.0.0/12",
    "192.192.0.0/10",
    "193.0.0.0/8",
    "194.0.0.0/7",
    "196.0.0.0/6",
    "200.0.0.0/5",
    "208.0.0.0/4",
    "240.0.0.0/4",
  ];
  bool _isRunning = false;

  V2RayVpnManager()
      : _v2Ray = FlutterV2ray(
    onStatusChanged: (status) {
      // initializeLoading( status.state == "CONNECTED");
      print("V2Ray Status Changed: ${status.state}");
    },
  );
  void initializeLoading(bool status)=>this._isRunning = status;
  Future<void> initialize() async {
    await _v2Ray.initializeV2Ray();
  }

  Future<bool> connect() async {
    String? config = await _getV2RayConfig();
    if (config == null) {
      print("No valid V2Ray configuration found.");
      return false;
    }

    if (!await _v2Ray.requestPermission()) {
      print("Permission denied for V2Ray.");
      return false;
    }

    await _v2Ray.startV2Ray(
      remark: _remark,
      config: jsonEncode(config),
      // proxyOnly: _isProxyOnly,
      bypassSubnets: _bypassSubnets,
    );
    print("V2Ray connection started with config.");
    initializeLoading(true);
    return true;
  }

  Future<void> disconnect() async {
    await _v2Ray.stopV2Ray();
    print("V2Ray connection stopped.");
    initializeLoading(false);
  }

  bool isConnected() {
    return _isRunning;
  }

  Future<String?> getCoreVersion() async {
    return await _v2Ray.getCoreVersion();
  }

  Future<int?> getServerDelay() async {
    return _isRunning ? await _v2Ray.getConnectedServerDelay() : null;
  }

  void setProxyOnlyMode(bool isProxyOnly) {
    _isProxyOnly = isProxyOnly;
  }

  void setBypassSubnets(List<String> subnets) {
    _bypassSubnets = subnets;
  }

  Future<String?> _getV2RayConfig() async {
    final prefs = await SharedPreferencesUtil.getInstance();
    final prefs2 = await SharedPreferences.getInstance();
    List< dynamic> serverList = await prefs
        ?.getList(AppStrings.freeServers) ?? [];

    int serverIndex = prefs2.getInt(AppStrings.freeServerIndex)??0;

    if (serverList == null || serverList.isEmpty) {
      print("No V2Ray configuration available in SharedPreferences.");
      return null;
    }

    return serverList[serverIndex]["config"]; // Example: use the first server config
  }
}
