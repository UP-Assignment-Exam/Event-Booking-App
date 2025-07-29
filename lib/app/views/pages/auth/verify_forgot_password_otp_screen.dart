import 'dart:async';

import 'package:event_booking_app/app/controllers/auth_controller.dart';
import 'package:event_booking_app/app/views/pages/auth/new_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Screen 2: Verify OTP Screen
class VerifyForgotPasswordOtpScreen extends StatefulWidget {
  final String email;

  const VerifyForgotPasswordOtpScreen({super.key, required this.email});

  @override
  State<VerifyForgotPasswordOtpScreen> createState() =>
      _VerifyForgotPasswordOtpScreenState();
}

class _VerifyForgotPasswordOtpScreenState
    extends State<VerifyForgotPasswordOtpScreen> {
  final _pinControllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());
  int secondsLeft = 60;
  late Timer _timer;
  late final AuthController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuthController>();
    _startTimer();
  }

  void _startTimer() {
    secondsLeft = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (secondsLeft > 0) {
            secondsLeft--;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (final ctrl in _pinControllers) {
      ctrl.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get pin => _pinControllers.map((c) => c.text).join();

  Future<void> _submit() async {
    if (pin.length < 4 || pin.contains(RegExp(r'[^0-9]'))) {
      Get.snackbar('Error', 'Please enter the 4-digit code',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    final success = await controller.verifyOtp(
      email: widget.email,
      otp: pin,
      purpose: 'password_reset',
    );
    if (success) {
      Get.to(() => NewPasswordScreen(email: widget.email));
    }
  }

  void _onChanged(int idx, String value) {
    if (value.length == 1 && idx < 3) {
      _focusNodes[idx + 1].requestFocus();
    }
    if (value.isEmpty && idx > 0) {
      _focusNodes[idx - 1].requestFocus();
    }
  }

  Future<void> _resendCode() async {
    await controller.resendOtp(email: widget.email, purpose: "password_reset");
    await controller.forgotPassword(email: widget.email);
    setState(_startTimer); // Restart timer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Enter Verification Code",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We've sent you the verification code on ${widget.email}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _pinControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (v) => _onChanged(index, v),
                  ),
                );
              }),
            ),
            const SizedBox(height: 22),
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Text("CONTINUE",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              );
            }),
            const SizedBox(height: 16),
            secondsLeft > 0
                ? Text(
                    "Re-send code in 0:${secondsLeft.toString().padLeft(2, "0")}",
                    style: TextStyle(color: Colors.grey[700]))
                : TextButton(
                    onPressed: _resendCode,
                    child: const Text(
                      "Resend code",
                      style: TextStyle(
                          color: Color(0xFF667eea),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
