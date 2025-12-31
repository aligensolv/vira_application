import 'package:flutter/material.dart';

extension NavContextExtension on BuildContext {
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<T?> pushReplacement<T>(Widget page) {
    return Navigator.of(this).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  void popUntilFirst() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }

  void pushAndRemoveAll(Widget page) {
    Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }


  void popUntil(RoutePredicate predicate) {
    Navigator.of(this).popUntil(predicate);
  }
}
