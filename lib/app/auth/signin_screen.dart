import 'package:flutter/material.dart';
import 'package:get/get.dart';

class signin_screen extends StatelessWidget {
  const signin_screen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const SizedBox(height: 60),

            // 👇 Logo
            Center(
              child: Image.asset(
                'assets/images/BayonPass_logo.png', // 🔁 Update with your actual path
                height: 100,
              ),
            ),

            const SizedBox(height: 16),

            const Center(
              child: Text(
                "BayonPass",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: emailCtrl,
              decoration:
                  const InputDecoration(labelText: "Enter your email address"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: "Enter your password"),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Checkbox(value: false, onChanged: (_) {}),
                  const Text("Remember Me")
                ]),
                TextButton(
                    onPressed: () => Get.toNamed('/reset'),
                    child: const Text("Forgot Password?")),
              ],
            ),

            const SizedBox(height: 12),

            ElevatedButton(onPressed: () {}, child: const Text("SIGN IN")),

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
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () => Get.toNamed('/signup'),
                  child: const Text("Sign Up",
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
