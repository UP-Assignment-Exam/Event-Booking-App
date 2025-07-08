// import 'package:event_booking_app/app/views/login.dart';
// import 'package:event_booking_app/app/views/logout.dart';
// // import 'package:event_booking_app/app/views/login.dart';
// import 'package:get/get.dart';
// // import other views and bindings as needed

// import 'app_routes.dart';

// class AppPages {
//   static final pages = [
//     GetPage(
//       name: AppRoutes.home,
//       page: () => const LoginScreen(),
//       // binding: HomeBinding(), // If you use bindings
//     ),
//     // Add more pages here
//     GetPage(
//       name: AppRoutes.homes,
//       page: () => const SignUpScreen(),
//       // binding: HomeBinding(), // If you use bindings
//     ),
//   ];

// }

import 'package:flutter/material.dart';
import '/auth/signin_screen.dart';
import '/auth/signup_screen.dart';
import '/auth/verification_screen.dart';
import '/auth/reset_password_screen.dart';

class AppPages {
  static const initial = '/login';

  static final routes = <String, WidgetBuilder>{
    '/login': (_) => const LoginScreen(),
    '/signup': (_) => const SignupScreen(),
    '/verify': (_) => const VerificationScreen(),
    '/reset': (_) => const ResetPasswordScreen(),
  };
}
