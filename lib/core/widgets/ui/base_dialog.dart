import 'package:flutter/material.dart';
import 'package:vira/core/config/app_colors.dart';

enum DialogVariant {
  primary, // Dark theme
  secondary, // Light theme
}

/// A foundational dialog widget that provides the container, styling, and entry animation.
/// It is designed to be composed by more specific dialog widgets like ConfirmationDialog.
class BaseDialog extends StatelessWidget {
  /// The content to display inside the dialog.
  final Widget child;
  
  /// The visual style of the dialog (dark or light).
  final DialogVariant variant;
  
  /// The border radius of the dialog container.
  final double borderRadius;

  /// An optional fixed width for the dialog.
  final double? width;

  const BaseDialog({
    super.key,
    required this.child,
    this.variant = DialogVariant.primary,
    this.borderRadius = 0.0,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = AppColors.background; // Dark grey or white

    return Dialog(
      backgroundColor: Colors.transparent, // The actual dialog is transparent to allow custom shape and animation
      insetPadding: const EdgeInsets.all(16.0),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: FadeTransition(
          opacity: ModalRoute.of(context)!.animation!,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width ?? 600),
            child: Material(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}