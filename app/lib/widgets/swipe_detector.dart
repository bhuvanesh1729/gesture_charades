import 'package:flutter/material.dart';

/// A widget that detects swipe gestures
class SwipeDetector extends StatelessWidget {
  /// The child widget
  final Widget child;
  
  /// Callback for swipe up gesture
  final VoidCallback? onSwipeUp;
  
  /// Callback for swipe down gesture
  final VoidCallback? onSwipeDown;
  
  /// Callback for swipe left gesture
  final VoidCallback? onSwipeLeft;
  
  /// Callback for swipe right gesture
  final VoidCallback? onSwipeRight;
  
  /// Minimum distance to detect a swipe
  final double minSwipeDistance;
  
  /// Constructor
  const SwipeDetector({
    super.key,
    required this.child,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.minSwipeDistance = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dy < -300 && onSwipeUp != null) {
          // Swipe up
          onSwipeUp!();
        } else if (details.velocity.pixelsPerSecond.dy > 300 && onSwipeDown != null) {
          // Swipe down
          onSwipeDown!();
        }
      },
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx < -300 && onSwipeLeft != null) {
          // Swipe left
          onSwipeLeft!();
        } else if (details.velocity.pixelsPerSecond.dx > 300 && onSwipeRight != null) {
          // Swipe right
          onSwipeRight!();
        }
      },
      child: child,
    );
  }
}
