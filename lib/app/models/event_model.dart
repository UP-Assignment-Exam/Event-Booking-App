// lib/models/event_model.dart

import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String title;
  final String imageUrl;
  final String date;
  final String displayDate; // For the format "10\nJUNE"
  final String time;
  final String locationName;
  final String locationAddress;
  final String organizerName;
  final String organizerImageUrl;
  final Color backgroundColor; // For the card background

  EventModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.displayDate,
    required this.time,
    required this.locationName,
    required this.locationAddress,
    required this.organizerName,
    required this.organizerImageUrl,
    required this.backgroundColor,
  });
}
