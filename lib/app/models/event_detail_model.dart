import 'package:flutter/material.dart';

class EventDetailModel {
  final String id;
  final String title;
  final String? description;
  final Organization? organization;
  final String? createdBy;
  final Category? category;
  final List<DetailedTicketType> ticketTypes;
  final bool isPurchasable;
  final String? startDate;
  final String? endDate;
  final bool isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final DisabledPurchase? disabledPurchase;
  final String? imageUrl;
  final String? location;

  EventDetailModel({
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
  });

  factory EventDetailModel.fromJson(Map<String, dynamic> json) {
    return EventDetailModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      organization: json['organization'] != null
          ? Organization.fromJson(json['organization'])
          : null,
      createdBy: json['createdBy'],
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      ticketTypes: (json['ticketTypes'] as List<dynamic>? ?? [])
          .map((e) => DetailedTicketType.fromJson(e))
          .toList(),
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'organization': organization?.toJson(),
      'createdBy': createdBy,
      'category': category?.toJson(),
      'ticketTypes': ticketTypes.map((e) => e.toJson()).toList(),
      'isPurchasable': isPurchasable,
      'startDate': startDate,
      'endDate': endDate,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'disabledPurchase': disabledPurchase?.toJson(),
      'imageUrl': imageUrl,
      'location': location,
    };
  }
}

class Organization {
  final String id;
  final String name;
  final String type;
  final String imageUrl;

  Organization({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
        id: json['_id'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        type: json['type'] ?? '',
        imageUrl: json['imageUrl'] ?? "");
  }

  Map<String, dynamic> toJson() =>
      {'_id': id, 'name': name, 'type': type, 'imageUrl': imageUrl};
}

class Category {
  final String id;
  final String title;
  final String iconUrl;

  Category({
    required this.id,
    required this.title,
    required this.iconUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'iconUrl': iconUrl,
      };
}

class DetailedTicketType {
  final TicketTypeId ticketTypeId;
  final double price;
  final int quantity;
  final int soldQuantity;
  final String id;

  DetailedTicketType({
    required this.ticketTypeId,
    required this.price,
    required this.quantity,
    required this.soldQuantity,
    required this.id,
  });

  factory DetailedTicketType.fromJson(Map<String, dynamic> json) {
    return DetailedTicketType(
      ticketTypeId: TicketTypeId.fromJson(json['ticketTypeId']),
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      soldQuantity: json['soldQuantity'] ?? 0,
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'ticketTypeId': ticketTypeId.toJson(),
        'price': price,
        'quantity': quantity,
        'soldQuantity': soldQuantity,
        '_id': id,
      };
}

class TicketTypeId {
  final String id;
  final String title;

  TicketTypeId({
    required this.id,
    required this.title,
  });

  factory TicketTypeId.fromJson(Map<String, dynamic> json) {
    return TicketTypeId(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
      };
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

  Map<String, dynamic> toJson() => {
        'unit': unit,
        'value': value,
      };
}
