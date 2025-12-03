import 'package:cloud_firestore/cloud_firestore.dart';
import '../../dominio/entidades/usuario.dart';
import '../../dominio/entidades/registro_peso_altura_entidad.dart';

/// Proveedor de Firestore para almacenamiento de datos
class FirestoreProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Colecciones en Firestore
  static const String usuariosCollection = 'usuarios';
  static const String registrosPesoCollection = 'registro_peso_altura';
  static const String dietasCollection = 'dietas';
  static const String recetasCollection = 'recetas';

  // ===== Operaciones con Usuarios =====

  /// Guarda un usuario en Firestore
  Future<void> guardarUsuario(Usuario usuario) async {
    await _firestore.collection(usuariosCollection).doc(usuario.id).set({
      'nombre': usuario.nombre,
      'email': usuario.email,
      'edad': usuario.edad,
      'peso': usuario.peso,
      'altura': usuario.altura,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Obtiene un usuario por ID
  Future<Usuario?> obtenerUsuario(String usuarioId) async {
    final doc = await _firestore.collection(usuariosCollection).doc(usuarioId).get();
    
    if (!doc.exists) return null;

    final data = doc.data()!;
    return Usuario(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      email: data['email'] ?? '',
      password: '', // Firebase maneja contraseñas
      edad: data['edad'] ?? 0,
      peso: (data['peso'] ?? 0).toDouble(),
      altura: (data['altura'] ?? 0).toDouble(),
    );
  }

  /// Obtiene todos los usuarios
  Future<List<Usuario>> obtenerUsuarios() async {
    final snapshot = await _firestore.collection(usuariosCollection).get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Usuario(
        id: doc.id,
        nombre: data['nombre'] ?? '',
        email: data['email'] ?? '',
        password: '',
        edad: data['edad'] ?? 0,
        peso: (data['peso'] ?? 0).toDouble(),
        altura: (data['altura'] ?? 0).toDouble(),
      );
    }).toList();
  }

  /// Actualiza un usuario
  Future<void> actualizarUsuario(Usuario usuario) async {
    await _firestore.collection(usuariosCollection).doc(usuario.id).update({
      'nombre': usuario.nombre,
      'edad': usuario.edad,
      'peso': usuario.peso,
      'altura': usuario.altura,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ===== Operaciones con Registro Peso/Altura =====

  /// Guarda un registro de peso/altura
  Future<void> guardarRegistroPesoAltura(RegistroPesoAltura registro) async {
    await _firestore
        .collection(usuariosCollection)
        .doc(registro.usuarioId)
        .collection(registrosPesoCollection)
        .doc(registro.id)
        .set({
      'peso': registro.peso,
      'altura': registro.altura,
      'fecha': Timestamp.fromDate(registro.fecha),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Obtiene todos los registros de peso/altura de un usuario
  Future<List<RegistroPesoAltura>> obtenerRegistrosPesoAltura(String usuarioId) async {
    final snapshot = await _firestore
        .collection(usuariosCollection)
        .doc(usuarioId)
        .collection(registrosPesoCollection)
        .orderBy('fecha', descending: false)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return RegistroPesoAltura(
        id: doc.id,
        usuarioId: usuarioId,
        peso: (data['peso'] ?? 0).toDouble(),
        altura: (data['altura'] ?? 0).toDouble(),
        fecha: (data['fecha'] as Timestamp).toDate(),
      );
    }).toList();
  }

  /// Stream en tiempo real de registros de peso/altura
  Stream<List<RegistroPesoAltura>> obtenerRegistrosPesoAlturaStream(String usuarioId) {
    return _firestore
        .collection(usuariosCollection)
        .doc(usuarioId)
        .collection(registrosPesoCollection)
        .orderBy('fecha', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return RegistroPesoAltura(
          id: doc.id,
          usuarioId: usuarioId,
          peso: (data['peso'] ?? 0).toDouble(),
          altura: (data['altura'] ?? 0).toDouble(),
          fecha: (data['fecha'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  /// Elimina un registro de peso/altura
  Future<void> eliminarRegistroPesoAltura(String usuarioId, String registroId) async {
    await _firestore
        .collection(usuariosCollection)
        .doc(usuarioId)
        .collection(registrosPesoCollection)
        .doc(registroId)
        .delete();
  }
}
