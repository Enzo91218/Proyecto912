import 'package:flutter/material.dart';

class TemaServicio extends ChangeNotifier {
  bool _modoOscuro = false;

  bool get modoOscuro => _modoOscuro;

  void toggleTema() {
    _modoOscuro = !_modoOscuro;
    notifyListeners();
  }

  void setModoOscuro(bool valor) {
    _modoOscuro = valor;
    notifyListeners();
  }
}
