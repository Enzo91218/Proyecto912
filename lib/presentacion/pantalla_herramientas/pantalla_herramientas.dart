import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../adaptadores/sqlite/database_provider.dart';
import '../../servicios/database_update_service.dart';

class PantallaHerramientas extends StatefulWidget {
  const PantallaHerramientas({super.key});

  @override
  State<PantallaHerramientas> createState() => _PantallaHerramientasState();
}

class _PantallaHerramientasState extends State<PantallaHerramientas> {
  final DatabaseProvider _databaseProvider =
      GetIt.instance.get<DatabaseProvider>();
  late DatabaseUpdateService _updateService;
  String? _dbPath;
  String? _dbSize;

  @override
  void initState() {
    super.initState();
    _updateService = GetIt.instance.get<DatabaseUpdateService>();
    _loadDatabaseInfo();
  }

  Future<void> _loadDatabaseInfo() async {
    final path = await _databaseProvider.getDatabasePath();
    final file = File(path);

    if (await file.exists()) {
      final size = await file.length();
      final sizeInKB = (size / 1024).toStringAsFixed(2);

      setState(() {
        _dbPath = path;
        _dbSize = '$sizeInKB KB';
      });
    }
  }

  Future<void> _downloadDatabase() async {
    try {
      if (_dbPath == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo encontrar la base de datos'),
          ),
        );
        return;
      }

      // Copiar archivo a la carpeta de descargas
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo acceder a la carpeta de descargas'),
          ),
        );
        return;
      }

      final sourceFile = File(_dbPath!);
      final timestamp =
          DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
      final downloadPath = '${downloadsDir.path}/proyecto912_$timestamp.db';

      await sourceFile.copy(downloadPath);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Base de datos descargada en: $downloadPath'),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Herramientas'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de Base de Datos
          _buildSection(
            title: 'Base de Datos',
            children: [
              _buildInfoCard(
                icon: Icons.storage,
                title: 'Ubicación',
                value: _dbPath ?? 'Cargando...',
                subtitle: 'Sistema de archivos local',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.sd_storage,
                title: 'Tamaño',
                value: _dbSize ?? 'Cargando...',
                subtitle: 'Espacio ocupado',
              ),
              const SizedBox(height: 12),
              ListenableBuilder(
                listenable: _updateService,
                builder:
                    (context, _) => _buildInfoCard(
                      icon: Icons.update,
                      title: 'Última Actualización',
                      value: _updateService.lastUpdateFormatted,
                      subtitle: 'Cambios registrados',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sección de Acciones
          _buildSection(
            title: 'Acciones',
            children: [
              ElevatedButton.icon(
                onPressed: _downloadDatabase,
                icon: const Icon(Icons.download),
                label: const Text('Descargar Base de Datos'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sección de Información
          _buildSection(
            title: 'Información',
            children: [
              _buildInfoTile(
                icon: Icons.info,
                title: 'Sobre esta aplicación',
                subtitle: 'Proyecto912 v1.0.0',
              ),
              const Divider(height: 16),
              _buildInfoTile(
                icon: Icons.storage,
                title: 'Base de datos SQLite',
                subtitle: 'Almacenamiento local seguro',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
