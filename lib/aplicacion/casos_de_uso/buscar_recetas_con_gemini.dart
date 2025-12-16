import '../../dominio/entidades/receta.dart';
import '../../dominio/entidades/ingrediente.dart';
import '../../dominio/repositorios/repositorio_de_recetas.dart';
import '../../dominio/repositorios/repositorio_chat_ia.dart';

class BuscarRecetasConGemini {
  final RepositorioDeRecetas _repositorio;
  final RepositorioChatIA _chatIA;

  BuscarRecetasConGemini(this._repositorio, this._chatIA);

  Future<List<Receta>> buscar(List<Ingrediente> ingredientes) async {
    print('\n🔍 ===== BUSCAR RECETAS CON GEMINI =====');
    print('   Ingredientes: ${ingredientes.map((i) => i.nombre).join(", ")}');

    // 1. Intentar búsqueda local primero
    print('1️⃣ Intentando búsqueda local en BD...');
    final recetasLocales = await _repositorio.recetasConIngredientes(ingredientes);

    if (recetasLocales.isNotEmpty) {
      print('   ✅ Se encontraron ${recetasLocales.length} recetas en BD');
      print('===== FIN BÚSQUEDA =====\n');
      return recetasLocales;
    }

    print('   ℹ️ No se encontraron recetas locales, usando Gemini...');

    // 2. Si no hay resultados locales, usar Gemini
    print('2️⃣ Pidiendo a Gemini que busque recetas con estos ingredientes...');
    final ingredientesTexto = ingredientes.map((i) => i.nombre).join(', ');

    try {
      final prompt = '''
Por favor, sugiere 5 recetas que se pueden hacer con estos ingredientes: $ingredientesTexto

Para cada receta, proporciona la información en este formato EXACTO:
---
RECETA: [Nombre de la receta]
DESCRIPCIÓN: [Descripción corta, máximo 100 palabras]
CULTURA: [País o región de origen]
INGREDIENTES: [lista de ingredientes con cantidades aproximadas, formato: "ingrediente (cantidad)", separados por coma]
---

IMPORTANTE: Para INGREDIENTES, incluye cantidades aproximadas/realistas, por ejemplo:
- "tomate (2 medianos)"
- "cebolla (1 grande)"
- "sal (1 cucharadita)"
- "aceite (2 cucharadas)"
- "agua (500 ml)"

Proporciona exactamente 5 recetas con este formato.
      ''';

      // Crear una receta placeholder para la solicitud de búsqueda
      final recetaPlaceholder = Receta(
        id: 'busqueda_${DateTime.now().millisecondsSinceEpoch}',
        titulo: 'Búsqueda de ingredientes',
        descripcion: 'Búsqueda de recetas con Gemini',
        ingredientes: ingredientes,
        cultura: 'Internacional',
      );

      final respuestaGemini = await _chatIA.obtenerRespuesta(prompt, recetaPlaceholder);

      print('3️⃣ Parseando respuesta de Gemini...');
      final recetasGeneradas = _parsearRecetas(respuestaGemini, ingredientes);

      if (recetasGeneradas.isNotEmpty) {
        print('   ✅ Gemini generó ${recetasGeneradas.length} recetas');

        // 3. Guardar las recetas generadas en la BD
        print('4️⃣ Guardando recetas en BD...');
        for (final receta in recetasGeneradas) {
          try {
            await _repositorio.agregarReceta(receta);
            print('   ✅ Guardada: ${receta.titulo}');
          } catch (e) {
            print('   ⚠️ Error guardando ${receta.titulo}: $e');
          }
        }

        print('===== FIN BÚSQUEDA =====\n');
        return recetasGeneradas;
      } else {
        print('   ⚠️ No se pudieron parsear las recetas de Gemini');
        print('===== FIN BÚSQUEDA =====\n');
        return [];
      }
    } catch (e) {
      print('   ❌ Error usando Gemini: $e');
      print('===== FIN BÚSQUEDA =====\n');
      return [];
    }
  }

  List<Receta> _parsearRecetas(String textoGemini, List<Ingrediente> ingredientesBase) {
    print('   Parseando texto de Gemini...');
    final recetas = <Receta>[];

    // Dividir por separadores "---"
    final partes = textoGemini.split('---').where((s) => s.trim().isNotEmpty).toList();

    for (final parte in partes) {
      try {
        final lineas = parte.split('\n');
        String titulo = '';
        String descripcion = '';
        String cultura = '';
        String ingredientesTexto = '';

        for (final linea in lineas) {
          if (linea.contains('RECETA:')) {
            titulo = linea.replaceFirst(RegExp(r'RECETA:\s*'), '').trim();
          } else if (linea.contains('DESCRIPCIÓN:')) {
            descripcion = linea.replaceFirst(RegExp(r'DESCRIPCIÓN:\s*'), '').trim();
          } else if (linea.contains('CULTURA:')) {
            cultura = linea.replaceFirst(RegExp(r'CULTURA:\s*'), '').trim();
          } else if (linea.contains('INGREDIENTES:')) {
            ingredientesTexto = linea.replaceFirst(RegExp(r'INGREDIENTES:\s*'), '').trim();
          }
        }

        if (titulo.isNotEmpty && descripcion.isNotEmpty) {
          // Parsear ingredientes con cantidades
          final ingredientes = <Ingrediente>[...ingredientesBase];
          
          if (ingredientesTexto.isNotEmpty) {
            final nuevosIngredientes = ingredientesTexto
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .where((ing) {
                  // Extraer solo el nombre (lo que está antes del paréntesis)
                  final nombre = ing.replaceAll(RegExp(r'\s*\([^)]*\).*'), '').trim();
                  return !ingredientesBase.any((b) => b.nombre.toLowerCase() == nombre.toLowerCase());
                })
                .map((ing) {
                  // Extraer nombre y cantidad
                  final match = RegExp(r'([^(]+)\s*\(([^)]+)\)').firstMatch(ing);
                  
                  String nombre = ing;
                  String cantidad = 'al gusto';
                  
                  if (match != null) {
                    nombre = match.group(1)!.trim();
                    cantidad = match.group(2)!.trim();
                  } else {
                    // Si no tiene paréntesis, usar todo como nombre
                    nombre = ing.replaceAll(RegExp(r'\s*\([^)]*\).*'), '').trim();
                  }
                  
                  return Ingrediente(
                    id: nombre.toLowerCase().replaceAll(' ', '_'),
                    nombre: nombre,
                    cantidad: cantidad,
                  );
                })
                .toList();
            
            ingredientes.addAll(nuevosIngredientes);
          }

          final receta = Receta(
            id: '${titulo.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}',
            titulo: titulo,
            descripcion: descripcion,
            ingredientes: ingredientes,
            cultura: cultura.isEmpty ? 'Internacional' : cultura,
          );

          recetas.add(receta);
          print('   ✅ Parseada receta: $titulo');
        }
      } catch (e) {
        print('   ⚠️ Error parseando sección: $e');
      }
    }

    return recetas;
  }
}
