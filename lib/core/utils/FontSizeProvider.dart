import 'package:flutter/material.dart';

class FontSizeProvider with ChangeNotifier {
  double _fontSize = 16.0; // Tamaño de fuente inicial

  double get fontSize => _fontSize;

  void setFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners(); // Notifica a los widgets que dependen de este valor
  }
}
