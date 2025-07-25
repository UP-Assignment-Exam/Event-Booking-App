import 'package:event_booking_app/app/models/event_model.dart';
import 'package:event_booking_app/app/views/pages/events/detail_event.dart';
import 'package:event_booking_app/app/views/widgets/cached_image.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Prevents rebuilds when switching tabs

  bool _isLoading = true;
  List<EventModel> _events = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Add small delay to prevent blocking UI
      await Future.delayed(const Duration(milliseconds: 100));

      // Load events data
      _events = getSampleEvents();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading events: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    if (_error != null) {
      return _buildErrorState();
    }

    if (_isLoading) {
      return _buildLoadingState();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const SizedBox(height: 20),
            Expanded(
              child: _buildEventsList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const SizedBox(height: 20),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF4A43EC)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading events...',
                      style: TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Failed to load events',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error ?? 'Unknown error',
                        style: const TextStyle(
                          color: Color(0xFF718096),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadEvents,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A43EC),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
              // Handle add event
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

  Widget _buildEventsList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadEvents,
      color: const Color(0xFF4A43EC),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _events.length + 1, // +1 for bottom spacing
        physics: const AlwaysScrollableScrollPhysics(), // For refresh indicator
        itemBuilder: (context, index) {
          if (index == _events.length) {
            return const SizedBox(height: 10); // Space for bottom navigation
          }

          final event = _events[index];
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
        try {
          // Navigate to event details page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(event: event),
            ),
          );
        } catch (e) {
          debugPrint('Navigation error: $e');
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to open event details: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: event.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.2), // Reduced opacity for better performance
              blurRadius: 10, // Reduced blur radius
              offset: const Offset(0, 4), // Reduced offset
            ),
          ],
        ),
        child: Column(
          children: [
            // Image section with improved loading
            _buildEventImage(event, isLarge),
            // Content section
            _buildEventContent(event),
          ],
        ),
      ),
    );
  }

  Widget _buildEventImage(EventModel event, bool isLarge) {
    final height = isLarge ? 200.0 : 160.0;
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: CachedImage(
        url: event.imageUrl,
        height: height,
        width: double.infinity,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildEventContent(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Date section
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
          // Event details
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
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.locationAddress,
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

// Optimized sample data function
List<EventModel> getSampleEvents() {
  return [
    EventModel(
      id: '1',
      title: 'Traditional Dance Show - The Abduc...',
      imageUrl:
          'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y29uY2VydHxlbnwwfHwwfHx8MA%3D%3D',
      date: '2024-08-31',
      displayDate: '06-31\nAug',
      time: '7:00 PM - 8:00 PM',
      locationName: 'Treellion Park',
      locationAddress: 'Studio B6 - Koh Pich (first right behind the dinosaur)',
      organizerName: 'Cultural Events Co.',
      organizerImageUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&q=80',
      backgroundColor: Colors.black87,
    ),
    EventModel(
      id: '2',
      title: 'A PART OF US ជំនួសប៉ុនម៉ាន់',
      imageUrl:
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop&q=80',
      date: '2024-08-25',
      displayDate: '25-10\nAug',
      time: '8:00 PM',
      locationName: 'The Last Stage',
      locationAddress: 'The Last Stage',
      organizerName: 'Theatre Group',
      organizerImageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&q=80',
      backgroundColor: const Color(0xFF1B4332),
    ),
  ];
}
