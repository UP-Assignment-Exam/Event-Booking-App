// Add these dependencies to your pubspec.yaml:
// image_picker: ^1.0.4
// http: ^1.1.0
// permission_handler: ^11.0.1
// file_picker: ^6.1.1  # For desktop file picking

import 'package:event_booking_app/app/controllers/auth_controller.dart';
import 'package:event_booking_app/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
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
  final authController = Get.find<AuthController>();

  final String baseUrl = 'http://localhost:8080/app';
  // final String baseUrl = 'https://event-booking-backend-k2i1.onrender.com/app';

  // Observable for change password loading state
  final RxBool isChangingPassword = false.obs;
  var isUploading = false.obs;
  var isUpdating = false.obs;
  final ImagePicker _picker = ImagePicker();

  // Check if user is already logged in
  Future<String?> getToken() async {
    final token = await _storageService.getToken();

    if (token != null && token.isNotEmpty) {
      authController.isLoggedIn.value = true;
      return token;
    }

    // Token is missing — redirect and return null
    Get.offAllNamed('/signin');
    return null;
  }

  MediaType _detectMediaType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      default:
        return MediaType('application', 'octet-stream');
    }
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
          contentType: _detectMediaType(fileName),
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

// Method to change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    isChangingPassword.value = true;
    try {
      final token = await getToken();
      if (token == null) {
        Get.snackbar(
          'Error',
          'Authentication token not found. Please login again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Client-side validation
      if (newPassword != confirmPassword) {
        Get.snackbar(
          'Error',
          'New passwords do not match',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      if (newPassword.length < 6) {
        Get.snackbar(
          'Error',
          'New password must be at least 6 characters long',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      final uri = Uri.parse('$baseUrl/profiles/change-password');

      final requestBody = {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(requestBody),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 200) {
        Get.snackbar(
          'Success',
          'Password changed successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Change Password Failed',
          data["message"] ?? "Failed to change password",
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
      isChangingPassword.value = false;
    }
  }

// Method to show change password dialog
  void showChangePasswordDialog(BuildContext context) {
    // Controllers for text fields
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    // Form key for validation
    final formKey = GlobalKey<FormState>();

    // Observable for password visibility
    final RxBool showCurrentPassword = false.obs;
    final RxBool showNewPassword = false.obs;
    final RxBool showConfirmPassword = false.obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Current Password
                    Obx(() => TextFormField(
                          controller: currentPasswordController,
                          obscureText: !showCurrentPassword.value,
                          decoration: InputDecoration(
                            labelText: 'Current Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showCurrentPassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                showCurrentPassword.value =
                                    !showCurrentPassword.value;
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Current password is required';
                            }
                            return null;
                          },
                        )),
                    const SizedBox(height: 16),

                    // New Password
                    Obx(() => TextFormField(
                          controller: newPasswordController,
                          obscureText: !showNewPassword.value,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showNewPassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                showNewPassword.value = !showNewPassword.value;
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'New password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        )),
                    const SizedBox(height: 16),

                    // Confirm Password
                    Obx(() => TextFormField(
                          controller: confirmPasswordController,
                          obscureText: !showConfirmPassword.value,
                          decoration: InputDecoration(
                            labelText: 'Confirm New Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showConfirmPassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                showConfirmPassword.value =
                                    !showConfirmPassword.value;
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your new password';
                            }
                            if (value != newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        )),
                    const SizedBox(height: 16),

                    // Password requirements
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password Requirements:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '• At least 6 characters long',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '• Should be different from current password',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            Obx(() => ElevatedButton(
                  onPressed: isChangingPassword.value
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            final success = await changePassword(
                              currentPassword: currentPasswordController.text,
                              newPassword: newPasswordController.text,
                              confirmPassword: confirmPasswordController.text,
                            );

                            if (success) {
                              Navigator.of(context).pop();
                              // Clear the text fields
                              currentPasswordController.clear();
                              newPasswordController.clear();
                              confirmPasswordController.clear();
                            }
                          }
                        },
                  child: isChangingPassword.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Change Password'),
                )),
          ],
        );
      },
    );
  }

  // Method to update basic profile information
  Future<bool> updateBasicProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    String? phone,
  }) async {
    isUpdating.value = true;
    try {
      final token = await getToken();
      if (token == null) {
        Get.snackbar(
          'Error',
          'Authentication token not found. Please login again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      final uri = Uri.parse('$baseUrl/profiles/basic');

      final requestBody = {
        "firstName": firstName.trim(),
        "lastName": lastName.trim(),
        "email": email.trim(),
        "username": username.trim(),
        if (phone != null && phone.isNotEmpty) "phone": phone.trim(),
      };

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(requestBody),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 200) {
        // Update the user data in AuthController
        final AuthController authController = Get.find<AuthController>();
        await authController.getUserProfile(); // Refresh user data

        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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

// Method to show edit profile dialog
  void showEditProfileDialog(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final user = authController.user.value;

    if (user == null) return;

    // Controllers for text fields
    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final emailController = TextEditingController(text: user.email);
    final usernameController = TextEditingController(text: user.username);
    final phoneController = TextEditingController(text: user.phone ?? '');

    // Form key for validation
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!GetUtils.isEmail(value.trim())) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username is required';
                        }
                        if (value.trim().length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            Obx(() => ElevatedButton(
                  onPressed: isUpdating.value
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            final success = await updateBasicProfile(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              email: emailController.text,
                              username: usernameController.text,
                              phone: phoneController.text.isEmpty
                                  ? null
                                  : phoneController.text,
                            );

                            if (success) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                  child: isUpdating.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Update'),
                )),
          ],
        );
      },
    );
  }

  // Update profile with new avatar URL
  Future<bool> updateProfileAvatar(String avatarUrl) async {
    isUpdating.value = true;
    try {
      final token = await getToken();
      if (token == null) return false; // stop if not logged in

      final uri = Uri.parse('$baseUrl/profiles/cover');

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

        // ✅ Update the user data directly with the new avatar
        await authController.getUserProfile(); // Refresh user data
        authController.user
            .refresh(); // Add this line to force GetX to notify all Obx widgets
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
