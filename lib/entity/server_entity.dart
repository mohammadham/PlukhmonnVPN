// To parse this JSON data, do
//
//     final serverEntity = serverEntityFromMap(jsonString);

import 'dart:convert';

List<ServerEntity> serverEntityFromList(List<dynamic> data) =>
    List<ServerEntity>.from(data.map((x) => ServerEntity.fromMap((x))));

// List<ServerEntity> serverEntityFromListServerEntity(List<ServerEntity> data) =>
//     List<ServerEntity>.from(data.map((x) => ServerEntity.fromMap((x))));

class ServerEntity {
  ServerEntity({
    required this.id,
    required this.groupId,
    required this.parentId,
    required this.tags,
    required this.name,
    required this.rate,
    required this.host,
    required this.port,
    required this.serverPort,
    required this.cipher,
    required this.show,
    required this.sort,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.lastCheckAt,
  });

   int id;
  final List<String> groupId;
  final int? parentId;
  final List<String> tags;
  final String name;
  final String rate;
  final String host;
  final int port;
  final int serverPort;
  final String cipher;
  final int show;
  final int sort;
  Duration? ping;
  final int createdAt;
  final int updatedAt;
  final String type;
  final String lastCheckAt;

  factory ServerEntity.fromJson(String str) =>
      ServerEntity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ServerEntity.fromMap(Map<String, dynamic> json) => ServerEntity(
        id: json["id"],
        groupId: List<String>.from(json["group_id"]?.map((x) => x) ?? []),
        parentId: json["parent_id"] != null ? int.parse(json["parent_id"].toString()) :null,
        tags: List<String>.from(json["tags"]?.map((x) => x) ?? []),
        name: "" + json["name"],
        rate: json["rate"],
        host: json["host"] ?? "",
        port: int.parse(json["port"] != null ? json["port"].toString(): "0"),
        serverPort:
            int.parse(json["server_port"] != null?json["server_port"].toString() : "0"), //json["server_port"],
        cipher: json["cipher"] ?? "",
        show: json["show"]??0,
        sort: json["sort"]??0,
        createdAt: json["created_at"]??DateTime.now().millisecond,
        updatedAt: json["updated_at"]??DateTime.now().millisecond,
        type: json["type"],
        lastCheckAt:  json["last_check_at"] ??"",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "group_id": List<dynamic>.from(groupId.map((x) => x)),
        "parent_id": parentId,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "name": name,
        "rate": rate,
        "host": host,
        "port": port,
        "server_port": serverPort,
        "cipher": cipher,
        "show": show,
        "sort": sort,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "type": type,
        "last_check_at": lastCheckAt,
      };

  factory ServerEntity.fromV2RayConfigString(String config) {
    var decodedConfig ;
    try { // Detect if Base64 encoding is used and decode if necessary

      if (config.startsWith('vmess://') || config.startsWith('ss://')) {
        final encodedPart = config.split('://')[1];
        decodedConfig = utf8.decode(base64Url.decode(encodedPart));
      } else {
        decodedConfig = config;
      }

      var uri;
      var params;
      if (config.startsWith('vmess://') || config.startsWith('ss://')) {
        uri = Uri.parse(config);
        params = jsonDecode(decodedConfig);
      } else {
        uri = Uri.parse(decodedConfig);
        params = uri.queryParameters;
      }


      return ServerEntity(
        type: uri.scheme ,
        id: 0,
        groupId: ['free'], // Default group ID list
        parentId: null, // Not provided in the link
        tags: ['free'], // Default tag
        port: int.parse((params['port'] != null && params['port'] != ''? params['port'].toString(): params['port'] ?? uri.port).toString()),
        serverPort: int.parse((params['port'] != null && params['port'] != ''? params['port'].toString(): params['port'] ?? uri.port).toString()), // Default to same port for serverPort
        cipher: 'auto', // Default cipher
        rate: '1', // Default rate
        show: 1, // Visibility (1 = visible, 0 = hidden)
        sort: 1, // Default sort value
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        host: params['host'] ?? '',
        name: params['ps'] ?? uri.fragment,
        lastCheckAt: "",
      );
    } catch (e) {
      throw Exception('Error parsing V2Ray configuration: $e   ' + decodedConfig.runtimeType.toString());
    }
  }
}
