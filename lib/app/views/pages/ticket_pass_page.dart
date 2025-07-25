import 'package:event_booking_app/app/views/pages/ticketpass/ticket_pass_widget.dart';
import 'package:flutter/material.dart';

class TicketPassPage extends StatelessWidget {
  const TicketPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Updated background color
      appBar: AppBar(
        title: const Text('My Passes'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        backgroundColor: const Color(0xFF5669FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const [
          TicketPass(),
          // you can add more TicketPass() widgets here if you have multiple passes
        ],
      ),
    );
  }
}
