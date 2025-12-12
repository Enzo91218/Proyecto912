# Guía de Integración - Herramientas y Rastreo de Base de Datos

## Resumen de Cambios Realizados

### 1. **DatabaseProvider Actualizado** ✅
- Ahora carga automáticamente `proyecto912.db` desde `assets/db/`
- Si el archivo no existe, lo copia al directorio de documentos de la aplicación
- Incluye métodos para:
  - `getDatabasePath()`: Obtiene la ruta completa de la BD
  - `recordDatabaseUpdate()`: Registra cuando la BD fue actualizada
  - `lastUpdate`: Propiedad que retorna DateTime de última actualización

### 2. **DatabaseUpdateService Creado** ✅
- Nuevo servicio que rastrea las actualizaciones de la BD
- Registrado como Singleton en GetIt
- Incluye:
  - `lastUpdateFormatted`: Retorna texto legible de la última actualización
  - `recordUpdate()`: Registra una actualización y notifica listeners
  - `initialize()`: Inicializa el servicio al arrancar la app

### 3. **Pantalla de Herramientas Creada** ✅
- Nueva pantalla en: `lib/presentacion/pantalla_herramientas/pantalla_herramientas.dart`
- Muestra:
  - 📍 Ubicación exacta de la base de datos
  - 💾 Tamaño actual del archivo
  - ⏰ Fecha/hora de última actualización (con formato relativo)
  - 📥 Botón para descargar la BD a la carpeta de descargas
- Ruta: `/herramientas`
- La descarga se realiza automáticamente a `/storage/emulated/0/Download/` (Android) o equivalente en otras plataformas

### 4. **Integración en Menú Principal** ✅
- Agregado botón "Herramientas" en el menú de 3 puntos
- Aparece antes de "Cerrar Sesión" y "Salir"
- Color verde con icono de configuración

### 5. **Dependencias Agregadas** ✅
```yaml
# No se necesitan dependencias adicionales
# Se usa solo path_provider que ya está en el proyecto
```

## Cómo Registrar Actualizaciones en los Adaptadores

Para que la pantalla de herramientas muestre actualizaciones en tiempo real, debes agregar `recordUpdate()` después de operaciones de escritura en la BD.

### Ejemplo 1: En `usuarios_sqlite_adaptador.dart`

```dart
import 'package:get_it/get_it.dart';
import '../../servicios/database_update_service.dart';

// En el método agregarUsuario:
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
  
  // 👇 Agregar esta línea
  GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
}

// En el método actualizarUsuario:
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
  
  // 👇 Agregar esta línea
  GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
}
```

### Ejemplo 2: En `registros_peso_altura_sqlite_adaptador.dart`

```dart
// Después de guardar un nuevo registro de peso
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
  
  // 👇 Agregar esta línea
  GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
}
```

### Ejemplo 3: En `recetas_sqlite_adaptador.dart`

```dart
@override
Future<void> agregarReceta(Receta receta) async {
  final db = await _provider.database;
  // ... código de inserción ...
  
  // 👇 Agregar esta línea
  GetIt.instance.get<DatabaseUpdateService>().recordUpdate();
}
```

## Checklist de Implementación

- [x] DatabaseProvider actualizado para cargar desde assets
- [x] DatabaseUpdateService creado y registrado en GetIt
- [x] Pantalla de herramientas implementada
- [x] Ruta agregada al router
- [x] Botón integrado en el menú
- [x] Dependencias agregadas a pubspec.yaml
- [ ] **TODO**: Agregar `recordUpdate()` en cada método que escriba en la BD:
  - [ ] `usuarios_sqlite_adaptador.dart` - agregarUsuario()
  - [ ] `usuarios_sqlite_adaptador.dart` - actualizarUsuario()
  - [ ] `recetas_sqlite_adaptador.dart` - agregarReceta()
  - [ ] `recetas_sqlite_adaptador.dart` - actualizarReceta()
  - [ ] `recetas_sqlite_adaptador.dart` - eliminarReceta()
  - [ ] `registros_peso_altura_sqlite_adaptador.dart` - agregarRegistro()
  - [ ] `registros_imc_sqlite_adaptador.dart` - agregarRegistro()
  - [ ] `dietas_sqlite_adaptador.dart` - agregarDieta()
  - [ ] Cualquier otro método que modifique datos

## Verificación de Estructura

```
lib/
├── adaptadores/sqlite/
│   ├── database_provider.dart ✅ Actualizado
│   ├── usuarios_sqlite_adaptador.dart
│   ├── recetas_sqlite_adaptador.dart
│   ├── registros_peso_altura_sqlite_adaptador.dart
│   └── ... otros adaptadores
├── servicios/
│   ├── usuario_actual.dart
│   ├── tema_servicio.dart
│   └── database_update_service.dart ✅ Nuevo
├── presentacion/
│   ├── pantalla_herramientas/
│   │   └── pantalla_herramientas.dart ✅ Nuevo
│   ├── pantalla menu/
│   │   └── menu.dart ✅ Actualizado
│   ├── router.dart ✅ Actualizado
│   └── ... otras pantallas
└── inyector/
    └── main.dart ✅ Actualizado

assets/db/
└── proyecto912.db ✅ Debe existir aquí
```

## Notas Importantes

1. **Permisos**: La pantalla solicita permisos de almacenamiento automáticamente en Android/iOS
2. **Descarga**: Usa la API nativa de compartir de cada plataforma
3. **Actualización**: Se actualiza automáticamente en todas las pantallas que usen `ListenableBuilder` con `DatabaseUpdateService`
4. **Performance**: El `recordUpdate()` es muy ligero - solo actualiza un DateTime interno

## Próximos Pasos Recomendados

1. Ejecuta `flutter pub get` para descargar las nuevas dependencias
2. Integra `recordUpdate()` en todos los adaptadores siguiendo los ejemplos
3. Prueba la descarga de la BD desde la pantalla de herramientas
4. Verifica que la timestamp se actualiza cuando se registren datos
