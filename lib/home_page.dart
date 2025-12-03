import 'package:flutter/material.dart';
import 'database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> usuarios = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Consultar la tabla usuarios
      final resultado = await DatabaseHelper.query('usuarios');

      setState(() {
        usuarios = resultado;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar usuarios: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        elevation: 2,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUsuarios,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : usuarios.isEmpty
                  ? const Center(
                      child: Text('No hay usuarios en la base de datos'),
                    )
                  : ListView.builder(
                      itemCount: usuarios.length,
                      itemBuilder: (context, index) {
                        final usuario = usuarios[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(usuario['nombre'] ?? 'Sin nombre'),
                          subtitle: Text(usuario['email'] ?? 'Sin email'),
                          trailing: Text(usuario['id']?.toString() ?? ''),
                          onTap: () {
                            // Mostrar detalles del usuario
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Detalles del Usuario'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: usuario.entries
                                        .map(
                                          (entry) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              '${entry.key}: ${entry.value}',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cerrar'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadUsuarios,
        tooltip: 'Recargar',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
