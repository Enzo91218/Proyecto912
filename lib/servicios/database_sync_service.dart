import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Servicio para sincronizar la base de datos
class DatabaseSyncService {
  DatabaseSyncService._internal();

  static final DatabaseSyncService instance = DatabaseSyncService._internal();

  /// Obtiene la ruta actual de la BD en el dispositivo
  Future<String> obtenerRutaBaseDatos() async {
    final dbFolder = p.join(
      Directory.systemTemp.path,
      'proyecto912_db',
    );
    return p.join(dbFolder, 'proyecto912.db');
  }

  /// Obtiene la ruta donde debería estar en assets
  String obtenerRutaAssets() {
    return 'assets/db/proyecto912.db';
  }

  /// Genera el comando para copiar la BD a assets
  Future<String> generarComandoCopia() async {
    final rutaDispositivo = await obtenerRutaBaseDatos();
    final rutaAssets = obtenerRutaAssets();
    
    // Para Windows
    if (Platform.isWindows) {
      return 'copy "$rutaDispositivo" "$rutaAssets"';
    }
    // Para Linux/Mac
    else {
      return 'cp "$rutaDispositivo" "$rutaAssets"';
    }
  }

  /// Copia la BD a DocumentsDirectory para acceso manual
  Future<void> copiarADocumentos() async {
    try {
      final dbFolder = p.join(
        Directory.systemTemp.path,
        'proyecto912_db',
      );
      final dbPathTemp = p.join(dbFolder, 'proyecto912.db');
      final dbFileTemp = File(dbPathTemp);

      if (!dbFileTemp.existsSync()) {
        print('⚠️ Base de datos temporal no encontrada en: $dbPathTemp');
        return;
      }

      final appDocDir = await getApplicationDocumentsDirectory();
      final dbPathDocuments = p.join(appDocDir.path, 'proyecto912_backup.db');
      final dbFileDocuments = File(dbPathDocuments);

      await dbFileTemp.copy(dbFileDocuments.path);
      print('✅ BD copiada a: $dbPathDocuments');
      print('📋 Comando para actualizar assets:');
      print(await generarComandoCopia());
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  /// Sincroniza y registra un evento para debugging
  Future<void> sincronizarConLog(String evento) async {
    print('📊 Evento de BD: $evento');
    await copiarADocumentos();
  }
}
