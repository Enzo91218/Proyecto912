import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '../../servicios/usuario_actual.dart';

class CerrarSesion {
  void ejecutar() {
    // Cierra la aplicación completamente
    SystemNavigator.pop();
  }

  void cerrarSesion() {
    // Limpia el usuario actual
    GetIt.instance.get<UsuarioActual>().limpiar();
  }
}
