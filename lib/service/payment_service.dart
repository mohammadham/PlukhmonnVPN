// services/payment_service.dart
import 'dart:convert';

import 'package:sail/constant/app_urls.dart';
import 'package:sail/entity/plan_entity.dart';
import 'package:sail/utils/http_util.dart';
import 'package:sail/service/httpServices/http_service.dart';
class PaymentService {
  final HttpService _httpService = HttpService();

  Future<Map<String, dynamic>> submitOrder(
      String tradeNo, String method, String accessToken,) async {
    return await _httpService.postRequest(
      "/api/v1/user/order/checkout",
      {"trade_no": tradeNo, "method": method},
      headers: {'Authorization': accessToken},
    );
  }

  Future<List<dynamic>> getPaymentMethods(String accessToken) async {
    final response = await _httpService.getRequest(
      "/api/v1/user/order/getPaymentMethod",
      headers: {'Authorization': accessToken},
    );
    return (response['data'] as List).cast<dynamic>();
  }
}
