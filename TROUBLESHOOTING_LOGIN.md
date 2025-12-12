# 🔍 Troubleshooting - Error de Login

## Problema
**"No me deja ingresar con el email y contraseña"**

---

## Posibles Causas

### 1. **La base de datos está vacía** ⚠️ (Más común)
Si no hay usuarios registrados en la BD, el login fallará porque no hay credenciales para validar.

**Solución:**
1. Abre la app
2. En la pantalla de login, toca el botón **"Ver datos de BD"** (abajo)
3. Verifica si hay usuarios en la lista
4. Si está vacía, ve a "No tienes cuenta? Registrarse" y crea una cuenta

### 2. **Credenciales incorrectas**
Email o contraseña no coinciden exactamente con lo que está registrado en la BD.

**Solución:**
1. Ve a la pantalla de debug ("Ver datos de BD")
2. Revisa el email y password exactos de los usuarios registrados
3. Asegúrate de escribir el email en minúsculas
4. Verifica que la contraseña sea exacta (incluyendo mayúsculas/minúsculas)

### 3. **La BD no se está cargando desde assets**
Si `proyecto912.db` no existe en `assets/db/` o no está en `pubspec.yaml`.

**Solución:**
1. Verifica que exista: `assets/db/proyecto912.db`
2. En `pubspec.yaml`, asegúrate que está listado:
   ```yaml
   assets:
     - assets/db/proyecto912.db
   ```
3. Ejecuta: `flutter clean && flutter pub get && flutter run`

### 4. **Problema con la base de datos**
Error al acceder o leer datos de la BD.

**Solución:**
1. Ve a "Ver datos de BD" (debug)
2. Si ves un error rojo, consulta el mensaje
3. Intenta limpiar e reinstalar:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

---

## 🛠️ Cómo Debuggear

### Paso 1: Abrir Pantalla de Debug
1. En la pantalla de login
2. Toca "Ver datos de BD" (botón gris abajo)

### Paso 2: Revisar Información
Verás:
- **Ubicación de BD**: Dónde está almacenada
- **Estadísticas**: Cuántos usuarios, recetas, dietas hay
- **Lista de Usuarios**: Todos los usuarios registrados con sus datos

### Paso 3: Verificar Credenciales
Si hay usuarios:
1. Anota exactamente el email y password
2. Vuelve al login
3. Ingresa el email y password tal cual aparecen en la lista

---

## 📋 Checklist de Solución

- [ ] Abrí "Ver datos de BD"
- [ ] Verifico que hay usuarios en la lista
- [ ] Anoto el email y password de un usuario
- [ ] Vuelvo al login
- [ ] Ingreso exactamente el email y password
- [ ] Si aparece error, anoto el mensaje exacto
- [ ] Si sigue sin funcionar, ejecuto:
  ```bash
  flutter clean
  flutter pub get
  flutter run
  ```

---

## ⚠️ Errores Comunes y Soluciones

### Error: "No hay usuarios registrados"
```
Causa: La BD está vacía
Solución: Regístrate primero en la pantalla de registro
```

### Error: "Email o contraseña incorrectos"
```
Causa: Las credenciales no coinciden
Solución: Ve a debug, copia el email/password exacto de la BD y prueba
```

### Error: "No se pudo acceder a la BD"
```
Causa: Problema al cargar proyecto912.db
Solución: 
1. Verifica que assets/db/proyecto912.db existe
2. Verifica que está en pubspec.yaml
3. Ejecuta: flutter clean && flutter run
```

### Error: "No se encontró la tabla usuarios"
```
Causa: La BD no se inicializó correctamente
Solución:
1. Elimina la app
2. Ejecuta: flutter clean
3. Vuelve a compilar: flutter run
```

---

## 🔐 Información Importante sobre Seguridad

⚠️ **NO GUARDES CONTRASEÑAS EN TEXTO PLANO EN PRODUCCIÓN**

Actualmente la app guarda contraseñas sin encriptar. Para una aplicación real:

1. Encripta las contraseñas antes de guardar
2. Usa hashing seguro (bcrypt, argon2, etc)
3. No compares contraseñas directamente
4. Implementa rate limiting en intentos de login
5. Usa HTTPS para toda comunicación

---

## 📊 Explicación del Flujo de Login

```
1. Usuario ingresa email y password
   ↓
2. LoginCubit.login() se ejecuta
   ↓
3. BuscarUsuarios obtiene TODOS los usuarios de la BD
   ↓
4. Se busca el usuario que coincida:
   - email (case-insensitive)
   - password (case-sensitive)
   ↓
5. Si encuentra:
   - Guarda usuario en UsuarioActual
   - Navega a menú principal
   ↓
6. Si NO encuentra:
   - Muestra error "Email o contraseña incorrectos"
```

---

## 🎯 Pasos Rápidos para Solucionar

### Si es la primera vez usando la app:
```
1. Abre app → Login
2. Toca "Ver datos de BD"
3. Toca "No tienes cuenta? Registrarse"
4. Completa formulario y registrate
5. Vuelve a login
6. Ingresa con tus credenciales nuevas
```

### Si ya tenías datos registrados:
```
1. Abre app → Login
2. Toca "Ver datos de BD"
3. Copia exactamente email y password de un usuario
4. Vuelve al login
5. Pega el email y password
6. Si no funciona, ejecuta: flutter clean && flutter run
```

---

## 📞 Si Aún No Funciona

Por favor proporciona:
1. Screenshot de la pantalla de debug
2. El mensaje de error exacto
3. El email y password que intentaste usar
4. Si ya hay usuarios en la BD o está vacía

Información a verificar:
- [ ] ¿Existe `assets/db/proyecto912.db`?
- [ ] ¿Está listado en `pubspec.yaml`?
- [ ] ¿Hay usuarios en la pantalla de debug?
- [ ] ¿Cuál es el error exacto que aparece?

---

## 📚 Archivos Relacionados

- `lib/presentacion/pantalla login/Login.dart` - Pantalla de login
- `lib/presentacion/cubit/login_cubit.dart` - Lógica de login
- `lib/aplicacion/casos_de_uso/buscar_usuarios.dart` - Búsqueda de usuarios
- `lib/adaptadores/sqlite/usuarios_sqlite_adaptador.dart` - Acceso a BD
- `lib/presentacion/pantalla_debug_bd/pantalla_debug_bd.dart` - Debug

---

**Última actualización:** 11 de Diciembre, 2024  
**Versión:** 1.0.0
