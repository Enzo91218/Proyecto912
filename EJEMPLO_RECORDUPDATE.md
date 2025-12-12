# Ejemplo de Integración de recordUpdate() en Adaptadores

## Patrón General

Después de cualquier operación que modifique la base de datos, agregar:

```dart
GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
```

---

## Ejemplo Completo: registros_peso_altura_sqlite_adaptador.dart

```dart
import 'package:sqflite/sqflite.dart';
import 'package:get_it/get_it.dart';

import '../../dominio/entidades/registro_peso_altura.dart';
import '../../dominio/repositorios/repositorio_de_registro_peso_altura.dart';
import '../../servicios/database_update_service.dart';
import 'database_provider.dart';

class RepositorioDeRegistroPesoAlturaSqlite implements RepositorioDeRegistroPesoAltura {
  final DatabaseProvider _provider;

  RepositorioDeRegistroPesoAlturaSqlite(this._provider);

  @override
  Future<List<RegistroPesoAltura>> obtenerRegistros(String usuarioId) async {
    final db = await _provider.database;
    final data = await db.query(
      'registros_peso_altura',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      orderBy: 'fecha DESC',
    );
    return data
        .map((row) => RegistroPesoAltura(
          id: row['id'] as String,
          usuarioId: row['usuario_id'] as String,
          peso: (row['peso'] as num).toDouble(),
          altura: (row['altura'] as num).toDouble(),
          fecha: DateTime.parse(row['fecha'] as String),
        ))
        .toList();
  }

  @override
  Future<void> agregarRegistro(RegistroPesoAltura registro) async {
    final db = await _provider.database;
    await db.insert(
      'registros_peso_altura',
      {
        'id': registro.id,
        'usuario_id': registro.usuarioId,
        'peso': registro.peso,
        'altura': registro.altura,
        'fecha': registro.fecha.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    // 👇 AGREGAR ESTA LÍNEA
    GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
  }

  @override
  Future<void> actualizarRegistro(RegistroPesoAltura registro) async {
    final db = await _provider.database;
    await db.update(
      'registros_peso_altura',
      {
        'id': registro.id,
        'usuario_id': registro.usuarioId,
        'peso': registro.peso,
        'altura': registro.altura,
        'fecha': registro.fecha.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [registro.id],
    );
    
    // 👇 AGREGAR ESTA LÍNEA
    GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
  }

  @override
  Future<void> eliminarRegistro(String registroId) async {
    final db = await _provider.database;
    await db.delete(
      'registros_peso_altura',
      where: 'id = ?',
      whereArgs: [registroId],
    );
    
    // 👇 AGREGAR ESTA LÍNEA
    GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
  }
}
```

---

## Ejemplo 2: usuarios_sqlite_adaptador.dart

```dart
import 'package:sqflite/sqflite.dart';
import 'package:get_it/get_it.dart';

import '../../dominio/entidades/usuario.dart';
import '../../dominio/repositorios/repositorio_de_usuario.dart';
import '../../servicios/database_update_service.dart';
import 'database_provider.dart';

class RepositorioDeUsuarioSqlite implements RepositorioDeUsuario {
  final DatabaseProvider _provider;

  RepositorioDeUsuarioSqlite(this._provider);

  @override
  Future<List<Usuario>> obtenerUsuarios() async {
    final db = await _provider.database;
    final data = await db.query('usuarios');
    return data
        .map((row) => Usuario(
          id: row['id'] as String,
          nombre: row['nombre'] as String,
          email: row['email'] as String,
          password: row['password'] as String,
          edad: row['edad'] as int,
          peso: (row['peso'] as num).toDouble(),
          altura: (row['altura'] as num).toDouble(),
        ))
        .toList();
  }

  @override
  Future<void> agregarUsuario(Usuario usuario) async {
    final db = await _provider.database;
    await db.insert(
      'usuarios',
      {
        'id': usuario.id,
        'nombre': usuario.nombre,
        'email': usuario.email,
        'password': usuario.password,
        'edad': usuario.edad,
        'peso': usuario.peso,
        'altura': usuario.altura,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    // 👇 AGREGAR ESTA LÍNEA
    GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
  }

  @override
  Future<void> actualizarUsuario(Usuario usuario) async {
    final db = await _provider.database;
    await db.update(
      'usuarios',
      {
        'id': usuario.id,
        'nombre': usuario.nombre,
        'email': usuario.email,
        'password': usuario.password,
        'edad': usuario.edad,
        'peso': usuario.peso,
        'altura': usuario.altura,
      },
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
    
    // 👇 AGREGAR ESTA LÍNEA
    GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
  }
}
```

