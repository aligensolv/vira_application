import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'app_button.dart';

class UnderDevelopmentWidget extends StatelessWidget {
  final String title;
  final bool showBack;

  const UnderDevelopmentWidget({
    super.key,
    this.title = "Work in Progress",
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: showBack
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Construction
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.hexagon_outlined, size: 120, color: AppColors.border),
                  Icon(Icons.construction, size: 48, color: AppColors.primary),
                ],
              ),
              const SizedBox(height: 32),
              
              Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "This feature is currently under development. Stay tuned for updates!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              
              if (showBack)
                SizedBox(
                  width: 200,
                  child: AppButton(
                    text: "GO BACK",
                    type: ButtonType.outline,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}