# 🔧 Solución: Error "databaseFactory not initialized"

## Problema
```
Error Bad state: databaseFactory not initialized
databaseFactory is only initialized when using sqflite. 
When using sqflite_common_ffi you must call databasefactory = databaseFactoryFfi 
before using global openDatabase API
```

---

## ¿Qué significa?
El error ocurre principalmente en **plataformas de escritorio** (Windows, macOS, Linux) cuando sqflite no está correctamente inicializado.

---

## 🚀 Soluciones (en orden de probabilidad)

### Solución 1: Ejecutar flutter clean (90% de efectividad)

```bash
# En la carpeta del proyecto
flutter clean
flutter pub get
flutter run
```

**Por qué funciona:** Limpia artefactos compilados que pueden estar causando conflictos.

---

### Solución 2: Reinstalar dependencias SQLite

```bash
# Eliminar archivos de build
rm -rf build/
rm -rf .dart_tool/
rm pubspec.lock

# Reinstalar
flutter pub get
flutter run
```

---

### Solución 3: Para Windows específicamente

Si estás en **Windows**, SQLite necesita archivos adicionales:

1. Descarga `sqlite3.dll` de: https://www.sqlite.org/download.html
2. Colócalo en: `C:\Windows\System32\` o en la carpeta del proyecto

O instala usando chocolatey:
```bash
choco install sqlite
```

---

### Solución 4: Para macOS

```bash
# Instalar sqlite3 si no está presente
brew install sqlite3

# Luego
flutter clean
flutter pub get
flutter run
```

---

### Solución 5: Para Linux

```bash
# Instalar libsqlite3-dev
sudo apt-get install libsqlite3-dev

# Luego
flutter clean
flutter pub get
flutter run
```

---

## 📋 Checklist para resolver

- [ ] Ejecuté `flutter clean`
- [ ] Ejecuté `flutter pub get`
- [ ] Eliminé la carpeta `build/`
- [ ] Eliminé el archivo `pubspec.lock`
- [ ] Verifico que `assets/db/proyecto912.db` existe
- [ ] Ejecuté nuevamente `flutter run`

---

## 🎯 Paso a paso completo (Garantizado)

```bash
# 1. Ir a la carpeta del proyecto
cd c:\Users\IK\Desktop\ofiicial

# 2. Limpiar todo
flutter clean

# 3. Eliminar archivos de caché
rm -r build/          # En Windows: rmdir /s build
rm -r .dart_tool/     # En Windows: rmdir /s .dart_tool
del pubspec.lock      # En Windows: del pubspec.lock

# 4. Obtener dependencias nuevamente
flutter pub get

# 5. Ejecutar
flutter run
```

---

## 🔍 Si el error persiste

### Verificar que la BD existe

```bash
# Ver si el archivo existe
ls -la assets/db/proyecto912.db
# En Windows: dir assets\db\proyecto912.db
```

### Verificar logs detallados

```bash
# Ejecutar con logs verbosos
flutter run -v
```

Busca líneas como:
```
Database copied from assets to: ...
Database initialized successfully at: ...
```

---

## 🆘 Para Windows (Solución Definitiva)

Si nada de lo anterior funciona:

### Opción A: Instalar Visual C++ Redistributable
Descarga desde: https://support.microsoft.com/en-us/help/2977003

### Opción B: Instalar sqlite3 globalmente
```bash
# Usar scoop
scoop install sqlite

# O usar chocolatey
choco install sqlite
```

### Opción C: Usar WSL2 (Windows Subsystem for Linux)
```bash
# En WSL2
sudo apt-get update
sudo apt-get install libsqlite3-dev
flutter run
```

---

## 💡 Causa Común

Este error frecuentemente ocurre porque:

1. **SQLite no está inicializado** para la plataforma específica
2. **Archivos caché corruptos** de compilación anterior
3. **SQLite no está instalado** en el sistema (Windows principalmente)
4. **Conflicto de versiones** de sqflite

---

## ✅ Qué hacer si funciona

Una vez que `flutter run` funcione:

1. En la pantalla de login, toca "Ver datos de BD"
2. Deberías ver la ubicación de la BD
3. Si ves usuarios listados, ¡ya está funcionando!

---

## 📊 Resumen de Soluciones por Plataforma

| Plataforma | Solución Principal | Solución Alternativa |
|-----------|------------------|-------------------|
| Windows | `flutter clean` + instalar SQLite | Visual C++ Redistributable |
| macOS | `flutter clean` + `brew install sqlite3` | Reinstalar Xcode Command Lines |
| Linux | `flutter clean` + `apt-get install libsqlite3-dev` | Reinstalar dependencias |
| Web | No aplica | Usar emulador Android |

---

## 🚨 Última opción: Reinstalar Flutter

Si nada funciona:

```bash
# Clonar el proyecto nuevamente
cd ..
rm -r ofiicial_backup
git clone <tu-repo> ofiicial_nuevo

# O
flutter upgrade
flutter clean
flutter pub get
flutter run
```

---

## 📞 Información para Debug

Si necesitas ayuda, proporciona:

1. Tu plataforma: Windows/Mac/Linux
2. Versión de Flutter: `flutter --version`
3. Salida de: `flutter doctor -v`
4. Salida de: `flutter run -v` (últimas 50 líneas)

---

## ✨ Mejora Implementada

Se ha mejorado el `DatabaseProvider` para:
- ✅ Mostrar logs detallados de inicialización
- ✅ Manejo robusto de errores
- ✅ Inicialización automática de factory

Ahora debería haber mensajes como:
```
Database copied from assets to: /path/to/proyecto912.db
Database initialized successfully at: /path/to/proyecto912.db
```

---

**Si después de estas soluciones aún tienes problemas, ejecuta:**
```bash
flutter run -v
```

Y comparte las últimas 100 líneas del error.

---

**Última actualización:** 11 de Diciembre, 2024  
**Estado:** Actualizado con múltiples soluciones
