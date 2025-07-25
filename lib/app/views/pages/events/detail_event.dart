import 'package:event_booking_app/app/views/pages/payments/checkout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:event_booking_app/app/models/event_model.dart';
import 'package:string_to_icon/string_to_icon.dart'; // Adjust this import path as needed
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class EventDetailsPage extends StatefulWidget {
  final EventModel event;

  const EventDetailsPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  // A list of available ticket options for the dropdown
  final List<String> _ticketTypes = [
    'General Admission',
    'VIP',
    'Backstage Pass'
  ];
  // This variable will hold the currently selected ticket type
  String? _selectedTicketType;

  String iconNameFromApi = 'settings_accessibility';

  @override
  void initState() {
    super.initState();
    // Set the default value for the dropdown menu when the page loads
    _selectedTicketType = _ticketTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Background Image (loaded from a network URL)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.network(
              widget.event.imageUrl,
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
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 28),
                ),
                const Text(
                  'Event Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      const Icon(Icons.bookmark, color: Colors.white, size: 22),
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
                    _buildEventTitle(widget.event.title),
                    const SizedBox(height: 24),
                    _buildTicketTypeDropdown(),
                    const SizedBox(height: 28),
                    _buildInfoTile(
                      icon: Icons.calendar_today_outlined,
                      title: widget.event.date,
                      subtitle: widget.event.time,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      icon: Icons.location_on_outlined,
                      title: widget.event.locationName,
                      subtitle: widget.event.locationAddress,
                    ),
                    const SizedBox(height: 40),
                    _buildOrganizerTile(
                      name: widget.event.organizerName,
                      imageUrl: widget.event.organizerImageUrl,
                    ),
                    const SizedBox(height: 40),
                    _buildAboutSection(),
                    const SizedBox(height: 32),
                    _buildBuyTicketButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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

  // Widget for the ticket type selection dropdown
  Widget _buildTicketTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedTicketType,
      // --- NEW: Add this property to change the menu's background ---
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: 'Ticket Type',
        labelStyle: TextStyle(color: Colors.grey[700]),
        prefixIcon: Icon(
          StringToIcon.fromString(iconNameFromApi) ?? Icons.confirmation_number,
          size: 20,
          color: Color(0xFF5669FF),
        ),
        // --- NEW: Add these two properties to change the field's background ---
        filled: true,
        fillColor: Colors.grey[100],
        // --- End of new properties ---
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Hide the default border when filled
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5669FF), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Hide the default border when filled
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      items: _ticketTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedTicketType = newValue;
        });
      },
    );
  }

  // Reusable widget for info rows (date, location)
  Widget _buildInfoTile(
      {required IconData icon,
      required String title,
      required String subtitle}) {
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
            // Uses Image.asset for local files
            imageUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
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
  Widget _buildAboutSection() {
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
              const TextSpan(
                text:
                    'Enjoy your favorite dishes and a lovely time with your friends and family. Food from local food trucks will be available for purchase. ',
              ),
              TextSpan(
                text: 'Read More...',
                style: const TextStyle(
                  color: Color(0xFF5669FF),
                  fontWeight: FontWeight.w600,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Implement logic to show more details
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget for the final "Buy Ticket" button
  Widget _buildBuyTicketButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CheckoutPage(),
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
          const Text(
            'BUY TICKET',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
         
        ],
      ),
    );
  }
}
