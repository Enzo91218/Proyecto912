import 'package:firebase_auth/firebase_auth.dart';
import '../../dominio/entidades/usuario.dart';

/// Proveedor de autenticación con Firebase
class FirebaseAuthProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Registra un nuevo usuario
  Future<Usuario> registrarse(String email, String password, String nombre, int edad, double peso, double altura) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final usuario = Usuario(
        id: userCredential.user!.uid,
        nombre: nombre,
        email: email,
        password: password, // En producción, NO guardes la contraseña
        edad: edad,
        peso: peso,
        altura: altura,
      );

      return usuario;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('La contraseña es muy débil');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('El email ya está registrado');
      } else {
        throw Exception('Error en registro: ${e.message}');
      }
    }
  }

  /// Inicia sesión
  Future<Usuario> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Aquí deberías obtener los datos adicionales de Firestore
      final usuario = Usuario(
        id: userCredential.user!.uid,
        nombre: userCredential.user!.displayName ?? '',
        email: email,
        password: password,
        edad: 0,
        peso: 0,
        altura: 0,
      );

      return usuario;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Usuario no encontrado');
      } else if (e.code == 'wrong-password') {
        throw Exception('Contraseña incorrecta');
      } else {
        throw Exception('Error en login: ${e.message}');
      }
    }
  }

  /// Cierra sesión
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  /// Obtiene el usuario actual
  User? obtenerUsuarioActual() {
    return _firebaseAuth.currentUser;
  }

  /// Stream de cambios de autenticación
  Stream<User?> obtenerStreamAutenticacion() {
    return _firebaseAuth.authStateChanges();
  }
}
