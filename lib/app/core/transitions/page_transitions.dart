// lib/app/core/transitions/page_transitions.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Slide in from the right.
class SlideFromRightTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve ?? Curves.easeInOutCubic,
        ),
      ),
      child: child,
    );
  }
}

/// Slide in from the left.
class SlideFromLeftTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve ?? Curves.easeInOutCubic,
        ),
      ),
      child: child,
    );
  }
}

/// Fade in.
class FadeCustomTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

/// Scale with fade.
class ScaleCustomTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve ?? Curves.easeOutBack,
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

/// Slide up with fade.
class SlideWithFadeTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve ?? Curves.easeOutCubic,
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

/// Helper to create GetPageRoute with optional customTransition.
GetPageRoute getPageRoute({
  required Widget page,
  String? routeName,
  Duration transitionDuration = const Duration(milliseconds: 400),
  Transition? transition,
  CustomTransition? customTransition,
}) {
  return GetPageRoute(
    routeName: routeName,
    page: () => page,
    transitionDuration: transitionDuration,
    transition: transition ?? Transition.rightToLeft,
    customTransition: customTransition,
  );
}

/// Predefined helper methods:
GetPageRoute slideRightRoute({
  required Widget page,
  String? routeName,
  Duration transitionDuration = const Duration(milliseconds: 400),
}) =>
    getPageRoute(
      page: page,
      routeName: routeName,
      transitionDuration: transitionDuration,
      customTransition: SlideFromRightTransition(),
    );

GetPageRoute slideLeftRoute({
  required Widget page,
  String? routeName,
  Duration transitionDuration = const Duration(milliseconds: 400),
}) =>
    getPageRoute(
      page: page,
      routeName: routeName,
      transitionDuration: transitionDuration,
      customTransition: SlideFromLeftTransition(),
    );

GetPageRoute fadeRoute({
  required Widget page,
  String? routeName,
  Duration transitionDuration = const Duration(milliseconds: 400),
}) =>
    getPageRoute(
      page: page,
      routeName: routeName,
      transitionDuration: transitionDuration,
      customTransition: FadeCustomTransition(),
    );

GetPageRoute scaleRoute({
  required Widget page,
  String? routeName,
  Duration transitionDuration = const Duration(milliseconds: 400),
}) =>
    getPageRoute(
      page: page,
      routeName: routeName,
      transitionDuration: transitionDuration,
      customTransition: ScaleCustomTransition(),
    );

GetPageRoute slideWithFadeRoute({
  required Widget page,
  String? routeName,
  Duration transitionDuration = const Duration(milliseconds: 400),
}) =>
    getPageRoute(
      page: page,
      routeName: routeName,
      transitionDuration: transitionDuration,
      customTransition: SlideWithFadeTransition(),
    );
