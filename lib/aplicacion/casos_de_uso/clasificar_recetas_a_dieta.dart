import '../../dominio/entidades/receta.dart';
import '../../dominio/entidades/dieta.dart';
import '../../dominio/repositorios/repositorio_chat_ia.dart';

class ClasificarRecetasADieta {
  final RepositorioChatIA _chatIA;

  ClasificarRecetasADieta(this._chatIA);

  /// Clasifica una receta a una dieta usando Gemini
  Future<String?> clasificarReceta(Receta receta, List<Dieta> dietasDisponibles) async {
    try {
      print('\n🔍 Clasificando receta: ${receta.titulo}');
      
      final dietasNombres = dietasDisponibles.map((d) => d.nombre).join(', ');
      
      final prompt = '''
Analiza la siguiente receta y determina a cuál de estas dietas pertenece mejor:

RECETA: ${receta.titulo}
DESCRIPCIÓN: ${receta.descripcion}
INGREDIENTES: ${receta.ingredientes.map((i) => i.nombre).join(', ')}
CULTURA: ${receta.cultura}

DIETAS DISPONIBLES: $dietasNombres

Responde SOLO con el nombre exacto de UNA de las dietas disponibles, sin explicación ni puntuación.
Si ninguna dieta encaja perfectamente, elige la más cercana.
Respuesta:
      ''';

      final respuesta = await _chatIA.obtenerRespuesta(prompt, receta);
      final dietaClasificada = respuesta.trim();
      
      // Validar que la respuesta sea una dieta válida
      final dietaValida = dietasDisponibles.firstWhere(
        (d) => d.nombre.toLowerCase() == dietaClasificada.toLowerCase(),
        orElse: () => dietasDisponibles.first,
      );
      
      print('   ✅ Clasificada a: ${dietaValida.nombre}');
      return dietaValida.nombre;
    } catch (e) {
      print('   ❌ Error clasificando receta: $e');
      return null;
    }
  }

  /// Clasifica múltiples recetas a dietas
  Future<Map<Receta, String>> clasificarMultiplesRecetas(
    List<Receta> recetas,
    List<Dieta> dietasDisponibles,
  ) async {
    print('\n🔍 ===== CLASIFICANDO ${recetas.length} RECETAS A DIETAS =====');
    
    final resultado = <Receta, String>{};
    
    for (final receta in recetas) {
      try {
        final dietaClasificada = await clasificarReceta(receta, dietasDisponibles);
        if (dietaClasificada != null) {
          resultado[receta] = dietaClasificada;
        }
      } catch (e) {
        print('   ⚠️ Error con ${receta.titulo}: $e');
      }
    }
    
    print('===== CLASIFICACIÓN COMPLETADA =====\n');
    return resultado;
  }
}
