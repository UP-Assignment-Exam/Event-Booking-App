import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import your bindings and routes (adjust the paths as per your project)
import 'app/routes/app_pages.dart';
import 'app/bindings/initial_binding.dart';
import 'package:event_booking_app/app/controllers/navigation_controller.dart';

// Optional: for initial dependency injection
void main() {
  runApp(const EventBookingApp());
}

class EventBookingApp extends StatelessWidget {
  const EventBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Event Booking App',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: Routes.home,
      getPages: AppPages.pages,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
