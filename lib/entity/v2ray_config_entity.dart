import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sail/entity/server_entity.dart';
List<V2RayEntity> v2serverEntityFromList(List<dynamic> data) =>
    List<V2RayEntity>.from(data.map((x) => V2RayEntity.fromMap(x)));

class V2RayEntity {
  final String config;
  final int like;
  final int dislike;


  V2RayEntity({
    required this.config,
    required this.like,
    required this.dislike,

  });


  /// Parses a V2Ray configuration from a JSON map.
  factory V2RayEntity.fromMap(Map<String, dynamic> params) {


    return V2RayEntity(
      config: params['config'] ?? '',
      like: params['like'] ?? 0,
      dislike: params['dislike'] ?? 0,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'config': config,
      'like': like,
      'dislike': dislike,

    };
  }
  static List<V2RayEntity> parseConfigList(List<String> configs) {
    return configs.asMap().entries.map((entry) =>
        V2RayEntity.fromMap({"config":entry.value,"like":0,"dislike":0})
    ).toList();
  }
  static List<V2RayEntity> parseServerConfigList(List<Map<String, dynamic>> configs) {
    return configs.asMap().entries.map((entry) =>
        V2RayEntity.fromMap(entry.value)
    ).toList();
  }
  static List<String> parseStringConfigList(List<Map<String, dynamic>> configs) {
    return configs.asMap().entries.map((entry) =>
        entry.value["config"].toString()
    ).toList();
  }
<<<<<<< HEAD
  static List<String> parseStringConfigListDynamic(List< dynamic> configs) {
    return configs.asMap().entries.map((entry) =>
        entry.value["config"].toString()
    ).toList();
  }
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67


}
