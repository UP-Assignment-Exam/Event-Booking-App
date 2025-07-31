import 'package:event_booking_app/app/controllers/event_controller.dart';
import 'package:event_booking_app/app/models/event_model.dart';
import 'package:event_booking_app/app/views/pages/events/detail_event.dart';
import 'package:event_booking_app/app/views/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with AutomaticKeepAliveClientMixin {
  final EventController _eventController = Get.put(EventController());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _eventController.getEvents(); // Load events on start
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important for AutomaticKeepAliveClientMixin

    return Obx(() {
      if (_eventController.isLoading.value) {
        return _buildLoadingState();
      }

      if (_eventController.events.isEmpty) {
        return _buildEmptyState(); // You can customize this as needed
      }

      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              const SizedBox(height: 20),
              Expanded(
                child: _buildEventsList(context, _eventController.events),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLoadingState() {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A43EC)),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No events found',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _eventController.getEvents(),
              child: const Text('Reload'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF4A43EC),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Events',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              debugPrint('Add event tapped');
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(BuildContext context, List<EventModel> events) {
    return RefreshIndicator(
      onRefresh: _eventController.refreshEvents,
      color: const Color(0xFF4A43EC),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: events.length + 1,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == events.length) return const SizedBox(height: 10);

          final event = events[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: _buildEventCard(
              context: context,
              event: event,
              isLarge: index == 0,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventCard({
    required BuildContext context,
    required EventModel event,
    required bool isLarge,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage(eventId: event.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: event.backgroundColor ?? Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildEventImage(event, isLarge),
            _buildEventContent(event),
          ],
        ),
      ),
    );
  }

  Widget _buildEventImage(EventModel event, bool isLarge) {
    final height = isLarge ? 200.0 : 160.0;
    return CachedImage(
      url: event.imageUrl ?? '',
      height: height,
      width: double.infinity,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    );
  }

  Widget _buildEventContent(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              event.displayDate,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location ?? "",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
