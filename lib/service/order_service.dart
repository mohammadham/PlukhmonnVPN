// services/order_service.dart
import 'dart:convert';

import 'package:sail/constant/app_urls.dart';
import 'package:sail/entity/plan_entity.dart';
import 'package:sail/utils/http_util.dart';
import 'package:sail/service/httpServices/http_service.dart';
import 'package:sail/models/order_model.dart';
class OrderService {
  final HttpService _httpService = HttpService();

  Future<List<Order>> fetchUserOrders(String accessToken) async {
    final result = await _httpService.getRequest(
      "/api/v1/user/order/fetch",
      headers: {'Authorization': accessToken},
    );

    if (result["status"] == "success") {
      final ordersJson = result["data"] as List;
      return ordersJson
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to fetch user orders: ${result['message']}");
    }
  }

  Future<Map<String, dynamic>> getOrderDetails(
      String tradeNo, String accessToken) async {
    return await _httpService.getRequest(
      "/api/v1/user/order/detail?trade_no=$tradeNo",
      headers: {'Authorization': accessToken},
    );
  }

  Future<Map<String, dynamic>> cancelOrder(
      String tradeNo, String accessToken) async {
    return await _httpService.postRequest(
      "/api/v1/user/order/cancel",
      {"trade_no": tradeNo},
      headers: {'Authorization': accessToken},
    );
  }

  Future<Map<String, dynamic>> createOrder(
      String accessToken, int planId, String period) async {
    return await _httpService.postRequest(
      "/api/v1/user/order/save",
      {"plan_id": planId, "period": period},
      headers: {'Authorization': accessToken},
    );
  }
}
