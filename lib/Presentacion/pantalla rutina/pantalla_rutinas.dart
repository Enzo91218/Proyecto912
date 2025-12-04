import 'package:flutter/material.dart';
import '../../adaptadores/adaptadorderutinas_en_memoria.dart';
import '../../dominio/entidades/rutina.dart';

class PantallaRutinas extends StatefulWidget {
  const PantallaRutinas({Key? key}) : super(key: key);

  @override
  State<PantallaRutinas> createState() => _PantallaRutinasState();
}

class _PantallaRutinasState extends State<PantallaRutinas> {
  late Future<List<Rutina>> _rutinasFuture;

  @override
  void initState() {
    super.initState();
    _rutinasFuture = AdaptadorDeRutinasEnMemoria().obtenerRutinas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutinas de Alimento (7 días)')),
      body: FutureBuilder<List<Rutina>>(
        future: _rutinasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay rutinas disponibles.'));
          }
          final rutinas = snapshot.data!;
          return ListView.builder(
            itemCount: rutinas.length,
            itemBuilder: (context, index) {
              final rutina = rutinas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(rutina.nombre),
                  subtitle: Text(rutina.descripcion),
                  onTap: () => _mostrarDetalleRutina(context, rutina),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _mostrarDetalleRutina(BuildContext context, Rutina rutina) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(rutina.nombre),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rutina.ejercicios
                .asMap()
                .entries
                .map((entry) => Text('Día \\${entry.key + 1}: \\${entry.value}'))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
