import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84, // Slightly taller for better touch targets
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _NavItem(
            icon: Icons.grid_view_rounded,
            label: "Explore",
            index: 0,
            currentIndex: currentIndex,
            onTap: onTap,
          ),
          _NavItem(
            icon: Icons.calendar_month_outlined,
            label: "Bookings",
            index: 1,
            currentIndex: currentIndex,
            onTap: onTap,
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: "Profile",
            index: 2,
            currentIndex: currentIndex,
            onTap: onTap,
          ),
          _NavItem(
            icon: Icons.more_horiz_rounded,
            label: "More",
            index: 3,
            currentIndex: currentIndex,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Top Indicator (Animated)
            // Positioned(
            //   top: 0,
            //   left: 0,
            //   right: 0,
            //   child: AnimatedContainer(
            //     duration: const Duration(milliseconds: 200),
            //     height: 3,
            //     margin: EdgeInsets.symmetric(horizontal: isSelected ? 20 : 50),
            //     decoration: BoxDecoration(
            //       color: isSelected ? AppColors.primary : Colors.transparent,
            //     ),
            //   ),
            // ),

            // 2. Icon & Label
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
                    borderRadius: BorderRadius.zero, // Squared background on active
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                    letterSpacing: 0.5,
                    fontFamily: 'Lato', // Ensure font consistency
                  ),
                  child: Text(label.toUpperCase()), // Uppercase for industrial feel
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}