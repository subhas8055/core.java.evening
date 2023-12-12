import 'dart:collection';

import 'package:flutter/cupertino.dart';

class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  int get totalPrice => _items.length * 42;

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}

class Item {
  String? name;
  double count=5;
  final double price=1000.00;
  late double totalPrice = price*count;

}