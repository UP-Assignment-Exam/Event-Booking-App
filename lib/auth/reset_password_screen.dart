import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter your email address to reset password'),
            const SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () {}, child: const Text('SEND')),
          ],
        ),
      ),
    );
  }
}
