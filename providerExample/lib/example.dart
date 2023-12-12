import 'package:flutter/cupertino.dart';

class ProExample extends ChangeNotifier{
  late  int _num =0;

  int get num =>_num;

  int add(){
    _num++;
    notifyListeners();
    return _num;

  }

  int substract(){
    _num--;
    notifyListeners();
    return _num;
  }
}