---

## Ejemplo 3: recetas_sqlite_adaptador.dart

```dart
import 'package:sqflite/sqflite.dart';
import 'package:get_it/get_it.dart';

import '../../dominio/entidades/receta.dart';
import '../../dominio/repositorios/repositorio_de_recetas.dart';
import '../../servicios/database_update_service.dart';
import 'database_provider.dart';

class RepositorioDeRecetasSqlite implements RepositorioDeRecetas {
  final DatabaseProvider _provider;

  RepositorioDeRecetasSqlite(this._provider);

  // ... métodos existentes ...

  @override
  Future<void> agregarReceta(Receta receta) async {
    final db = await _provider.database;
    
    await db.insert(
      'recetas',
      {
        'id': receta.id,
        'titulo': receta.titulo,
        'descripcion': receta.descripcion,
        'cultura': receta.cultura,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insertar ingredientes si existen
    if (receta.ingredientes.isNotEmpty) {
      for (var ingrediente in receta.ingredientes) {
        await db.insert(
          'ingredientes',
          {
            'id': ingrediente.id,
            'nombre': ingrediente.nombre,
            'cantidad': ingrediente.cantidad,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        await db.insert(
          'receta_ingredientes',
          {
            'receta_id': receta.id,
            'ingrediente_id': ingrediente.id,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }

    // 👇 AGREGAR ESTA LÍNEA (UNA SOLA VEZ, AL FINAL)
    GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
  }

  @override
  Future<void> actualizarReceta(Receta receta) async {
    final db = await _provider.database;
    
    await db.update(
      'recetas',
      {
        'titulo': receta.titulo,
        'descripcion': receta.descripcion,
        'cultura': receta.cultura,
      },
      where: 'id = ?',
      whereArgs: [receta.id],
    );

    // Actualizar ingredientes si necesario
    // ... código de actualización ...

    // 👇 AGREGAR ESTA LÍNEA
    GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
  }

  @override
  Future<void> eliminarReceta(String recetaId) async {
    final db = await _provider.database;
    
    // Eliminar relaciones
    await db.delete(
      'receta_ingredientes',
      where: 'receta_id = ?',
      whereArgs: [recetaId],
    );

    // Eliminar receta
    await db.delete(
      'recetas',
      where: 'id = ?',
      whereArgs: [recetaId],
    );

    // 👇 AGREGAR ESTA LÍNEA
    GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
  }
}
```

---

## 📋 Checklist de Implementación

Para cada adaptador, agregar `recordUpdate()` después de:

### ✅ usuarios_sqlite_adaptador.dart
- [ ] `agregarUsuario()`
- [ ] `actualizarUsuario()`

### ✅ recetas_sqlite_adaptador.dart
- [ ] `agregarReceta()`
- [ ] `actualizarReceta()`
- [ ] `eliminarReceta()`

### ✅ registros_peso_altura_sqlite_adaptador.dart
- [ ] `agregarRegistro()`
- [ ] `actualizarRegistro()`
- [ ] `eliminarRegistro()`

### ✅ registros_imc_sqlite_adaptador.dart
- [ ] `agregarRegistro()`
- [ ] `actualizarRegistro()`
- [ ] `eliminarRegistro()`

### ✅ dietas_sqlite_adaptador.dart
- [ ] `agregarDieta()`
- [ ] `actualizarDieta()`
- [ ] `eliminarDieta()`

---

## 🔍 Verificación

Después de agregar `recordUpdate()`:

1. Abre la app y ve a Herramientas
2. Verifica que muestra "Última Actualización: Hace menos de un minuto"
3. Registra un usuario o peso
4. Vuelve a Herramientas
5. La fecha debe actualizarse

Si vuelves inmediatamente, verás "Hace 30 segundos", "Hace 45 segundos", etc.

---

## ⚠️ Notas Importantes

- Agregar `recordUpdate()` **UNA SOLA VEZ** al final del método
- No es necesario en métodos de lectura (like `obtenerUsuarios()`)
- El import debe ser: `import '../../servicios/database_update_service.dart';`
- GetIt ya está disponible porque se registró en `main.dart`
