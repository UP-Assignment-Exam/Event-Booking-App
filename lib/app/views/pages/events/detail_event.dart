// Updated EventDetailsPage
import 'package:event_booking_app/app/models/event_detail_model.dart';
import 'package:event_booking_app/app/views/pages/payments/checkout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:event_booking_app/app/models/event_model.dart';
import 'package:event_booking_app/app/controllers/event_controller.dart';
import 'package:get/get.dart';
import 'package:string_to_icon/string_to_icon.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class EventDetailsPage extends StatefulWidget {
  final String eventId;
  final EventModel?
      initialEvent; // Optional - for when navigating with existing event

  const EventDetailsPage({
    super.key,
    required this.eventId,
    this.initialEvent,
  });

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final EventController eventController = Get.find<EventController>();

  // A list of available ticket options for the dropdown
  final List<String> _ticketTypes = [
    'General Admission',
    'VIP',
    'Backstage Pass'
  ];

  // This variable will hold the currently selected ticket type
  String? _selectedTicketType;

  String iconNameFromApi = 'settings_accessibility';

  // Observable for the current event
  final Rx<EventDetailModel?> currentEvent = Rx<EventDetailModel?>(null);

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  List<String> getTicketTitles(EventDetailModel event) {
    return event.ticketTypes.map((e) => e.ticketTypeId.title).toList();
  }

  double _getSelectedTicketPrice(EventDetailModel event) {
    final selectedTicket = event.ticketTypes.firstWhere(
      (ticket) => ticket.ticketTypeId.title == _selectedTicketType,
      orElse: () => event.ticketTypes.first,
    );
    return selectedTicket.price;
  }

  Future<void> _loadEventDetails() async {
    final event = await eventController.getEventById(widget.eventId);
    if (event != null) {
      currentEvent.value = event;

      final ticketTitles = getTicketTitles(event);
      _selectedTicketType ??= ticketTitles.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // Show loading indicator while fetching event details
        if (eventController.isLoading.value && currentEvent.value == null) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5669FF)),
            ),
          );
        }

        // Show error message if event not found
        if (currentEvent.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Event not found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _loadEventDetails(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final event = currentEvent.value!;

        return Stack(
          children: [
            // 1. Background Image (loaded from a network URL)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.network(
                event.imageUrl ?? "",
                height: screenHeight * 0.45,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Display a placeholder if the image fails to load
                  return Container(
                    height: screenHeight * 0.45,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                      size: 50,
                    ),
                  );
                },
              ),
            ),

            // 2. Custom App Bar
            Positioned(
              top: statusBarHeight + 10,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const Text(
                    'Event Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.bookmark_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Scrollable Content Area
            Positioned.fill(
              top: screenHeight * 0.35,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEventTitle(event.title),
                      const SizedBox(height: 24),
                      _buildTicketTypeDropdown(event.ticketTypes),
                      const SizedBox(height: 28),
                      _buildInfoTile(
                        icon: Icons.calendar_today_outlined,
                        title: event.startDate ?? "",
                        subtitle: event.startDate ?? "",
                      ),
                      const SizedBox(height: 16),
                      _buildInfoTile(
                        icon: Icons.location_on_outlined,
                        title: event.location ?? "",
                        subtitle: event.location ?? "",
                      ),
                      const SizedBox(height: 16),
                      _buildInfoTile(
                        icon: Icons.attach_money,
                        title:
                            '\$${_getSelectedTicketPrice(event).toStringAsFixed(2)}',
                        subtitle: 'Ticket Price',
                      ),
                      const SizedBox(height: 40),
                      _buildOrganizerTile(
                        name: event.organization?.name ?? "",
                        imageUrl: event.organization?.imageUrl ?? "",
                      ),
                      const SizedBox(height: 40),
                      _buildAboutSection(event.description ?? ""),
                      const SizedBox(height: 32),
                      _buildBuyTicketButton(event),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // Widget for the main event title, which wraps text automatically
  Widget _buildEventTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        height: 1.2,
      ),
    );
  }

  Widget _buildTicketTypeDropdown(List<DetailedTicketType> ticketTitles) {
    return DropdownButtonFormField<String>(
      value: _selectedTicketType,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: 'Ticket Type',
        prefixIcon: Icon(
          StringToIcon.fromString(iconNameFromApi) ?? Icons.confirmation_number,
          size: 20,
          color: const Color(0xFF5669FF),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: ticketTitles.map((DetailedTicketType type) {
        return DropdownMenuItem<String>(
          value: type.ticketTypeId.title,
          child: Text(type.ticketTypeId.title),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedTicketType = newValue;
        });
      },
    );
  }

  // Reusable widget for info rows (date, location, price)
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    const Color iconColor = Color(0xFF5669FF);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget for the organizer row
  Widget _buildOrganizerTile({required String name, required String imageUrl}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.business,
                  color: Colors.grey[600],
                  size: 32,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Organizer',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF5669FF),
            backgroundColor: const Color(0xFF5669FF).withOpacity(0.1),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Follow'),
        ),
      ],
    );
  }

  // Widget for the "About Event" section
  Widget _buildAboutSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Event',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
            children: <TextSpan>[
              TextSpan(text: description),
              if (description.length >
                  150) // Show "Read More" if description is long
                TextSpan(
                  text: ' Read More...',
                  style: const TextStyle(
                    color: Color(0xFF5669FF),
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Show full description in dialog or navigate to full details
                      _showFullDescription(description);
                    },
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFullDescription(String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Event Description'),
        content: SingleChildScrollView(
          child: Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Widget for the final "Buy Ticket" button
  Widget _buildBuyTicketButton(EventDetailModel event) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CheckoutPage(
                // event: event,
                // ticketType: _selectedTicketType ?? 'General Admission',
                ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5669FF),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        minimumSize: const Size(double.infinity, 56),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'BUY TICKET - \$${_getSelectedTicketPrice(event).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }
}
