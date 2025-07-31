import 'package:event_booking_app/app/models/payment_method_model.dart';
import 'package:event_booking_app/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Payment Method Controller
class PaymentMethodController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // API Base URL - Update this to your actual API URL
  final String baseUrl = 'https://event-booking-backend-k2i1.onrender.com/app';

  // Observable variables
  final isLoading = false.obs;
  final RxList<PaymentMethodModel> paymentMethods = <PaymentMethodModel>[].obs;
  final Rx<PaymentMethodModel?> selectedPaymentMethod =
      Rx<PaymentMethodModel?>(null);

  @override
  void onInit() {
    super.onInit();
    getPaymentMethods();
  }

  // Get payment methods from API
  Future<void> getPaymentMethods() async {
    try {
      isLoading.value = true;

      final token = await _storageService.getToken();
      if (token == null) {
        Get.snackbar('Error', 'No authentication token found');
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/payment-methods'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 200) {
          final List<dynamic> data = responseData['data'] ?? [];
          paymentMethods.value =
              data.map((item) => PaymentMethodModel.fromJson(item)).toList();
        } else {
          Get.snackbar('Error',
              responseData['message'] ?? 'Failed to load payment methods');
        }
      } else {
        Get.snackbar('Error',
            'Failed to load payment methods. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Get payment methods error: $e');
      Get.snackbar('Error', 'An error occurred while loading payment methods');
    } finally {
      isLoading.value = false;
    }
  }

  // Select payment method
  void selectPaymentMethod(PaymentMethodModel method) {
    selectedPaymentMethod.value = method;
  }

  // Refresh payment methods
  Future<void> refreshPaymentMethods() async {
    await getPaymentMethods();
  }

  // Get icon for payment method based on provider
  IconData getPaymentMethodIcon(String provider) {
    switch (provider.toUpperCase()) {
      case 'ABA':
        return Icons.account_balance;
      case 'BAKONG':
        return Icons.qr_code;
      case 'CASH':
        return Icons.attach_money;
      default:
        return Icons.payment;
    }
  }

  // Get color for payment method based on provider
  Color getPaymentMethodColor(String provider) {
    switch (provider.toUpperCase()) {
      case 'ABA':
        return const Color(0xFF0077BE);
      case 'BAKONG':
        return const Color(0xFF8BC34A);
      case 'CASH':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF1E88E5);
    }
  }
}
