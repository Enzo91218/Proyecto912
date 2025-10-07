import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

class PantallaIMC extends StatefulWidget {
  const PantallaIMC({super.key});

  @override
  State<PantallaIMC> createState() => _PantallaIMCState();
}

class _PantallaIMCState extends State<PantallaIMC> {
  final pesoCtrl = TextEditingController();
  final alturaCtrl = TextEditingController();
  String resultado = "";

  void _calcularIMC() {
    final peso = double.tryParse(pesoCtrl.text);
    final altura = double.tryParse(alturaCtrl.text);

    if (peso == null || altura == null || altura <= 0) {
      setState(() {
        resultado = "Por favor, ingrese valores válidos.";
      });
      return;
    }

    final imc = peso / pow(altura / 100, 2);

    String estado;
    if (imc < 18.5) {
      estado = "Bajo peso";
    } else if (imc < 25) {
      estado = "Normal";
    } else if (imc < 30) {
      estado = "Sobrepeso";
    } else {
      estado = "Obesidad";
    }

    setState(() {
      resultado = "IMC: ${imc.toStringAsFixed(2)} ($estado)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calcular IMC")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: pesoCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Peso (kg)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: alturaCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Altura (cm)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.calculate),
              label: const Text("Calcular"),
              onPressed: _calcularIMC,
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
                  icon: const Icon(Icons.search),
                  label: const Text("Buscar Dieta"),
                  onPressed: () => context.go('/dietas'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
