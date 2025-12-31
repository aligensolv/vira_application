import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'app_switch.dart';

class AppTileGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const AppTileGroup({
    super.key,
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              title!.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.black.withOpacity(0.1)),
              bottom: BorderSide(color: Colors.black.withOpacity(0.1)),
              left: BorderSide(color: Colors.black.withOpacity(0.1)),
              right: BorderSide(color: Colors.black.withOpacity(0.1)),
            ),
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final index = entry.key;
              final child = entry.value;
              final isLast = index == children.length - 1;

              return Container(
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : Border(
                          bottom: BorderSide(color: Colors.black.withOpacity(0.1), width: 0.5),
                        ),
                ),
                child: child,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class AppTile extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String? subLabel;
  final VoidCallback? onTap;
  final bool showChevron;
  final Widget? trailing;
  final Color? iconColor;
  final Color? labelColor;

  const AppTile({
    super.key,
    required this.label,
    this.icon,
    this.subLabel,
    this.onTap,
    this.showChevron = true,
    this.trailing,
    this.iconColor,
    this.labelColor,
  });

  /// Specialized factory for a Switch Tile
  factory AppTile.switchTile({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AppTile(
      icon: icon,
      label: label,
      showChevron: false,
      onTap: () => onChanged(!value), // Tapping row toggles switch
      trailing: AppSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.black,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22, color: iconColor ?? AppColors.secondary),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: labelColor ?? AppColors.textPrimary,
                    ),
                  ),
                  if (subLabel != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subLabel!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (showChevron)
              const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}