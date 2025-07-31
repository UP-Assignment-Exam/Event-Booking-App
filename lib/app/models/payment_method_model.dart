import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Payment Method Model
class PaymentMethodModel {
  final String id;
  final String name;
  final String provider;
  final String type;
  final double processingFee;
  final String description;
  final String imageUrl;
  final List<String> supportedCurrencies;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.provider,
    required this.type,
    required this.processingFee,
    required this.description,
    required this.supportedCurrencies,
    required this.imageUrl,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      provider: json['provider'] ?? '',
      type: json['type'] ?? '',
      processingFee: (json['processingFee'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      supportedCurrencies: List<String>.from(json['supportedCurrencies'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'provider': provider,
      'type': type,
      'processingFee': processingFee,
      'description': description,
      'imageUrl': imageUrl,
      'supportedCurrencies': supportedCurrencies,
    };
  }
}
