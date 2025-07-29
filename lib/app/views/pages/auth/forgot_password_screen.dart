import 'package:event_booking_app/app/controllers/auth_controller.dart';
import 'package:event_booking_app/app/views/pages/auth/new_password_screen.dart';
import 'package:event_booking_app/app/views/pages/auth/verify_forgot_password_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Screen 1: Reset Password Screen (Enter Email)
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final controller = Get.put(AuthController());
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Forgot Your Password?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please enter your email address to request a password reset",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Enter your email address",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final success = await controller.forgotPassword(
                                  email: emailCtrl.text.trim(),
                                );
                                if (success) {
                                  Get.to(() => VerifyForgotPasswordOtpScreen(
                                      email: emailCtrl.text.trim()));
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text("SEND RESET CODE"),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// Example of how to use in your routing (add to your GetMaterialApp routes)
/*
GetMaterialApp(
  routes: {
    '/forgot-password': (context) => const ForgotPasswordScreen(),
    '/signin': (context) => const SignInScreen(), // Your sign in screen
  },
)
*/
