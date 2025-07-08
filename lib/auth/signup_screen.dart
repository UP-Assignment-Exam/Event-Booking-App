import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Full Name')),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/verify'),
              child: const Text('SIGN UP'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
                onPressed: () {}, child: const Text('Login with Google')),
            OutlinedButton(
                onPressed: () {}, child: const Text('Login with Facebook')),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text("Already have an account? Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}
