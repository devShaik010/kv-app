import 'package:flutter/material.dart';
final navigationIndexNotifier = ValueNotifier<int>(0);
class NavigationController extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners(); // Notifies all listening widgets to rebuild
  }
}