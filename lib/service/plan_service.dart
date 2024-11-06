import 'dart:convert';

import 'package:sail/constant/app_urls.dart';
import 'package:sail/entity/plan_entity.dart';
import 'package:sail/utils/http_util.dart';

class PlanService {
  Future<List<PlanEntity>> plan() {
    print(AppUrls.plan);
    return HttpUtil.instance.get(AppUrls.plan).then((result) {
      if(result != null) {
        print("-----------Plan---------- : " + jsonEncode(result).toString());
        return (result["data"] as List).cast<Map<String, dynamic>>()
            .map((json) => PlanEntity.fromMap(json))
            .toList();
        // return planEntityFromList(result['data']);
      }
      return [];
    });
  }

  Future<PlanEntity>? planDetail(int id) {
    return HttpUtil.instance?.get(AppUrls.plan, parameters: {'id': id}).then((result) {
      return PlanEntity.fromMap(result['data']);
    });
  }
}
