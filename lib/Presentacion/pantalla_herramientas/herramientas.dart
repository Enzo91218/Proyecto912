import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../adaptadores/sqlite/database_provider.dart';
import '../../servicios/database_sync_service.dart';

class PantallaHerramientas extends StatelessWidget {
  const PantallaHerramientas({Key? key}) : super(key: key);

  Future<void> _exportarBaseDatos(BuildContext context) async {
    try {
      // Obtener la ruta de la base de datos actual
      final dbFolder = p.join(
        Directory.systemTemp.path,
        'proyecto912_db',
      );
      final dbPath = p.join(dbFolder, 'proyecto912.db');
      final dbFile = File(dbPath);

      if (!dbFile.existsSync()) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Base de datos no encontrada')),
        );
        return;
      }

      // Copiar a una ubicación temporal para compartir
      final tempDir = await getTemporaryDirectory();
      final exportPath = p.join(tempDir.path, 'proyecto912.db');
      await dbFile.copy(exportPath);

      // Compartir el archivo
      await Share.shareXFiles(
        [XFile(exportPath)],
        subject: 'Base de datos - proyecto912.db',
        text: 'Base de datos exportada. Guárdalo en assets/db/proyecto912.db',
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Base de datos lista para descargar')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _mostrarInfoBaseDatos(BuildContext context) async {
    try {
      final db = DatabaseProvider.instance.database;
      
      final usuarios = db.select('SELECT COUNT(*) as count FROM usuarios').first;
      final registrosPeso = db.select('SELECT COUNT(*) as count FROM registro_peso_altura').first;
      final registrosIMC = db.select('SELECT COUNT(*) as count FROM registro_imc').first;

      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Estado de la Base de Datos'),
          content: Text(
            'Usuarios: ${usuarios['count']}\n'
            'Registros Peso/Altura: ${registrosPeso['count']}\n'
            'Registros IMC: ${registrosIMC['count']}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _mostrarComandoActualizacion(BuildContext context) async {
    try {
      final comando = await DatabaseSyncService.instance.generarComandoCopia();
      final rutaDb = await DatabaseSyncService.instance.obtenerRutaBaseDatos();

      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Actualizar Assets'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('La BD está en:'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(rutaDb),
                ),
                const SizedBox(height: 16),
                const Text('Ejecuta este comando en terminal:'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(comando),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: comando));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comando copiado al portapapeles')),
                );
              },
              child: const Text('Copiar Comando'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Herramientas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Ver Estado de BD'),
              subtitle: const Text('Muestra cantidad de registros'),
              onTap: () => _mostrarInfoBaseDatos(context),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Exportar Base de Datos'),
              subtitle: const Text('Descarga proyecto912.db actualizado'),
              onTap: () => _exportarBaseDatos(context),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.terminal),
              title: const Text('Actualizar Assets'),
              subtitle: const Text('Genera comando para actualizar BD en assets'),
              onTap: () => _mostrarComandoActualizacion(context),
            ),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Sincronización automática:\n\n'
              '✅ Cada cambio en BD se guarda automáticamente\n'
              '✅ Usa "Actualizar Assets" para sincronizar con el proyecto\n'
              '✅ Copia y pega el comando en tu terminal\n\n'
              'El archivo será actualizado en assets/db/proyecto912.db',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Volver al Menú'),
              subtitle: const Text('Regresa al menú principal'),
              onTap: () => context.go('/'),
            ),
          ),
        ],
      ),
    );
  }
}
