import 'package:event_booking_app/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewPasswordScreen extends StatelessWidget {
  final String email;

  const NewPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final newPasswordCtrl = TextEditingController();
    final confirmPasswordCtrl = TextEditingController();
    final controller = Get.find<AuthController>();
    final _formKey = GlobalKey<FormState>();

    var obscureNewPassword = true.obs;
    var obscureConfirmPassword = true.obs;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('New Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create New Password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your new password must be different from previous used passwords",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              Obx(() => TextFormField(
                    controller: newPasswordCtrl,
                    obscureText: obscureNewPassword.value,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureNewPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          obscureNewPassword.value = !obscureNewPassword.value;
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  )),
              const SizedBox(height: 16),
              Obx(() => TextFormField(
                    controller: confirmPasswordCtrl,
                    obscureText: obscureConfirmPassword.value,
                    decoration: InputDecoration(
                      labelText: "Confirm New Password",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          obscureConfirmPassword.value =
                              !obscureConfirmPassword.value;
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != newPasswordCtrl.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  )),
              const SizedBox(height: 24),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final success = await controller.resetPassword(
                                  email: email,
                                  newPassword: newPasswordCtrl.text.trim(),
                                  confirmPassword:
                                      confirmPasswordCtrl.text.trim(),
                                );
                                // Navigation to signin is handled in the controller
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text("RESET PASSWORD"),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
