import '../../dominio/entidades/registro_peso_altura_entidad.dart';
import '../../dominio/repositorios/repositorio_de_registro_peso_altura.dart';
import '../firebase/firestore_provider.dart';

/// Implementación de RepositorioDeRegistroPesoAltura usando Firebase
class FirestorePesoAlturaRepository implements RepositorioDeRegistroPesoAltura {
  final FirestoreProvider _firestoreProvider;

  FirestorePesoAlturaRepository(this._firestoreProvider);

  @override
  void agregarRegistro(RegistroPesoAltura registro) {
    // Firebase requiere await, implementar mejor en casos de uso
    throw UnimplementedError('Usar agregarRegistroAsync() con await');
  }

  @override
  List<RegistroPesoAltura> obtenerRegistros(String usuarioId) {
    // Firebase requiere await, implementar mejor con Streams
    throw UnimplementedError('Usar obtenerRegistrosAsync() con await');
  }

  /// Agrega un registro de forma asíncrona
  Future<void> agregarRegistroAsync(RegistroPesoAltura registro) async {
    await _firestoreProvider.guardarRegistroPesoAltura(registro);
  }

  /// Obtiene registros de forma asíncrona
  Future<List<RegistroPesoAltura>> obtenerRegistrosAsync(String usuarioId) async {
    return await _firestoreProvider.obtenerRegistrosPesoAltura(usuarioId);
  }

  /// Stream en tiempo real de registros
  Stream<List<RegistroPesoAltura>> obtenerRegistrosStream(String usuarioId) {
    return _firestoreProvider.obtenerRegistrosPesoAlturaStream(usuarioId);
  }

  /// Elimina un registro
  Future<void> eliminarRegistro(String usuarioId, String registroId) async {
    await _firestoreProvider.eliminarRegistroPesoAltura(usuarioId, registroId);
  }
}
