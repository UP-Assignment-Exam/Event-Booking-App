import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(leading: BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Please enter your email address to request a password reset"),
            const SizedBox(height: 16),
            TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                    labelText: "Enter your email address")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text("SEND")),
          ],
        ),
      ),
    );
  }
}
