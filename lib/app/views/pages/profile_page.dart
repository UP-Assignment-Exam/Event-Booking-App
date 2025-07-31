import 'package:event_booking_app/app/controllers/auth_controller.dart';
import 'package:event_booking_app/app/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Updated ProfilePage with upload functionality
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final AuthController authController = Get.find<AuthController>();
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final user = authController.user.value;
        // If user is null, try to refetch user data
        if (user == null) {
          // Check if we're already loading to avoid multiple calls
          if (!authController.isLoading.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _refetchUserData(authController);
            });
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF667eea),
                  Color(0xFF764ba2),
                ],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading profile...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {}, // Settings action
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Avatar section with upload functionality
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Stack(
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Obx(() => ClipOval(
                                    child: authController.user.value?.avatar !=
                                                null &&
                                            authController.user.value?.avatar !=
                                                ""
                                        ? Image.network(
                                            Uri.encodeFull(
                                                "${authController.user.value?.avatar}?v=${DateTime.now().millisecondsSinceEpoch}"),
                                            fit: BoxFit.cover,
                                            width: 140,
                                            height: 140,
                                            headers: {
                                              'Cache-Control':
                                                  'no-cache, no-store, must-revalidate',
                                              'Pragma': 'no-cache',
                                              'Expires': '0',
                                            },
                                            // errorBuilder:
                                            //     (context, error, stackTrace) {
                                            //   return Container(
                                            //     width: 140,
                                            //     height: 140,
                                            //     color: Colors.grey[300],
                                            //     child: const Icon(
                                            //       Icons.person,
                                            //       size: 60,
                                            //       color: Colors.grey,
                                            //     ),
                                            //   );
                                            // },
                                          )
                                        : Container(
                                            width: 140,
                                            height: 140,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  )),
                              // Upload overlay when uploading
                              Obx(() => profileController.isUploading.value ||
                                      profileController.isUpdating.value
                                  ? Container(
                                      width: 140,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink()),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              profileController.showImagePickerOptions(context);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Color(0xFF667eea),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Name & Username
                  Text(
                    '${user.firstName.toUpperCase()} ${user.lastName.toUpperCase()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '@${user.username}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Status badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: user.isActive ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          user.isActive ? Icons.check_circle : Icons.cancel,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user.isActive ? 'Active' : 'Inactive',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Info cards
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildInfoCard(
                          icon: Icons.email,
                          title: 'Email Address',
                          subtitle: user.email,
                          trailing: user.emailVerified
                              ? const Icon(Icons.verified,
                                  color: Colors.green, size: 20)
                              : const Icon(Icons.error,
                                  color: Colors.orange, size: 20),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.person,
                          title: 'Username',
                          subtitle: user.username,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.calendar_today,
                          title: 'Member Since',
                          subtitle: _formatDate(user.createdAt),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.update,
                          title: 'Last Updated',
                          subtitle: _formatDate(user.updatedAt),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Actions
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildActionButton(
                          icon: Icons.edit,
                          title: 'Edit Profile',
                          onTap: () {
                            profileController.showEditProfileDialog(context);
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          icon: Icons.security,
                          title: 'Change Password',
                          onTap: () {
                            profileController.showChangePasswordDialog(context);
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          icon: Icons.logout,
                          title: 'Logout',
                          onTap: () async {
                            await authController.signOut();
                          },
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withOpacity(0.1)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDestructive
                ? Colors.red.withOpacity(0.3)
                : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDestructive ? Colors.red : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDestructive
                  ? Colors.red.withOpacity(0.7)
                  : Colors.white.withOpacity(0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// Method to refetch user data
Future<void> _refetchUserData(AuthController authController) async {
  try {
    await authController.getUserProfile();

    // If still null after refetch, there might be an auth issue
    if (authController.user.value == null) {
      await authController.checkAuthStatus();
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to load profile data',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
