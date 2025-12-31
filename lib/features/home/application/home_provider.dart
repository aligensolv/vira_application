import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple state to test Riverpod
final homeCounterProvider = StateProvider<int>((ref) => 0);