// To parse this JSON data, do
//
//     final planEntity = planEntityFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:html/parser.dart' as html_parser;
List<PlanEntity> planEntityFromList(List data) => List<PlanEntity>.from(data.map((x) => PlanEntity.fromMap(x)));

class PlanEntity {
  PlanEntity({
    required this.id,
    required this.groupId,
    required this.transferEnable,
    required this.name,
    required this.speedLimit,
    required this.show,
    this.sort,
    this.renew,
    this.content,
    this.onetimePrice,
    this.monthPrice,
    this.quarterPrice,
    this.halfYearPrice,
    this.yearPrice,
    this.twoYearPrice,
    this.threeYearPrice,
    this.resetPrice,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int groupId;
  final double transferEnable;
  final String name;
  final int speedLimit;
  final bool show;
  final dynamic? sort;
  final int? renew;
  final String? content;
  final double? monthPrice;
  final double? quarterPrice;
  final double? halfYearPrice;
  final double? yearPrice;
  final double? twoYearPrice;
  final double? threeYearPrice;
  final double? onetimePrice;
  final double? resetPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PlanEntity.fromJson(String str) => PlanEntity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlanEntity.fromMap(Map<String, dynamic> json) {
    final rawContent = json['content'] ?? '';
    final document = html_parser.parse(rawContent);
    final cleanContent = document.body?.text ?? '';

    return PlanEntity(
      id: json['id'] is int ? json['id'] as int : 0,
      groupId: json['group_id'] is int ? json['group_id'] as int : 0,
      transferEnable: json['transfer_enable'] is num
          ? (json['transfer_enable'] as num).toDouble()
          : 0.0,
      name: json['name'] is String ? json['name'] as String : 'Undefinded',
      speedLimit: json['speed_limit'] is int ? json['speed_limit'] as int : 0,
      show: json['show'] == 1, // 布尔类型处理
    sort: json["sort"],
    renew: json["renew"],
      // 清理后的内容
      content: cleanContent.isNotEmpty ? cleanContent : null,
      // 处理价格字段
      onetimePrice: json['onetime_price'] != null
          ? (json['onetime_price']! as num).toDouble() / 100
          : null,
      monthPrice: json['month_price'] != null
          ? (json['month_price']! as num).toDouble() / 100
          : null,
      quarterPrice: json['quarter_price'] != null
          ? (json['quarter_price']! as num).toDouble() / 100
          : null,
      halfYearPrice: json['half_year_price'] != null
          ? (json['half_year_price']! as num).toDouble() / 100
          : null,
      yearPrice: json['year_price'] != null
          ? (json['year_price']! as num).toDouble() / 100
          : null,
      twoYearPrice: json['two_year_price'] != null
          ? (json['two_year_price']! as num).toDouble() / 100
          : null,
      threeYearPrice: json['three_year_price'] != null
          ? (json['three_year_price']! as num).toDouble() / 100
          : null,

    resetPrice: json["reset_price"]!= null
        ? (json['reset_price']! as num).toDouble() / 100
        : null,
    createdAt: json["created_at"] == null ? null : DateTime.fromMillisecondsSinceEpoch(json["created_at"] * 1000),
    updatedAt: json["updated_at"] == null ? null : DateTime.fromMillisecondsSinceEpoch(json["updated_at"] * 1000),
  );}

  Map<String, dynamic> toMap() => {
    "id": id,
    "group_id": groupId,
    "transfer_enable": transferEnable,
    "name": name,
    "show": show,
    "sort": sort,
    "renew": renew,
    "content": content,
    "month_price": monthPrice,
    "quarter_price": quarterPrice,
    "half_year_price": halfYearPrice,
    "year_price": yearPrice,
    "two_year_price": twoYearPrice,
    "three_year_price": threeYearPrice,
    "onetime_price": onetimePrice,
    "reset_price": resetPrice,
    "created_at": createdAt == null ? null : createdAt!.millisecondsSinceEpoch ~/ 1000,
    "updated_at": updatedAt == null ? null : updatedAt!.millisecondsSinceEpoch ~/ 1000,
  };
}
