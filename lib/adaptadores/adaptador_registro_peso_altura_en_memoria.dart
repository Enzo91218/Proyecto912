import '../dominio/entidades/registro_peso_altura_entidad.dart';
import '../dominio/repositorios/repositorio_de_registro_peso_altura.dart';

class RepositorioDeRegistroPesoAlturaA implements RepositorioDeRegistroPesoAltura {
  final List<RegistroPesoAltura> _registros = [
    // Registros del usuario 1 (Juan) - mostrando progreso a lo largo del tiempo
    RegistroPesoAltura(
      id: 'reg_1',
      usuarioId: '1',
      peso: 85.0,
      altura: 1.75,
      fecha: DateTime(2025, 10, 1, 8, 30),
    ),
    RegistroPesoAltura(
      id: 'reg_2',
      usuarioId: '1',
      peso: 83.5,
      altura: 1.75,
      fecha: DateTime(2025, 10, 8, 8, 30),
    ),
    RegistroPesoAltura(
      id: 'reg_3',
      usuarioId: '1',
      peso: 81.0,
      altura: 1.75,
      fecha: DateTime(2025, 10, 15, 8, 30),
    ),
    RegistroPesoAltura(
      id: 'reg_4',
      usuarioId: '1',
      peso: 79.5,
      altura: 1.75,
      fecha: DateTime(2025, 10, 22, 8, 30),
    ),
    RegistroPesoAltura(
      id: 'reg_5',
      usuarioId: '1',
      peso: 78.0,
      altura: 1.75,
      fecha: DateTime(2025, 10, 29, 8, 30),
    ),
    RegistroPesoAltura(
      id: 'reg_6',
      usuarioId: '1',
      peso: 76.5,
      altura: 1.75,
      fecha: DateTime(2025, 11, 5, 8, 30),
    ),
    RegistroPesoAltura(
      id: 'reg_7',
      usuarioId: '1',
      peso: 75.0,
      altura: 1.75,
      fecha: DateTime(2025, 11, 12, 8, 30),
    ),
    RegistroPesoAltura(
      id: 'reg_8',
      usuarioId: '1',
      peso: 75.2,
      altura: 1.75,
      fecha: DateTime(2025, 11, 19, 8, 30),
    ),
    RegistroPesoAltura(
      id: 'reg_9',
      usuarioId: '1',
      peso: 74.8,
      altura: 1.75,
      fecha: DateTime(2025, 11, 26, 8, 30),
    ),
    RegistroPesoAltura(
      id: 'reg_10',
      usuarioId: '1',
      peso: 75.0,
      altura: 1.75,
      fecha: DateTime(2025, 12, 2, 8, 30),
    ),
    
    // Registros del usuario 2 (Ana)
    RegistroPesoAltura(
      id: 'reg_11',
      usuarioId: '2',
      peso: 65.0,
      altura: 1.65,
      fecha: DateTime(2025, 11, 1, 9, 0),
    ),
    RegistroPesoAltura(
      id: 'reg_12',
      usuarioId: '2',
      peso: 63.5,
      altura: 1.65,
      fecha: DateTime(2025, 11, 15, 9, 0),
    ),
    RegistroPesoAltura(
      id: 'reg_13',
      usuarioId: '2',
      peso: 62.0,
      altura: 1.65,
      fecha: DateTime(2025, 12, 2, 9, 0),
    ),
  ];

  @override
  Future<List<RegistroPesoAltura>> obtenerRegistros(String usuarioId) async {
    return _registros
        .where((registro) => registro.usuarioId == usuarioId)
        .toList();
  }

  @override
  Future<void> agregarRegistro(RegistroPesoAltura registro) async {
    _registros.add(registro);
  }
}
