import 'package:flutter/material.dart';
import 'app/auth/signin_screen.dart';
import 'app/auth/signup_screen.dart';
import 'app/auth/verification_screen.dart';
import 'app/auth/reset_password_screen.dart';

void main() => runApp(const EventHubApp());

class EventHubApp extends StatelessWidget {
  const EventHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BayonPass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const signin_screen(),
      routes: {
        '/signin_screen': (_) => const signin_screen(),
        '/signup_screen': (_) => const signup_screen(),
        '/verification_screen': (_) => const verification_screen(),
        '/reset_password_screen': (_) => const reset_password_screen(),
      },
    );
  }
}
