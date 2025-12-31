import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Lato', // Ensure you have fonts/Lato.ttf in assets and pubspec.yaml
      
      // Colors
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.destructive,
        background: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Lato',
          
        ),
      ),
      
      // Bottom Nav Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      dialogTheme: DialogThemeData(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero, // Set border radius to zero for rectangular corners
                              ),
                            ),

                            timePickerTheme: TimePickerThemeData(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero, // Set border radius to zero for rectangular corners
                              ),
                              dayPeriodShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero, // Set border radius to zero for rectangular corners
                              ),
                              hourMinuteShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero, // Set border radius to zero for rectangular corners
                              ),

                              confirmButtonStyle: ButtonStyle(
                                // textStyle: MaterialStatePropertyAll(TextStyle(
                                //   color: AppColors.primary
                                // )),

                                foregroundColor: MaterialStatePropertyAll(AppColors.primary)
                              ),

                              dayPeriodBorderSide: BorderSide(color: AppColors.secondary),
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero, // Set border radius to zero for rectangular corners
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                              ),

                              hourMinuteTextStyle: TextStyle(
                                fontSize: 28
                              )
                            )
    );
  }
}