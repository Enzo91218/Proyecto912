import '../entidades/ingrediente.dart';

abstract class RepositorioDeIngredientes {
  Future<List<Ingrediente>> obtenerIngredientes();
}
