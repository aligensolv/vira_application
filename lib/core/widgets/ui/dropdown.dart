// lib/ui/app_dropdown.dart

import 'package:flutter/material.dart';
import 'package:vira/core/config/app_colors.dart';

// The model for each item in the dropdown
class AppDropdownItem<T> {
  final T value;
  final String text;
  final IconData? icon;

  AppDropdownItem({required this.value, required this.text, this.icon});
}

class AppDropdown<T> extends StatefulWidget {
  final Widget child;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T> onSelected;
  final T? selectedValue; // NEW: To track the currently selected value
  final double? menuWidth;

  const AppDropdown({
    super.key,
    required this.child,
    required this.items,
    required this.onSelected,
    this.selectedValue,
    this.menuWidth = 220,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (_overlayEntry != null) {
      _hideDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    // Get the position and size of the trigger widget
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideDropdown,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Position the dropdown dynamically
          Positioned(
            top: offset.dy + size.height + 4, // Position below the trigger
            left: offset.dx + size.width - (widget.menuWidth ?? 220), // Align right edges
            child: _DropdownMenu<T>(
              items: widget.items,
              selectedValue: widget.selectedValue,
              onSelected: (value) {
                widget.onSelected(value);
                _hideDropdown();
              },
              width: widget.menuWidth,
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    // We no longer need LayerLink, just a simple GestureDetector
    return GestureDetector(
      onTap: _toggleDropdown,
      child: widget.child,
    );
  }
}

// The private widget that renders the dropdown's UI
class _DropdownMenu<T> extends StatelessWidget {
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T> onSelected;
  final T? selectedValue;
  final double? width;

  const _DropdownMenu({
    required this.items,
    required this.onSelected,
    this.selectedValue,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          alignment: Alignment.topRight,
          child: Opacity(opacity: scale, child: child),
        );
      },
      child: Material(
        color: AppColors.card, // The menu background is white as per the image
        // borderRadius: BorderRadius.circular(24),
        shadowColor: Colors.black26,
        child: Container(
          width: width,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black54.withOpacity(0.2), width: 1),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items.map((item) {
              final bool isSelected = item.value == selectedValue;
              return GestureDetector(
                onTap: () => onSelected(item.value),

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    // borderRadius: BorderRadius.circular(12)
                  ),
                  child: Row(
                    children: [
                      if (item.icon != null) ...[
                        Icon(
                          item.icon,
                          size: 20,
                          // Icon color changes based on selection
                          color: isSelected ? Colors.white : Colors.black54,
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          item.text,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            // Text color changes based on selection
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}