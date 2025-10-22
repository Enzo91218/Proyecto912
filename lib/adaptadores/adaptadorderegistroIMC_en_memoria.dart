import '../dominio/entidades/resultado_imc.dart';
import '../dominio/repositorios/repositorio_de_registroIMC.dart';

class RepositorioDeRegistroIMCA implements RepositorioDeRegistroIMC {
  @override
  List<ResultadoIMC> obtenerRegistrosIMC() {
    // aca empiezan los ejemplos
    return [
      ResultadoIMC(imc: 16.8, categoria: 'Bajo peso'),
      ResultadoIMC(imc: 22.5, categoria: 'Normal'),
      ResultadoIMC(imc: 25.0, categoria: 'Sobrepeso'),
      ResultadoIMC(imc: 31.2, categoria: 'Obesidad'),
    ];
  }
}
