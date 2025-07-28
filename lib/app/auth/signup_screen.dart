import 'package:flutter/material.dart';
import 'package:get/get.dart';

class signup_screen extends StatelessWidget {
  const signup_screen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(leading: BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Full Name")),
            const SizedBox(height: 12),
            TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                    labelText: "Enter your email address")),
            const SizedBox(height: 12),
            TextField(
                controller: passCtrl,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "Enter your password")),
            const SizedBox(height: 12),
            TextField(
                controller: confirmCtrl,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "Confirm password")),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: () => Get.toNamed('/verify'),
                child: const Text("SIGN UP")),
            const Divider(),
            OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata),
                label: const Text("Login with Google")),
            OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.facebook),
                label: const Text("Login with Facebook")),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Already have an account? "),
                Text("Sign In", style: TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
