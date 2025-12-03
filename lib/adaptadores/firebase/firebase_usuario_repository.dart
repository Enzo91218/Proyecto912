import 'package:firebase_auth/firebase_auth.dart';
import '../../dominio/entidades/usuario.dart';
import '../../dominio/repositorios/repositorio_de_usuario.dart';
import '../firebase/firebase_auth_provider.dart';

/// Implementación de RepositorioDeUsuario usando Firebase
class FirebaseUsuarioRepository implements RepositorioDeUsuario {
  final FirebaseAuthProvider _authProvider;

  FirebaseUsuarioRepository(this._authProvider);

  @override
  void agregarUsuario(Usuario usuario) {
    // Firebase maneja esto en el registro de autenticación
    // Los datos adicionales se guardan en Firestore (ver FirestoreUsuarioRepository)
  }

  @override
  List<Usuario> obtenerUsuarios() {
    // En Firebase, esto requeriría una llamada asíncrona
    // Se implementaría mejor con Streams
    throw UnimplementedError('Usar obtenerUsuariosStream() en su lugar');
  }

  @override
  void actualizarUsuario(Usuario usuario) {
    // Implementaría actualización en Firestore
    throw UnimplementedError('Usar updateUser() con await');
  }

  /// Registra un nuevo usuario en Firebase
  Future<Usuario> registrar(String email, String password, String nombre, int edad, double peso, double altura) async {
    return await _authProvider.registrarse(email, password, nombre, edad, peso, altura);
  }

  /// Inicia sesión
  Future<Usuario> login(String email, String password) async {
    return await _authProvider.login(email, password);
  }

  /// Cierra sesión
  Future<void> logout() async {
    await _authProvider.logout();
  }

  /// Obtiene el usuario actual autenticado
  User? obtenerUsuarioActual() {
    return _authProvider.obtenerUsuarioActual();
  }

  /// Stream de autenticación
  Stream<User?> obtenerStreamAutenticacion() {
    return _authProvider.obtenerStreamAutenticacion();
  }
}
