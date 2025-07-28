import 'package:event_booking_app/app/views/pages/auth/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart'; // Adjust the path if needed

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
      ),
      backgroundColor: const Color(0xFFf8f8ff),
      body: Obx(() {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      color: Color(0xFF667eea),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please fill the form to sign up for BayonPass.",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  // First & Last Name (same row)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameCtrl,
                          decoration: const InputDecoration(
                            labelText: "First Name",
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? "First name required"
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameCtrl,
                          decoration: const InputDecoration(
                            labelText: "Last Name",
                            // No prefix icon for compactness, or add your icon if you want!
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? "Last name required"
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Username
                  TextFormField(
                    controller: usernameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.account_box),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? "Username required"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Email
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (v) => !GetUtils.isEmail(v ?? "")
                        ? "Please enter valid email"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Password
                  TextFormField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (v) => v != null && v.length < 6
                        ? "At least 6 characters"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Confirm password
                  TextFormField(
                    controller: confirmCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (v) =>
                        v != passCtrl.text ? "Passwords do not match" : null,
                  ),
                  const SizedBox(height: 28),
                  // Sign up button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      onPressed: authController.isLoading.value
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                final success = await authController.signUp(
                                  email: emailCtrl.text.trim(),
                                  username: usernameCtrl.text.trim(),
                                  firstName: firstNameCtrl.text.trim(),
                                  lastName: lastNameCtrl.text.trim(),
                                  password: passCtrl.text,
                                );
                                if (success) {
                                  // After sign up, go to OTP screen, pass email
                                  Get.to(() => VerificationScreen(
                                      emailOrPhone: emailCtrl.text.trim()));
                                }
                              }
                            },
                      child: authController.isLoading.value
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: Colors.white),
                            )
                          : const Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                                fontSize: 17,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // OR divider
                  Row(
                    children: [
                      const Expanded(child: Divider(thickness: 1.3)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      const Expanded(child: Divider(thickness: 1.3)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Social (you can connect real logic later)
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.g_mobiledata,
                        color: Color(0xFFea4335), size: 28),
                    label: const Text("Sign up with Google"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: BorderSide(color: Colors.grey.shade300),
                      foregroundColor: Colors.black87,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.facebook,
                        color: Color(0xFF4267B2), size: 26),
                    label: const Text("Sign up with Facebook"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: BorderSide(color: Colors.grey.shade300),
                      foregroundColor: Colors.black87,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Already have account?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?",
                          style: TextStyle(fontSize: 15)),
                      TextButton(
                        onPressed: () => Get.offAllNamed('/signin'),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                              color: Color(0xFF667eea),
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
