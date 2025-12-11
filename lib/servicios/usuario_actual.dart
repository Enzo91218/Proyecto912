import 'package:flutter/material.dart';
import '../dominio/entidades/usuario.dart';

class UsuarioActual extends ChangeNotifier {
  Usuario? _usuarioActual;

  Usuario? get usuario => _usuarioActual;
  String get id => _usuarioActual?.id ?? '1';

  void setUsuario(Usuario usuario) {
    _usuarioActual = usuario;
    notifyListeners();
  }

  void limpiar() {
    _usuarioActual = null;
    notifyListeners();
  }
}
