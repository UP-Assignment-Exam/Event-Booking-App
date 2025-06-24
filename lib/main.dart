import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import your bindings and routes (adjust the paths as per your project)
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/bindings/initial_binding.dart'; // Optional: for initial dependency injection

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
      initialBinding: InitialBinding(), // Set up your initial bindings (controllers/services)
      initialRoute: AppRoutes.home,     // Set your initial route
      getPages: AppPages.pages,         // Define all your app routes here
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
