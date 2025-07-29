import 'package:event_booking_app/app/controllers/auth_controller.dart';
import 'package:event_booking_app/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// Profile Upload Controller
class ProfileController extends GetxController {
  final String baseUrl = 'https://event-booking-backend-k2i1.onrender.com/app';

  final StorageService _storageService = Get.find<StorageService>();
  var isUploading = false.obs;
  var isUpdating = false.obs;
  final ImagePicker _picker = ImagePicker();

  // Upload image to server
  Future<String?> uploadProfileImage(File imageFile) async {
    isUploading.value = true;
    try {
      final token = await _storageService.getToken();

      if (token == null) {
        Get.snackbar('Session Expired', 'Token not found. Please log in again.',
            snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed('/login');
        return "";
      }

      final uri = Uri.parse('$baseUrl/profiles/upload');

      var request = http.MultipartRequest('POST', uri);

      // Add the file to the request
      var multipartFile = await http.MultipartFile.fromPath(
        'file', // This should match your API's expected field name
        imageFile.path,
      );
      request.files.add(multipartFile);

      request.headers['Authorization'] = 'Bearer $token';

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);

      if (response.statusCode == 200 && data["success"] == true) {
        Get.snackbar('Success', 'Image uploaded successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);
        return data['url']; // Return the uploaded image URL
      } else {
        Get.snackbar(
          'Upload Failed',
          data["message"] ?? "Failed to upload image",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isUploading.value = false;
    }
  }

  // Update profile with new avatar URL
  Future<bool> updateProfileAvatar(String avatarUrl) async {
    isUpdating.value = true;
    try {
      final uri = Uri.parse('$baseUrl/profiles/cover');

      final token = await _storageService.getToken();

      if (token == null) {
        Get.snackbar('Session Expired', 'Token not found. Please log in again.',
            snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed(
            '/login'); // or Get.offAll(LoginPage()) if not using named routes
        return false;
      }

      final authController = Get.find<AuthController>();
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'avatar': avatarUrl,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 200) {
        Get.snackbar(
            'Success', data['message'] ?? 'Profile updated successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);

        // Update the user data in auth controller
        await authController.getUserProfile(); // Refresh user data
        return true;
      } else {
        Get.snackbar(
          'Update Failed',
          data["message"] ?? "Failed to update profile",
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
      isUpdating.value = false;
    }
  }

  // Show image picker options
  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Profile Picture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildPickerOption(
                      icon: Icons.camera_alt,
                      title: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPickerOption(
                      icon: Icons.photo_library,
                      title: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF667eea)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        // Show confirmation dialog
        Get.dialog(
          _buildUploadConfirmationDialog(File(image.path)),
          barrierDismissible: false,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildUploadConfirmationDialog(File imageFile) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Upload Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                imageFile,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => ElevatedButton(
                        onPressed: isUploading.value || isUpdating.value
                            ? null
                            : () async {
                                await _uploadAndUpdateProfile(imageFile);
                                Get.back();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF667eea),
                          foregroundColor: Colors.white,
                        ),
                        child: isUploading.value || isUpdating.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Upload'),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Upload image and update profile
  Future<void> _uploadAndUpdateProfile(File imageFile) async {
    // First upload the image
    final imageUrl = await uploadProfileImage(imageFile);

    if (imageUrl != null) {
      // Then update the profile with the new avatar URL
      await updateProfileAvatar(imageUrl);
    }
  }
}
