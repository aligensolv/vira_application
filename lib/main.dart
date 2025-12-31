import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/core/services/cache_service.dart';
import 'package:vira/features/intro/presentation/screens/splash_screen.dart';
import 'core/config/app_constants.dart';
import 'core/config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.init();
  
  runApp(
    ProviderScope(
      child: const ViraApp(),
    ),
  );
}

class ViraApp extends ConsumerWidget  {
  const ViraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // home: authState.value != null 
      //     ? const MainLayoutScreen() 
      //     : const LoginScreen(),

      home: SplashScreen(),
    );
  }
}