import 'package:event_booking_app/app/views/pages/events_page.dart';
import 'package:event_booking_app/app/views/pages/home_page_content.dart';
import 'package:event_booking_app/app/views/pages/profile_page.dart';
import 'package:event_booking_app/app/views/pages/ticket_pass_page.dart';
import 'package:event_booking_app/app/views/widgets/appbar_widget.dart'
    as appbar_widget;
import 'package:event_booking_app/app/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  int _previousIndex = 0; // Needed for transition direction

  // Pre-built pages for fast swaps
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePageContent(),
      const EventsPage(),
      const TicketPassPage(),
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      HapticFeedback.lightImpact();
      setState(() {
        _previousIndex = _selectedIndex;
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isForward = _selectedIndex > _previousIndex;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBody: true,
      appBar: _selectedIndex == 0
          ? appbar_widget.CustomTopBar(
              onNotificationTap: () {
                debugPrint('Notification tapped');
              },
            )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeInOutCubic,
        transitionBuilder: (child, animation) {
          // Slide and fade: right for forward, left for back
          final offsetStart =
              isForward ? const Offset(1, 0) : const Offset(-1, 0);
          return SlideTransition(
            position: Tween<Offset>(begin: offsetStart, end: Offset.zero)
                .animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Container(
          // Super important: Unique key on page; triggers the animation
          key: ValueKey<int>(_selectedIndex),
          padding: const EdgeInsets.only(bottom: 10),
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
