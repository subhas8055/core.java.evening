import 'package:flutter/cupertino.dart';

class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // Notifies listeners about the change in count
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}
