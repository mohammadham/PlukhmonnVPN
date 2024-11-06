import 'package:flutter/material.dart';

import 'package:sail/entity/plan_entity.dart';
import 'package:sail/service/order_service.dart';
import 'package:sail/service/payment_service.dart';
import 'package:sail/service/plan_service.dart';
import 'package:sail/service/subscription.dart';
import 'package:sail/utils/storage/token_storage.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class PurchaseService {
  Future<List<PlanEntity>> fetchPlanData() async {
    final accessToken = await getToken();
    if (accessToken == null) {
      print("No access token found.");
      return [];
    }

    return await PlanService().plan();
  }

  Future<void> addSubscription(
    BuildContext context,
    String accessToken,
    WidgetRef ref,
    Function showSnackbar,
  ) async {
    // Subscription.updateSubscription(context, ref);
    print("edit need --------");
  }

  final OrderService _orderService = OrderService();
  final PaymentService _paymentService = PaymentService();

  Future<Map<String, dynamic>?> createOrder(
      int planId, String period, String accessToken) async {
    return await _orderService.createOrder(accessToken, planId, period);
  }

  Future<List<dynamic>> getPaymentMethods(String accessToken) async {
    return await _paymentService.getPaymentMethods(accessToken);
  }

  Future<Map<String, dynamic>> submitOrder(
      String tradeNo, String method, String accessToken) async {
    return await _paymentService.submitOrder(tradeNo, method, accessToken);
  }
}
