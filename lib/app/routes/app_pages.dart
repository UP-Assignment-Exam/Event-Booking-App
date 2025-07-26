import 'package:event_booking_app/app/views/home_view.dart';
import 'package:get/get.dart';
// import other views and bindings as needed

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      // binding: HomeBinding(), // If you use bindings
    ),
    // Add more pages here
  ];
}
