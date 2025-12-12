import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite/sqflite.dart';
import '../../adaptadores/sqlite/database_provider.dart';

class PantallaDebugBD extends StatefulWidget {
  const PantallaDebugBD({super.key});

  @override
  State<PantallaDebugBD> createState() => _PantallaDebugBDState();
}

class _PantallaDebugBDState extends State<PantallaDebugBD> {
  late Future<void> _loadInfo;
  String _dbPath = '';
  int _usuariosCount = 0;
  int _recetasCount = 0;
  int _dietasCount = 0;
  String _errorMsg = '';
  List<Map<String, dynamic>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _loadInfo = _cargarInfo();
  }

  Future<void> _cargarInfo() async {
    try {
      final dbProvider = GetIt.instance.get<DatabaseProvider>();
      final db = await dbProvider.database;

      // Obtener ruta
      final path = await dbProvider.getDatabasePath();

      // Contar usuarios
      final usuariosData = await db.rawQuery(
        'SELECT COUNT(*) as count FROM usuarios',
      );
      final usuariosCount = Sqflite.firstIntValue(usuariosData) ?? 0;

      // Contar recetas
      final recetasData = await db.rawQuery(
        'SELECT COUNT(*) as count FROM recetas',
      );
      final recetasCount = Sqflite.firstIntValue(recetasData) ?? 0;

      // Contar dietas
      final dietasData = await db.rawQuery(
        'SELECT COUNT(*) as count FROM dietas',
      );
      final dietasCount = Sqflite.firstIntValue(dietasData) ?? 0;

      // Obtener lista de usuarios
      final usuarios = await db.query('usuarios');

      setState(() {
        _dbPath = path;
        _usuariosCount = usuariosCount;
        _recetasCount = recetasCount;
        _dietasCount = dietasCount;
        _usuarios = usuarios;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'Error: $e';
      });
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
        title: const Text('Debug - Base de Datos'),
      ),
      body: FutureBuilder(
        future: _loadInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_errorMsg.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(_errorMsg, textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Información de la BD
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ubicación de BD',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        _dbPath,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Estadísticas
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Usuarios',
                      count: _usuariosCount,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      title: 'Recetas',
                      count: _recetasCount,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      title: 'Dietas',
                      count: _dietasCount,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Lista de usuarios
              if (_usuarios.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Usuarios en la BD',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._usuarios.map((usuario) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                usuario['nombre'] ?? 'Sin nombre',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Email: ${usuario['email']}'),
                              Text('Password: ${usuario['password']}'),
                              Text('Edad: ${usuario['edad']}'),
                              Text('Peso: ${usuario['peso']}kg'),
                              Text('Altura: ${usuario['altura']}cm'),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.warning,
                          color: Colors.orange,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No hay usuarios en la BD',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Necesitas registrar un usuario primero para poder iniciar sesión',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
