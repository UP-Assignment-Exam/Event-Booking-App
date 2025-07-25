import 'package:flutter/material.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;

  const CustomTopBar({
    Key? key,
    this.onNotificationTap,
  }) : super(key: key);

  static const double _headerHeight = 140; // reduced height for compactness

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: const Color(0xFF4A43EC), // Same as appbar bottom
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Logo positioned to extend beyond the AppBar bounds
            Positioned(
              left: 16,
              right: 56, // space for notification icon
              top: -10, // extend above
              bottom: -10, // extend below
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/BayonPass_logo_white.png',
                    height: _headerHeight + 40, // larger than AppBar height
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Notification button positioned absolutely
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  onPressed: onNotificationTap,
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  tooltip: 'Notifications',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_headerHeight);
}
