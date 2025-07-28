import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../controllers/auth_controller.dart'; // adjust if needed

class VerificationScreen extends StatefulWidget {
  final String emailOrPhone;
  const VerificationScreen({super.key, required this.emailOrPhone});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _pinControllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  int secondsLeft = 60;
  late Timer _timer;
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    _startTimer();
  }

  void _startTimer() {
    secondsLeft = 20;
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
    if (pin.length != 6 || pin.contains(RegExp(r'[^0-9]'))) {
      Get.snackbar('Error', 'Please enter the 6-digit code',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    await authController.verifyOtp(
      email: widget.emailOrPhone,
      otp: pin,
    );
  }

  void _onChanged(int idx, String value) {
    if (value.length == 1 && idx < 5) {
      _focusNodes[idx + 1].requestFocus();
    }
    if (value.isEmpty && idx > 0) {
      _focusNodes[idx - 1].requestFocus();
    }
  }

  Future<void> _resendCode() async {
    await authController.resendOtp(email: widget.emailOrPhone);
    setState(_startTimer); // Restart timer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
                "We've sent you the verification code on ${widget.emailOrPhone}",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
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
                  onPressed: authController.isLoading.value ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: authController.isLoading.value
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
