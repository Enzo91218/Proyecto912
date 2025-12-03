# Guía: Migrar de SQLite a Firebase

## 📋 Prerrequisitos

1. Cuenta de Google (gratuita)
2. Proyecto creado en [Firebase Console](https://console.firebase.google.com/)

## 🚀 Paso 1: Crear Proyecto Firebase

1. Ve a https://console.firebase.google.com/
2. Click en "Crear Proyecto"
3. Nombre: "Proyecto912"
4. Deja los valores por defecto
5. Crea el proyecto

## 📱 Paso 2: Configurar Android

1. En Firebase Console, click en "Agregar app"
2. Selecciona Android
3. Package name: `com.example.proyecto`
4. Descarga `google-services.json`
5. Colócalo en: `android/app/google-services.json`

### Editar `android/build.gradle` (nivel de proyecto):

```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

### Editar `android/app/build.gradle` (nivel de app):

```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    // Firebase se agrega automáticamente vía pubspec.yaml
}
```

## 🍎 Paso 3: Configurar iOS

1. En Firebase Console, click en "Agregar app"
2. Selecciona iOS
3. Bundle ID: `com.example.proyecto`
4. Descarga `GoogleService-Info.plist`
5. Abre Xcode: `ios/Runner.xcworkspace`
6. Arrastra el archivo a `Runner/Runner`
7. Selecciona "Copy items if needed"

## 💻 Paso 4: Actualizar main.dart

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Resto del código...
  setupInyector();
  runApp(const MyApp());
}
```

## 🔧 Paso 5: Usar Firebase en lugar de SQLite

### Opción A: Dual (SQLite + Firebase)

Mantén ambas y sincroniza:
- Local: SQLite rápido
- Remoto: Firebase para backup y sincronización

### Opción B: Solo Firebase

Reemplaza completamente SQLite con los repositorios de Firebase.

## 📦 Estructura Firebase

```
usuarios/
├── user123/
│   ├── nombre: "Enzo"
│   ├── email: "enzo@example.com"
│   ├── edad: 25
│   ├── peso: 75
│   ├── altura: 1.75
│   └── registro_peso_altura/
│       ├── registro_id_1/
│       │   ├── peso: 75
│       │   ├── altura: 1.75
│       │   └── fecha: 2025-12-03
│       └── registro_id_2/
│           └── ...
```

## 🔐 Reglas Firestore (Seguridad)

En Firebase Console → Firestore → Reglas:

```rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /usuarios/{userId} {
      allow read, write: if request.auth.uid == userId;
      match /registro_peso_altura/{document=**} {
        allow read, write: if request.auth.uid == userId;
      }
    }
  }
}
```

## 📝 Modificar Casos de Uso

Ejemplo: `registrar_usuario.dart`

```dart
// Antes (SQLite)
void call(Usuario usuario) {
  repositorio.agregarUsuario(usuario);
}

// Después (Firebase)
Future<void> call(Usuario usuario) async {
  await repositorio.registrar(usuario);
  // Firebase Auth maneja el registro
}
```

## ✅ Checklist de Migración

- [ ] Dependencias instaladas (firebase_core, firebase_auth, cloud_firestore)
- [ ] google-services.json colocado en android/app/
- [ ] GoogleService-Info.plist agregado en iOS
- [ ] Firebase inicializado en main.dart
- [ ] Repositorios de Firebase creados
- [ ] Casos de uso adaptados para usar await/async
- [ ] Cubits actualizados para manejo de Streams
- [ ] Reglas de Firestore configuradas
- [ ] Probado en emulador/dispositivo

## 🎯 Ventajas Firebase vs SQLite

| Aspecto | SQLite | Firebase |
|--------|--------|----------|
| Sincronización | Manual | Automática |
| Backup | Manual | Automático |
| Offline | Limitado | Excelente |
| Escalabilidad | Local | Global |
| Costo | Gratis | Freemium |
| Mantenimiento | Manual | Gestionado |

## 💡 Recomendación

Para tu caso, sugiero:
1. Mantener SQLite para desarrollo local
2. Agregar Firebase para producción
3. Sincronizar ambas en tiempo real

Esto te da lo mejor de ambos mundos.
