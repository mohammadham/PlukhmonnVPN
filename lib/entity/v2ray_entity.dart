import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sail/entity/server_entity.dart';
List<V2RayConfig> v2serverEntityFromList(List<dynamic> data) =>
    List<V2RayConfig>.from(data.map((x) => V2RayConfig.fromMap(x)));

class V2RayConfig {
  final String baseType;
  final String uuid;
  final String address;
  final String port;
  final String security;
  final String sni;
  final String alpn;
  final String fp;
  final String type;
  final String path;
  final String host;
  final String encryption;
  final String name;
  final String flow;
  final String multiplex;
  final String allowInsecure;
  final String? pbk;
  final String? sid;
  final String? password;
  final int? gid;
  final int? id;
  final String? report;
  final int? dlTraffic;
  final int? ulTraffic;
  final int? yc;

  V2RayConfig({
    required this.baseType,
    required this.uuid,
    required this.address,
    required this.port,
    required this.security,
    required this.sni,
    required this.alpn,
    required this.fp,
    required this.type,
    required this.path,
    required this.host,
    required this.encryption,
    required this.name,
    required this.flow,
    required this.multiplex,
    required this.allowInsecure,
    this.pbk,
    this.sid,
    this.password,
    this.gid,
    this.id,
    this.report,
    this.dlTraffic,
    this.ulTraffic,
    this.yc,
  });

