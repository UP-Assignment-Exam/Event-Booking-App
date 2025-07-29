import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Observable variables
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final user = Rxn<UserModel>();
  final rememberMe = false.obs;

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // API Base URL - Update this to your actual API URL
  final String baseUrl = 'https://event-booking-backend-k2i1.onrender.com/app';

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Check if user is already logged in
  Future<void> checkAuthStatus() async {
    final token = await _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      await getUserProfile();
      if (user.value != null) {
        isLoggedIn.value = true;
        Get.offAllNamed('/home');
      }
    }
  }

  // Sign in method
  Future<void> signIn() async {
    if (!_validateSignInForm()) return;

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'), // Update endpoint as needed
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 200) {
        // Success
        final userData = responseData['data'];
        final token = userData['token'];
        final userInfo = userData['user'];

        // Save token
        await _storageService.saveToken(token);

        // Save user data
        user.value = UserModel.fromJson(userInfo);
        await _storageService.saveUser(user.value!);

        // Save remember me preference
        if (rememberMe.value) {
          await _storageService.saveCredentials(
            emailController.text.trim(),
            passwordController.text,
          );
        }

        isLoggedIn.value = true;

        Get.snackbar(
          'Success',
          responseData['message'] ?? 'Login successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to home
        Get.offAllNamed('/home');
      } else {
        // Error
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Login failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error. Please check your connection.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Sign in error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get user profile
  Future<void> getUserProfile() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse('$baseUrl/auth/profiles/me'), // Update endpoint as needed
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 200) {
          user.value = UserModel.fromJson(responseData['data']['user']);
          await _storageService.saveUser(user.value!);
        }
      }
    } catch (e) {
      print('Get profile error: $e');
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      isLoading.value = true;

      // Clear local storage
      await _storageService.clearAll();

      // Reset controller state
      isLoggedIn.value = false;
      user.value = null;
      emailController.clear();
      passwordController.clear();
      rememberMe.value = false;

      Get.offAllNamed('/signin');

      Get.snackbar(
        'Success',
        'Logged out successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Sign out error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle remember me
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // Load saved credentials
  Future<void> loadSavedCredentials() async {
    final credentials = await _storageService.getSavedCredentials();
    if (credentials != null) {
      emailController.text = credentials['email'] ?? '';
      passwordController.text = credentials['password'] ?? '';
      rememberMe.value = true;
    }
  }

  // Validate sign in form
  bool _validateSignInForm() {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // Sign in with Google (placeholder)
  Future<void> signInWithGoogle() async {
    Get.snackbar(
      'Info',
      'Google Sign-In coming soon!',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Sign in with Facebook (placeholder)
  Future<void> signInWithFacebook() async {
    Get.snackbar(
      'Info',
      'Facebook Sign-In coming soon!',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // In auth_controller.dart
  Future<bool> signUp({
    required String email,
    required String username,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "username": username,
          "firstName": firstName,
          "lastName": lastName,
          "password": password,
        }),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 200) {
        // Show optional snackbar
        Get.snackbar('Success', data['message'] ?? 'Sign up successful!',
            backgroundColor: Colors.green, colorText: Colors.white);
        return true; // <-- Success
      } else {
        Get.snackbar('Error', data['message'] ?? 'Sign up failed',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyOtp({
    required String email,
    required String otp,
    String purpose = 'email_verification',
  }) async {
    isLoading.value = true;
    try {
      final uri = Uri.parse('$baseUrl/auth/verify-otp');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'purpose': purpose,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 200) {
        Get.snackbar('Success', data['message'] ?? "Account verified!",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed('/signin'); // Or to home if needed
        return true;
      } else {
        Get.snackbar(
          'Verification Failed',
          data["message"] ?? "Invalid OTP",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

// RESEND OTP
  Future<void> resendOtp(
      {required String email, String purpose = "email_verification"}) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "purpose": purpose}),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 200) {
        Get.snackbar('Resent', data['message'] ?? "Verification code resent!",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Failed', data['message'] ?? "Couldn't resend code.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot Password API Call
  Future<bool> forgotPassword({required String email}) async {
    isLoading.value = true;
    try {
      final uri = Uri.parse('$baseUrl/auth/forgot-password');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 200) {
        Get.snackbar('Success', data['message'] ?? "Password reset OTP sent!",
            backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      } else {
        Get.snackbar(
          'Error',
          data["message"] ?? "Failed to send reset email",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Network error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Reset Password API Call
  Future<bool> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    isLoading.value = true;
    try {
      final uri = Uri.parse('$baseUrl/auth/reset-password');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 200) {
        Get.snackbar(
            'Success', data['message'] ?? "Password reset successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed('/signin');
        return true;
      } else {
        Get.snackbar(
          'Reset Failed',
          data["message"] ?? "Failed to reset password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
