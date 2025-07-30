// Add these dependencies to your pubspec.yaml:
// image_picker: ^1.0.4
// http: ^1.1.0
// permission_handler: ^11.0.1
// file_picker: ^6.1.1  # For desktop file picking

import 'package:event_booking_app/app/controllers/auth_controller.dart';
import 'package:event_booking_app/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

// Profile Upload Controller
class ProfileController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final String baseUrl = 'https://event-booking-backend-k2i1.onrender.com/app';

  var isUploading = false.obs;
  var isUpdating = false.obs;
  final ImagePicker _picker = ImagePicker();

  // Check if user is already logged in
  Future<String?> getToken() async {
    final authController = Get.find<AuthController>();
    final token = await _storageService.getToken();

    if (token != null && token.isNotEmpty) {
      authController.isLoggedIn.value = true;
      return token;
    }

    // Token is missing — redirect and return null
    Get.offAllNamed('/signin');
    return null;
  }

  // Upload image to server (handles both File and Uint8List for web)
  Future<String?> uploadProfileImage(
      {File? imageFile, Uint8List? imageBytes, String? fileName}) async {
    isUploading.value = true;
    try {
      final token = await getToken();
      if (token == null) return null; // stop if not logged in

      final uri = Uri.parse('$baseUrl/profiles/upload');

      var request = http.MultipartRequest('POST', uri);

      // Add the file to the request - handle both mobile/desktop and web
      http.MultipartFile multipartFile;
      if (kIsWeb && imageBytes != null && fileName != null) {
        multipartFile = http.MultipartFile.fromBytes(
          'file', // This should match your API's expected field name
          imageBytes,
          filename: fileName,
        );
      } else if (imageFile != null) {
        multipartFile = await http.MultipartFile.fromPath(
          'file', // This should match your API's expected field name
          imageFile.path,
        );
      } else {
        throw Exception('No image provided');
      }

      request.files.add(multipartFile);

      request.headers['Authorization'] = token;

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
      final token = await getToken();
      if (token == null) return false; // stop if not logged in

      final uri = Uri.parse('$baseUrl/profiles/cover');

      final authController = Get.find<AuthController>();
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
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

  // Show image picker options with platform-specific handling
  void showImagePickerOptions(BuildContext context) {
    // For web platform
    if (kIsWeb) {
      _showWebImagePicker(context);
      return;
    }

    // For desktop platforms
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _showDesktopImagePicker(context);
      return;
    }

    // Mobile image picker
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

  // Web-specific image picker
  void _showWebImagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Profile Picture'),
          content: const Text('Choose an image file from your computer'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _pickImageForWeb();
              },
              child: const Text('Choose File'),
            ),
          ],
        );
      },
    );
  }

  // Desktop-specific image picker
  void _showDesktopImagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.folder_open),
                title: const Text('Choose from Files'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromFiles();
                },
              ),
              if (Platform.isMacOS ||
                  Platform.isWindows) // Camera might not be available on Linux
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // Web image picker
  Future<void> _pickImageForWeb() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // Important for web - gets the bytes
      );

      if (result != null && result.files.single.bytes != null) {
        final fileBytes = result.files.single.bytes!;
        final fileName = result.files.single.name;

        // Show confirmation dialog for web
        Get.dialog(
          _buildWebUploadConfirmationDialog(fileBytes, fileName),
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

  Widget buildSelectedImage(dynamic image) {
    if (kIsWeb) {
      // For web, image is Uint8List (bytes)
      if (image is Uint8List) {
        return Image.memory(image);
      } else if (image is String) {
        return Image.network(image);
      } else {
        return const Placeholder();
      }
    } else {
      // For mobile/desktop, image is File or path string
      if (image is File) {
        return Image.file(image);
      } else if (image is String) {
        return Image.network(image);
      } else {
        return const Placeholder();
      }
    }
  }

  // Desktop file picker
  Future<void> _pickImageFromFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        File imageFile = File(result.files.single.path!);

        // Show confirmation dialog
        Get.dialog(
          _buildUploadConfirmationDialog(imageFile),
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

  // Pick image from camera or gallery (mobile/desktop)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        if (kIsWeb) {
          // For web, we need to handle it differently
          final imageBytes = await image.readAsBytes();
          Get.dialog(
            _buildWebUploadConfirmationDialog(imageBytes, image.name),
            barrierDismissible: false,
          );
        } else {
          // For mobile/desktop
          Get.dialog(
            _buildUploadConfirmationDialog(File(image.path)),
            barrierDismissible: false,
          );
        }
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

  // Upload confirmation dialog for mobile/desktop (uses File)
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
                                await _uploadAndUpdateProfile(
                                    imageFile: imageFile);
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

  // Upload confirmation dialog for web (uses Uint8List)
  Widget _buildWebUploadConfirmationDialog(
      Uint8List imageBytes, String fileName) {
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
              child: Image.memory(
                imageBytes,
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
                                await _uploadAndUpdateProfile(
                                    imageBytes: imageBytes, fileName: fileName);
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

  // Upload image and update profile (handles both File and Uint8List)
  Future<void> _uploadAndUpdateProfile(
      {File? imageFile, Uint8List? imageBytes, String? fileName}) async {
    // First upload the image
    final imageUrl = await uploadProfileImage(
      imageFile: imageFile,
      imageBytes: imageBytes,
      fileName: fileName,
    );

    if (imageUrl != null) {
      // Then update the profile with the new avatar URL
      await updateProfileAvatar(imageUrl);
    }
  }
}