  /// Parses a V2Ray configuration from a URL string with support for vless, vmess, trojan, and shadowsocks.
  factory V2RayConfig.fromV2RayConfigString(String config) {
<<<<<<< HEAD
<<<<<<< Updated upstream
    try { // Detect if Base64 encoding is used and decode if necessary
    String decodedConfig;
=======
    var decodedConfig ;
    try { // Detect if Base64 encoding is used and decode if necessary

>>>>>>> Stashed changes
=======
<<<<<<< HEAD
    var decodedConfig ;
    try { // Detect if Base64 encoding is used and decode if necessary

=======
    try { // Detect if Base64 encoding is used and decode if necessary
    String decodedConfig;
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    if (config.startsWith('vmess://') || config.startsWith('ss://')) {
      final encodedPart = config.split('://')[1];
      decodedConfig = utf8.decode(base64Url.decode(encodedPart));
    } else {
      decodedConfig = config;
    }

<<<<<<< HEAD
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
    var uri;
    var params;
    if (config.startsWith('vmess://') || config.startsWith('ss://')) {
      uri = Uri.parse(config);
       params = jsonDecode(decodedConfig);
    } else {
       uri = Uri.parse(decodedConfig);
       params = uri.queryParameters;
    }


    return V2RayConfig(
      baseType: uri.scheme ,
      uuid: params['id'] ?? uri.userInfo,
      address: params['add'] ?? uri.host ?? params['host'],
      port: (params['port'] != null && params['port'] != ''? params['port']: params['port'] ?? uri.port).toString(),
      security: params['security'] ?? params['scy']??'none',
      sni: params['sni'] ?? '',
      alpn: params['alpn'] ?? '',
      fp: params['fp'] ?? '',
      type: (params['type'] ?? '') =='none'? params['net']??params['type']:params['type']??'',
      path: params['path'] ?? '/',
      host: params['host'] ?? '',
      encryption: params['encryption'] ?? 'none',
      name: params['ps'] ?? uri.fragment,
      flow: params['flow'] ?? '',
      multiplex: params['multiplex'] ?? '',
      allowInsecure: params['allowInsecure'] ?? '1',
      pbk: (params['pbk']??"").toString(),
      sid: (params['sid']??"").toString(),
      password: (params['id'] ?? uri.userInfo).toString(),  // for protocols that use userInfo as password
    );
    } catch (e) {
      throw Exception('Error parsing V2Ray configuration: $e   ' + decodedConfig.runtimeType.toString());
=======
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    final uri = Uri.parse(decodedConfig);
    final params = uri.queryParameters;

    return V2RayConfig(
      baseType: uri.scheme,
      uuid: params['uuid'] ?? uri.userInfo,
      address: uri.host,
      port: uri.port.toString(),
      security: params['security'] ?? 'none',
      sni: params['sni'] ?? '',
      alpn: params['alpn'] ?? '',
      fp: params['fp'] ?? '',
      type: params['type'] ?? '',
      path: params['path'] ?? '/',
      host: params['host'] ?? '',
      encryption: params['encryption'] ?? 'none',
      name: uri.fragment,
      flow: params['flow'] ?? '',
      multiplex: params['multiplex'] ?? '',
      allowInsecure: params['allowInsecure'] ?? '1',
      pbk: params['pbk'],
      sid: params['sid'],
      password: uri.userInfo,  // for protocols that use userInfo as password
    );
    } catch (e) {
      throw Exception('Error parsing V2Ray configuration: $e');
<<<<<<< HEAD
=======
    var uri;
    var params;
    if (config.startsWith('vmess://') || config.startsWith('ss://')) {
      uri = Uri.parse(config);
       params = jsonDecode(decodedConfig);
    } else {
       uri = Uri.parse(decodedConfig);
       params = uri.queryParameters;
    }


    return V2RayConfig(
      baseType: uri.scheme ,
      uuid: params['id'] ?? uri.userInfo,
      address: params['add'] ?? uri.host ?? params['host'],
      port: (params['port'] != null && params['port'] != ''? params['port']: params['port'] ?? uri.port).toString(),
      security: params['security'] ?? params['scy']??'none',
      sni: params['sni'] ?? '',
      alpn: params['alpn'] ?? '',
      fp: params['fp'] ?? '',
      type: (params['type'] ?? '') =='none'? params['net']??params['type']:params['type']??'',
      path: params['path'] ?? '/',
      host: params['host'] ?? '',
      encryption: params['encryption'] ?? 'none',
      name: params['ps'] ?? uri.fragment,
      flow: params['flow'] ?? '',
      multiplex: params['multiplex'] ?? '',
      allowInsecure: params['allowInsecure'] ?? '1',
      pbk: (params['pbk']??"").toString(),
      sid: (params['sid']??"").toString(),
      password: (params['id'] ?? uri.userInfo).toString(),  // for protocols that use userInfo as password
    );
    } catch (e) {
      throw Exception('Error parsing V2Ray configuration: $e   ' + decodedConfig.runtimeType.toString());
>>>>>>> Stashed changes
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    }
  }

  /// Parses a V2Ray configuration from a JSON map.
  factory V2RayConfig.fromMap(Map<String, dynamic> params) {
    final bean = params['bean'] ?? {};

    return V2RayConfig(
      baseType: params['type'] ?? '',
      uuid: bean['id'] ?? bean['pass'] ?? '',
      address: bean['addr'] ?? '',
      port: bean['port'].toString(),
      security: bean['sec'] ?? 'none',
      sni: bean['stream']?['sni'] ?? '',
      alpn: bean['stream']?['alpn'] ?? '',
      fp: bean['stream']?['utls'] ?? '',
      type: bean['stream']?['net'] ?? '',
      path: bean['stream']?['path'] ?? '/',
      host: bean['stream']?['host'] ?? '',
      encryption: bean['method'] ?? 'none',
      name: bean['name'] ?? '',
      flow: params['flow']??'',
      multiplex: bean['stream']?['mux_s']?.toString() ?? '0',
      allowInsecure: bean['stream']?['insecure']?.toString() ?? 'false',
      pbk: params['pbk'],
      sid: params['sid'],
      password: bean['pass'] ?? bean['id'] ?? '',
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
      gid: int.parse(params['gid'].toString()),
      id: int.parse(params['id'].toString()),
      report: params['report'],
      dlTraffic: int.parse((params['traffic']?['dl']).toString()),
      ulTraffic: int.parse((params['traffic']?['ul']).toString()),
      yc: int.parse(params['yc'].toString()),
=======
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
      gid: params['gid'],
      id: params['id'],
      report: params['report'],
      dlTraffic: params['traffic']?['dl'],
      ulTraffic: params['traffic']?['ul'],
      yc: params['yc'],
<<<<<<< HEAD
=======
      gid: int.parse(params['gid'].toString()),
      id: int.parse(params['id'].toString()),
      report: params['report'],
      dlTraffic: int.parse((params['traffic']?['dl']).toString()),
      ulTraffic: int.parse((params['traffic']?['ul']).toString()),
      yc: int.parse(params['yc'].toString()),
>>>>>>> Stashed changes
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base-type': baseType,
      'uuid': uuid,
      'address': address,
      'port': port,
      'security': security,
      'sni': sni,
      'alpn': alpn,
      'fp': fp,
      'type': type,
      'path': path,
      'host': host,
      'encryption': encryption,
      'name': name,
      'flow': flow,
      'multiplex': multiplex,
      'allowInsecure': allowInsecure,
      'pbk': pbk,
      'sid': sid,
      'password': password,
      'gid': gid,
      'id': id,
      'report': report,
      'traffic': {
        'dl': dlTraffic,
        'ul': ulTraffic,
      },
      'yc': yc,
    };
  }
  static List<V2RayConfig> parseConfigList(List<String> configs) {
    return configs.map((config) => V2RayConfig.fromV2RayConfigString(config)).toList();
  }
  static List<ServerEntity> parseServerConfigList(List<String> configs) {
    return configs.asMap().entries.map((entry) =>
        serverEntityFromVlessLink(entry.value, entry.key + 1)
    ).toList();
  }

  static ServerEntity serverEntityFromVlessLink(String vlessLink, int index) {
    // Parsing the URI and extracting query parameters
    final uri = Uri.parse(vlessLink);
    final params = uri.queryParameters;
    final name = uri.fragment; // The fragment after '#' in the URL
    final uuid = uri.userInfo;
    final host = uri.host;
    final port = uri.port != 0 ? uri.port : 1080; // Default port if none specified

    return ServerEntity(
      id: index, // Use index directly
      groupId: ['free'], // Default group ID list
      parentId: null, // Not provided in the link
      tags: ['free'], // Default tag
      name: name.isNotEmpty ? name : 'Unnamed Server',
      rate: '1', // Default rate
      host: host,
      port: port,
      serverPort: port, // Default to same port for serverPort
      cipher: 'auto', // Default cipher
      show: 1, // Visibility (1 = visible, 0 = hidden)
      sort: 1, // Default sort value
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      type: 'vless',
      lastCheckAt: "",
    );
  }

}
