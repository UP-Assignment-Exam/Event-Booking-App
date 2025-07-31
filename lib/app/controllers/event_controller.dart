import 'package:event_booking_app/app/models/event_detail_model.dart';
import 'package:event_booking_app/app/models/event_model.dart';
import 'package:event_booking_app/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // API Base URL - Update this to your actual API URL
  final String baseUrl = 'https://event-booking-backend-k2i1.onrender.com/app';

  // Observable variables
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final RxList<EventModel> events = <EventModel>[].obs;
  final RxList<EventModel> upcomingEvents = <EventModel>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxString searchKeyword = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalEvents = 0.obs;
  final int pageSize = 10;
  final RxBool hasMoreEvents = true.obs;

  @override
  void onInit() {
    super.onInit();
    getEvents();
  }

  // Get events from API
  Future<void> getEvents({
    int? pageNo,
    int? pageSize,
    String? category,
    String? organization,
    String? keyword,
    String? startDate,
    String? endDate,
    String? dateRangeType,
    bool isLoadMore = false,
  }) async {
    try {
      if (!isLoadMore) {
        isLoading.value = true;
        currentPage.value = 1;
      } else {
        isLoadingMore.value = true;
      }

      final token = await _storageService.getToken();
      if (token == null) {
        Get.snackbar('Error', 'No authentication token found');
        return;
      }

      // Build query parameters
      Map<String, String> queryParams = {
        'pageNo': (pageNo ?? currentPage.value).toString(),
        'pageSize': (pageSize ?? this.pageSize).toString(),
      };

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (organization != null && organization.isNotEmpty) {
        queryParams['organization'] = organization;
      }
      if (keyword != null && keyword.isNotEmpty) {
        queryParams['keyword'] = keyword;
      }
      if (startDate != null && startDate.isNotEmpty) {
        queryParams['startDate'] = startDate;
      }
      if (endDate != null && endDate.isNotEmpty) {
        queryParams['endDate'] = endDate;
      }
      if (dateRangeType != null && dateRangeType.isNotEmpty) {
        queryParams['dateRangeType'] = dateRangeType;
      }

      final uri =
          Uri.parse('$baseUrl/events').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 200) {
          final List<dynamic> data = responseData['data'] ?? [];
          final List<EventModel> newEvents =
              data.map((item) => EventModel.fromApiJson(item)).toList();

          if (isLoadMore) {
            events.addAll(newEvents);
          } else {
            events.value = newEvents;
          }

          totalEvents.value = responseData['total'] ?? 0;
          currentPage.value = responseData['pageNo'] ?? 1;

          // Check if there are more events to load
          hasMoreEvents.value = events.length < totalEvents.value;

          // Update upcoming events (events in the next 30 days)
          _updateUpcomingEvents();
        } else {
          Get.snackbar(
              'Error', responseData['message'] ?? 'Failed to load events');
        }
      } else {
        Get.snackbar(
            'Error', 'Failed to load events. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Get events error: $e');
      Get.snackbar('Error', 'An error occurred while loading events');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

// Get single event by ID from API
  Future<EventDetailModel?> getEventById(String eventId) async {
    try {
      isLoading.value = true;

      final token = await _storageService.getToken();
      if (token == null) {
        Get.snackbar('Error', 'No authentication token found');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/events/$eventId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 200) {
          final eventData = responseData['data'] as Map<String, dynamic>;
          return EventDetailModel.fromJson(eventData);
        } else {
          Get.snackbar(
              'Error', responseData['message'] ?? 'Failed to load event');
          return null;
        }
      } else {
        Get.snackbar(
            'Error', 'Failed to load event. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get event by ID error: $e');
      Get.snackbar('Error', 'An error occurred while loading event');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Load more events (pagination)
  Future<void> loadMoreEvents() async {
    if (hasMoreEvents.value && !isLoadingMore.value) {
      await getEvents(
        pageNo: currentPage.value + 1,
        category:
            selectedCategory.value.isEmpty ? null : selectedCategory.value,
        keyword: searchKeyword.value.isEmpty ? null : searchKeyword.value,
        isLoadMore: true,
      );
    }
  }

  // Search events
  Future<void> searchEvents(String keyword) async {
    searchKeyword.value = keyword;
    await getEvents(
      keyword: keyword.isEmpty ? null : keyword,
      category: selectedCategory.value.isEmpty ? null : selectedCategory.value,
    );
  }

  // Filter events by category
  Future<void> filterByCategory(String categoryId) async {
    selectedCategory.value = categoryId;
    await getEvents(
      category: categoryId.isEmpty ? null : categoryId,
      keyword: searchKeyword.value.isEmpty ? null : searchKeyword.value,
    );
  }

  // Get upcoming events (next 30 days)
  Future<void> getUpcomingEvents() async {
    final now = DateTime.now();
    final futureDate = now.add(const Duration(days: 30));

    await getEvents(
      startDate: now.toIso8601String(),
      endDate: futureDate.toIso8601String(),
      dateRangeType: 'startDate',
      pageSize: 5, // Limit to 5 upcoming events
    );
  }

  // Update upcoming events from current events list
  void _updateUpcomingEvents() {
    final now = DateTime.now();
    final futureDate = now.add(const Duration(days: 30));

    upcomingEvents.value = events
        .where((event) {
          if (event.startDate == null) return false;
          final eventDate = DateTime.tryParse(event.startDate!);
          if (eventDate == null) return false;
          return eventDate.isAfter(now) && eventDate.isBefore(futureDate);
        })
        .take(5)
        .toList();
  }

  // Refresh events
  Future<void> refreshEvents() async {
    await getEvents();
  }

  // Clear filters
  void clearFilters() {
    selectedCategory.value = '';
    searchKeyword.value = '';
    getEvents();
  }

  // Get event by ID
  // EventModel? getEventById(String id) {
  //   try {
  //     return events.firstWhere((event) => event.id == id);
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
