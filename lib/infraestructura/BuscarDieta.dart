import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PantallaDietas extends StatefulWidget {
  const PantallaDietas({super.key});

  @override
  State<PantallaDietas> createState() => _PantallaDietasState();
}

class _PantallaDietasState extends State<PantallaDietas> {
  final TextEditingController _controller = TextEditingController();
  String resultado = "";

  void _buscarDieta() {
    setState(() {
      resultado = "Mostrando dietas para: ${_controller.text}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar Dieta")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Tipo de dieta (ej. keto, vegana, etc.)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarDieta,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              resultado,
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Volver al Menú"),
                  onPressed: () => context.go('/'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.monitor_weight),
                  label: const Text("Calcular IMC"),
                  onPressed: () => context.go('/imc'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
