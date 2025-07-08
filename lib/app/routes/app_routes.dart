// // import 'package:flutter/material.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// abstract class AppRoutes {
//   // static const home = '/HomeView';
//   static const eventList = '/events';
//   static const eventDetail = '/events/detail';
//   static const home = '/singin';
//   static const homes = '/signup';
//   // static const routes = '/signup_screen';
//   // Add more routes as needed
// }

// import 'package:event_booking_app/auth/signin_screen.dart';
import 'package:flutter/material.dart';
import '/auth/signin_screen.dart';
import '/auth/signup_screen.dart';
import '/auth/verification_screen.dart';
import '/auth/reset_password_screen.dart';

class AppRoutes {
  static const String initial = '/signin';

  static final routes = <String, WidgetBuilder>{
    '/signin': (_) => const LoginScreen(),
    '/signup': (_) => const SignupScreen(),
    '/verify': (_) => const VerificationScreen(),
    '/reset': (_) => const ResetPasswordScreen(),
  };
}
