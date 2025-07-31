import 'package:event_booking_app/app/controllers/event_controller.dart';
import 'package:event_booking_app/app/models/event_model.dart';
import 'package:event_booking_app/app/views/pages/events/detail_event.dart';
import 'package:event_booking_app/app/views/widgets/categories_bar.dart';
import 'package:event_booking_app/app/views/widgets/event_card.dart';
import 'package:event_booking_app/app/views/widgets/overviews_card.dart';
import 'package:event_booking_app/app/views/widgets/categories_bar.dart'
    as categories_bar;
import 'package:flutter/material.dart';
import 'package:event_booking_app/app/models/category_model.dart' as model;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomePageContent extends StatelessWidget {
  HomePageContent({super.key});

  // Initialize the EventController
  final EventController eventController = Get.put(EventController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<model.CategoryModel> categories = [
      model.CategoryModel(
        id: '1',
        name: 'Sports',
        icon: Icons.sports_basketball,
        color: const Color(0xFFFF6B6B), // Coral red
      ),
      model.CategoryModel(
        id: '2',
        name: 'Music',
        icon: Icons.music_note_rounded,
        color: const Color(0xFFFFB347), // Orange
      ),
      model.CategoryModel(
        id: '3',
        name: 'Food',
        icon: Icons.restaurant,
        color: const Color(0xFF4ECDC4), // Teal green
      ),
      model.CategoryModel(
        id: '4',
        name: 'Art',
        icon: Icons.brush,
        color: const Color(0xFF45B7D1), // Light blue
      ),
    ];

    return Container(
      color: Color(0xFF4A43EC),
      child: Column(
        children: [
          // Top section with search bar
          Container(
            color: const Color(0xFF4A43EC),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildSearchBar(),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),

          // Categories section with rounded background
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                // Categories with reduced negative offset
                Transform.translate(
                  offset: const Offset(0, -20), // Reduced from -26
                  child: CategoriesBar(
                    categories: categories,
                    onCategoryTap: (category) {
                      // Handle category tap - filter events by category
                      eventController.filterByCategory(category.id);
                    },
                  ),
                ),
                // Compensation spacing for reduced offset
                const SizedBox(height: 6),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: Obx(() {
                if (eventController.isLoading.value &&
                    eventController.events.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4A43EC),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => eventController.refreshEvents(),
                  color: const Color(0xFF4A43EC),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Upcoming Events Section Header
                      Row(
                        children: [
                          const Text(
                            'Upcoming Events',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // Navigate to all events page
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: Color(0xFF6366F1),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Event Cards with proper spacing
                      Container(
                        height: 280,
                        child: eventController.upcomingEvents.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(12),
                                itemCount:
                                    eventController.upcomingEvents.length,
                                itemBuilder: (context, index) {
                                  final event =
                                      eventController.upcomingEvents[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailsPage(
                                                  eventId: event.id),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: index <
                                                eventController
                                                        .upcomingEvents.length -
                                                    1
                                            ? 16
                                            : 0,
                                      ),
                                      child: EventCard(event: event),
                                    ),
                                  );
                                },
                              ),
                      ),

                      // Increased spacing to prevent cutoff
                      const SizedBox(height: 10),

                      // Invite Friends Section
                      _buildInviteFriendsCard(),
                      const SizedBox(height: 24),

                      // Space for bottom navigation
                      const SizedBox(height: 100),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 12),
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 24,
            ),
          ),
          Expanded(
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search events...',
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              autocorrect: false,
              enableSuggestions: false,
              onSubmitted: (value) {
                eventController.searchEvents(value.trim());
              },
              onChanged: (value) {
                // Optional: implement real-time search with debouncing
                if (value.isEmpty) {
                  eventController.searchEvents('');
                }
              },
            ),
          ),
          // Search button
          IconButton(
            onPressed: () {
              eventController.searchEvents(searchController.text.trim());
            },
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No upcoming events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for new events',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(String title, String date, String location,
      Color backgroundColor, String imageUrl) {
    return Container(
      width: 250, // Fixed width to prevent layout issues
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child:
                          const Icon(Icons.image, size: 48, color: Colors.grey),
                    ),
                  ),
                ),
                // Date overlay
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      date,
                      style: const TextStyle(
                        color: Color(0xFF6366F1),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Bookmark icon
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.bookmark_border,
                      color: Color(0xFF6366F1),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteFriendsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Invite your friends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get \$20 for ticket',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ECDC4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('INVITE'),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.card_giftcard,
              size: 40,
              color: Color(0xFF4ECDC4),
            ),
          ),
        ],
      ),
    );
  }
}
