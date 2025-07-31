import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketType {
  final String ticketTypeId;
  final double price;
  final int quantity;
  final int soldQuantity;
  final String id;

  TicketType({
    required this.ticketTypeId,
    required this.price,
    required this.quantity,
    required this.soldQuantity,
    required this.id,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      ticketTypeId: json['ticketTypeId'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      soldQuantity: json['soldQuantity'] ?? 0,
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketTypeId': ticketTypeId,
      'price': price,
      'quantity': quantity,
      'soldQuantity': soldQuantity,
      '_id': id,
    };
  }
}

class DisabledPurchase {
  final String unit;
  final int value;

  DisabledPurchase({
    required this.unit,
    required this.value,
  });

  factory DisabledPurchase.fromJson(Map<String, dynamic> json) {
    return DisabledPurchase(
      unit: json['unit'] ?? 'day',
      value: json['value'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unit': unit,
      'value': value,
    };
  }
}

class EventModel {
  final String id;
  final String title;
  final String? description;
  final String? organization;
  final String? createdBy;
  final String? category;
  final List<TicketType> ticketTypes;
  final bool isPurchasable;
  final String? startDate;
  final String? endDate;
  final bool isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final DisabledPurchase? disabledPurchase;

  // Additional fields for UI (can be null if not provided by API)
  final String? imageUrl;
  final String? location;
  final String? locationName;
  final String? locationAddress;
  final String? organizerName;
  final String? organizerImageUrl;
  final Color? backgroundColor;

  // Computed properties for UI
  String get displayDate {
    if (startDate == null) return '';
    try {
      final date = DateTime.parse(startDate!);
      final day = DateFormat('dd').format(date);
      final month = DateFormat('MMM').format(date).toUpperCase();
      return '$day\n$month';
    } catch (e) {
      return '';
    }
  }

  String get formattedDate {
    if (startDate == null) return '';
    try {
      final date = DateTime.parse(startDate!);
      return DateFormat('dd MMMM, yyyy').format(date);
    } catch (e) {
      return '';
    }
  }

  String get time {
    if (startDate == null || endDate == null) return '';
    try {
      final start = DateTime.parse(startDate!);
      final end = DateTime.parse(endDate!);
      final startTime = DateFormat('h:mmA').format(start);
      final endTime = DateFormat('h:mmA').format(end);
      return '$startTime - $endTime';
    } catch (e) {
      return '';
    }
  }

  double get minPrice {
    if (ticketTypes.isEmpty) return 0.0;
    return ticketTypes.map((t) => t.price).reduce((a, b) => a < b ? a : b);
  }

  double get maxPrice {
    if (ticketTypes.isEmpty) return 0.0;
    return ticketTypes.map((t) => t.price).reduce((a, b) => a > b ? a : b);
  }

  int get totalTickets {
    return ticketTypes.fold(0, (sum, ticket) => sum + ticket.quantity);
  }

  int get availableTickets {
    return ticketTypes.fold(
        0, (sum, ticket) => sum + (ticket.quantity - ticket.soldQuantity));
  }

  EventModel({
    required this.id,
    required this.title,
    this.description,
    this.organization,
    this.createdBy,
    this.category,
    this.ticketTypes = const [],
    this.isPurchasable = true,
    this.startDate,
    this.endDate,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
    this.disabledPurchase,
    this.imageUrl,
    this.location,
    this.locationName,
    this.locationAddress,
    this.organizerName,
    this.organizerImageUrl,
    this.backgroundColor,
  });

  // Factory constructor for API response
  factory EventModel.fromApiJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      organization: json['organization'],
      createdBy: json['createdBy'],
      category: json['category'],
      ticketTypes: (json['ticketTypes'] as List<dynamic>?)
              ?.map((ticket) => TicketType.fromJson(ticket))
              .toList() ??
          [],
      isPurchasable: json['isPurchasable'] ?? true,
      startDate: json['startDate'],
      endDate: json['endDate'],
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      disabledPurchase: json['disabledPurchase'] != null
          ? DisabledPurchase.fromJson(json['disabledPurchase'])
          : null,
      imageUrl: json['imageUrl'],
      location: json['location'],
      // Set default values for UI fields if not provided
      locationName: json['location'] ?? 'Location TBD',
      locationAddress: json['locationAddress'] ?? '',
      organizerName: json['organizerName'] ?? 'Event Organizer',
      organizerImageUrl: json['organizerImageUrl'],
      backgroundColor: _getRandomBackgroundColor(),
    );
  }

  // Factory constructor for local/mock data (your existing format)
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
      startDate: json['date'], // Assuming 'date' field contains start date
      endDate: json['endDate'],
      locationName: json['locationName'] ?? '',
      locationAddress: json['locationAddress'] ?? '',
      organizerName: json['organizerName'] ?? '',
      organizerImageUrl: json['organizerImageUrl'],
      backgroundColor: json['backgroundColor'] != null
          ? Color(json['backgroundColor'])
          : _getRandomBackgroundColor(),
      isPurchasable: json['isPurchasable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'organization': organization,
      'createdBy': createdBy,
      'category': category,
      'ticketTypes': ticketTypes.map((t) => t.toJson()).toList(),
      'isPurchasable': isPurchasable,
      'startDate': startDate,
      'endDate': endDate,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'disabledPurchase': disabledPurchase?.toJson(),
      'imageUrl': imageUrl,
      'location': location,
      'locationName': locationName,
      'locationAddress': locationAddress,
      'organizerName': organizerName,
      'organizerImageUrl': organizerImageUrl,
    };
  }

  // Helper method to generate random background colors for UI
  static Color _getRandomBackgroundColor() {
    final colors = [
      const Color(0xFFFFF4F2), // Light pink
      const Color(0xFFE1F5FE), // Light blue
      const Color(0xFFF3E5F5), // Light purple
      const Color(0xFFE8F5E8), // Light green
      const Color(0xFFFFF8E1), // Light yellow
      const Color(0xFFFFE0E0), // Light red
    ];
    return colors[DateTime.now().millisecondsSinceEpoch % colors.length];
  }

  // Copy with method for updating fields
  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? organization,
    String? createdBy,
    String? category,
    List<TicketType>? ticketTypes,
    bool? isPurchasable,
    String? startDate,
    String? endDate,
    bool? isDeleted,
    String? createdAt,
    String? updatedAt,
    DisabledPurchase? disabledPurchase,
    String? imageUrl,
    String? location,
    String? locationName,
    String? locationAddress,
    String? organizerName,
    String? organizerImageUrl,
    Color? backgroundColor,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      organization: organization ?? this.organization,
      createdBy: createdBy ?? this.createdBy,
      category: category ?? this.category,
      ticketTypes: ticketTypes ?? this.ticketTypes,
      isPurchasable: isPurchasable ?? this.isPurchasable,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      disabledPurchase: disabledPurchase ?? this.disabledPurchase,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      locationName: locationName ?? this.locationName,
      locationAddress: locationAddress ?? this.locationAddress,
      organizerName: organizerName ?? this.organizerName,
      organizerImageUrl: organizerImageUrl ?? this.organizerImageUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
