// To parse this JSON data, do
//
//     final userEntity = userEntityFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class UserEntity {
  UserEntity({
    required this.email,
    required this.transferEnable,
     this.lastLoginAt,
    required this.createdAt,
    required this.banned,
    required this.remindExpire,
    required this.remindTraffic,
     this.expiredAt,
    required this.balance,
    required this.commissionBalance,
    required this.planId,
    @required this.discount,
    @required this.commissionRate,
    @required this.telegramId,
    required this.uuid,
    required this.avatarUrl,
  });

  final String email;
  final double transferEnable;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final bool banned;
  final bool remindExpire;
  final bool remindTraffic;
  final DateTime? expiredAt;
  final double balance;
  final double commissionBalance;
  final int planId;
  final dynamic? discount;
  final dynamic? commissionRate;
  final dynamic? telegramId;
  final String uuid;
  final String avatarUrl;

  factory UserEntity.fromJson(String str) =>
      UserEntity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserEntity.fromMap(Map<String, dynamic> json) => UserEntity(
        email: json['email'] as String? ?? '',
        transferEnable:  (json['transfer_enable'] as num?)?.toDouble() ?? 0.0,
        lastLoginAt: json["last_login_at"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["last_login_at"] * 1000),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["created_at"] * 1000),
    // 处理布尔值
<<<<<<< HEAD
<<<<<<< Updated upstream
    banned: (json['banned'] as int? ?? 0) == 1,
    remindExpire: (json['remind_expire'] as int? ?? 0) == 1,
    remindTraffic: (json['remind_traffic'] as int? ?? 0) == 1,
=======
    banned: json['banned'] is bool ? json['banned']: (json['banned'] as int? ?? 0) == 1,
    remindExpire: json['remind_expire'] is bool ? json['remind_expire']:(json['remind_expire'] as int? ?? 0) == 1,
    remindTraffic: json['remind_traffic'] is bool ? json['remind_traffic']:(json['remind_traffic'] as int? ?? 0) == 1,
>>>>>>> Stashed changes
=======
<<<<<<< HEAD
    banned: json['banned'] is bool ? json['banned']: (json['banned'] as int? ?? 0) == 1,
    remindExpire: json['remind_expire'] is bool ? json['remind_expire']:(json['remind_expire'] as int? ?? 0) == 1,
    remindTraffic: json['remind_traffic'] is bool ? json['remind_traffic']:(json['remind_traffic'] as int? ?? 0) == 1,
=======
    banned: (json['banned'] as int? ?? 0) == 1,
    remindExpire: (json['remind_expire'] as int? ?? 0) == 1,
    remindTraffic: (json['remind_traffic'] as int? ?? 0) == 1,
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
        expiredAt: json["expired_at"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["expired_at"] * 1000),

    // 转换 balance 为 double，并处理 null
    balance: (json['balance'] as num?)?.toDouble() ?? 0.0,

    // 转换 commissionBalance 为 double，并处理 null
    commissionBalance:
    (json['commission_balance'] as num?)?.toDouble() ?? 0.0,
    // 保证 planId 是 int，提供默认值 0
    planId: json['plan_id'] as int? ?? 0,
    // 允许 discount 和 commissionRate 为 null
    discount: (json['discount'] as num?)?.toDouble(),
    commissionRate: (json['commission_rate'] as num?)?.toDouble(),

    // 允许 telegramId 为 null
    telegramId: json['telegram_id'] as String?,
    // uuid 和 avatarUrl，如果为 null 返回空字符串
    uuid: json['uuid'] as String? ?? '',
    avatarUrl: json['avatar_url'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "transfer_enable": transferEnable,
        "last_login_at": lastLoginAt == null
            ? null
            : lastLoginAt!.millisecondsSinceEpoch ~/ 1000,
        "created_at": createdAt == null
            ? null
            : createdAt!.millisecondsSinceEpoch ~/ 1000,
        "banned": banned,
        "remind_expire": remindExpire,
        "remind_traffic": remindTraffic,
        "expired_at": expiredAt == null
            ? null
            : expiredAt!.millisecondsSinceEpoch ~/ 1000,
        "balance": balance,
        "commission_balance": commissionBalance,
        "plan_id": planId,
        "discount": discount,
        "commission_rate": commissionRate,
        "telegram_id": telegramId,
        "uuid": uuid,
        "avatar_url": avatarUrl,
      };
}
