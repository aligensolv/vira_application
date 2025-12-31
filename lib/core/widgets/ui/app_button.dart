import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for Haptics
import '../../config/app_colors.dart';

enum ButtonType { primary, secondary, outline, ghost, accent }

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final IconData? icon;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.icon,
    this.isFullWidth = true,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // Fast, snappy response
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void _onTapDown(TapDownDetails details) {
  //   if (widget.isLoading || widget.onPressed == null) return;
  //   // 1. Tactile Feedback
  //   HapticFeedback.lightImpact(); 
  //   // 2. Start Animation
  //   _controller.forward();
  // }

  // void _onTapUp(TapUpDetails details) {
  //   if (widget.isLoading || widget.onPressed == null) return;
  //   _controller.reverse();
  // }

  // void _onTapCancel() {
  //   if (widget.isLoading || widget.onPressed == null) return;
  //   _controller.reverse();
  // }

  @override
  Widget build(BuildContext context) {
    final style = _getButtonStyle();
    
    // Content Logic
    final child = widget.isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _getLoaderColor(),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14, // Slightly larger for better touch target
                  letterSpacing: 0.5,
                ),
              ),
            ],
          );

    // The Button Widget
    final button = ElevatedButton(
      onPressed: widget.onPressed,
      style: style,
      child: child,
    );

    // Wrapping in Gesture Detector to handle the Scale Animation manually
    // while keeping the ElevatedButton's internal Ripple effect.
    return GestureDetector(
      // onTapDown: _onTapDown,
      // onTapUp: _onTapUp,
      // onTapCancel: _onTapCancel,
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onPressed?.call();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: widget.isFullWidth 
          ? SizedBox(width: double.infinity, height: 40, child: button) 
          : SizedBox(height: 40, child: button),
      ),
    );
  }

  Color _getLoaderColor() {
    if (widget.type == ButtonType.outline || widget.type == ButtonType.ghost || widget.type == ButtonType.accent) {
      return AppColors.secondary;
    }
    return Colors.white;
  }

  ButtonStyle _getButtonStyle() {
    Color bg;
    Color fg;
    Color overlay; // The Ripple Color
    BorderSide side = BorderSide.none;

    switch (widget.type) {
      case ButtonType.primary:
        bg = AppColors.primary;
        fg = Colors.white;
        overlay = Colors.white.withOpacity(0.2);
        break;
      case ButtonType.secondary:
        bg = AppColors.secondary;
        fg = Colors.white;
        overlay = Colors.white.withOpacity(0.1);
        break;
      case ButtonType.accent:
        bg = Colors.white;
        fg = Colors.black;
        overlay = Colors.black.withOpacity(0.1);
        break;
      case ButtonType.outline:
        bg = Colors.transparent;
        fg = AppColors.secondary;
        side = const BorderSide(color: AppColors.border, width: 1.5); // Thicker border
        overlay = AppColors.secondary.withOpacity(0.1);
        break;
      case ButtonType.ghost:
        bg = Colors.transparent;
        fg = AppColors.secondary;
        overlay = AppColors.secondary.withOpacity(0.1);
        break;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      shadowColor: Colors.transparent, // Flat design
      elevation: 0,
      side: side,
      // Increased padding for a chunky, satisfying feel
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0), 
      // Distinct Ripple Color
      overlayColor: overlay,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );
  }
}