import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('BayonPass',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password')),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/reset'),
                child: const Text('Forgot Password?'),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('SIGN IN'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
                onPressed: () {}, child: const Text('Login with Google')),
            OutlinedButton(
                onPressed: () {}, child: const Text('Login with Facebook')),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/signup'),
              child: const Text("Don’t have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
