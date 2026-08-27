import 'package:flutter/material.dart';

enum SmartTransitionType {
  fade,
  scale,
  slideRight,
  slideLeft,
  slideBottom,
  slideTop,
  scaleFade,
  iosCardStack,
  zAxisZoom,
  rotateFade,
}

class SmartNavigation {
  SmartNavigation._();

  /// Create a route with a specific custom transition
  static Route<T> createRoute<T>({
    required Widget page,
    SmartTransitionType type = SmartTransitionType.slideRight,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        // Safeguard: Ignore pointer events during route transitions to prevent hit-testing unlaid-out boxes
        final safeChild = AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final isTransitioning = !animation.isCompleted && !animation.isDismissed;
            return IgnorePointer(
              ignoring: isTransitioning,
              child: child,
            );
          },
          child: child,
        );

        switch (type) {
          case SmartTransitionType.fade:
            return FadeTransition(opacity: curvedAnimation, child: safeChild);

          case SmartTransitionType.scale:
            return ScaleTransition(
              scale: curvedAnimation,
              alignment: Alignment.center,
              child: safeChild,
            );

          case SmartTransitionType.slideRight:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: safeChild,
            );

          case SmartTransitionType.slideLeft:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: safeChild,
            );

          case SmartTransitionType.slideBottom:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: safeChild,
            );

          case SmartTransitionType.slideTop:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: safeChild,
            );

          case SmartTransitionType.scaleFade:
            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.85, end: 1.0).animate(curvedAnimation),
                alignment: Alignment.center,
                child: safeChild,
              ),
            );

          case SmartTransitionType.iosCardStack:
            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.08),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.92, end: 1.0).animate(curvedAnimation),
                  alignment: Alignment.bottomCenter,
                  child: safeChild,
                ),
              ),
            );

          case SmartTransitionType.zAxisZoom:
            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.15, end: 1.0).animate(curvedAnimation),
                alignment: Alignment.center,
                child: safeChild,
              ),
            );

          case SmartTransitionType.rotateFade:
            return FadeTransition(
              opacity: curvedAnimation,
              child: RotationTransition(
                turns: Tween<double>(begin: -0.04, end: 0.0).animate(curvedAnimation),
                alignment: Alignment.center,
                child: safeChild,
              ),
            );
        }
      },
    );
  }

  /// Helper to push a page with a transition
  static Future<T?> push<T>(
    BuildContext context,
    Widget page, {
    SmartTransitionType transition = SmartTransitionType.slideRight,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return Navigator.push<T>(
      context,
      createRoute<T>(
        page: page,
        type: transition,
        duration: duration,
        curve: curve,
      ),
    );
  }

  /// Helper to push and replace with a transition
  static Future<T?> pushReplacement<T, TO>(
    BuildContext context,
    Widget page, {
    SmartTransitionType transition = SmartTransitionType.slideRight,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return Navigator.pushReplacement<T, TO>(
      context,
      createRoute<T>(
        page: page,
        type: transition,
        duration: duration,
        curve: curve,
      ),
    );
  }
}
