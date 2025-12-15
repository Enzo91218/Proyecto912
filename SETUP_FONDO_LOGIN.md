# Guía: Agregar Fondo a la Pantalla de Login

## 📁 Estructura de Carpetas Creadas

```
assets/
├── db/
│   └── proyecto912.db
├── images/          ← Aquí van las imágenes
│   └── README.md
└── videos/          ← Aquí irían los videos (opcional)
    └── README.md
```

## 🖼️ FONDO DE LOGIN - Imagen Estática

### Ubicación del Archivo
**Coloca tu imagen aquí:**
```
c:\Users\IK\Desktop\ofiicial\assets\images\login_background.jpg
```

### Especificaciones Recomendadas
- **Nombre:** `login_background.jpg` (o `.png`)
- **Dimensiones:** 1080 x 1920px mínimo (mejor: 1440 x 2560px)
- **Tamaño:** < 500KB (optimizado)
- **Formato:** JPG (mejor) o PNG (si necesitas transparencia)

### Cómo Agregar la Imagen
1. Abre tu explorador de archivos
2. Navega a: `C:\Users\IK\Desktop\ofiicial\assets\images\`
3. Copia tu imagen aquí
4. Asegúrate de que se llame exactamente: `login_background.jpg`
5. Guarda el proyecto en Flutter (presiona `r` en terminal)

### Si Cambias el Nombre del Archivo
Ve a `lib/presentacion/pantalla login/Login.dart` y busca esta línea (aproximadamente línea 26):
```dart
image: AssetImage('assets/images/login_background.jpg'),
```

Cámbiala a tu nombre, por ejemplo:
```dart
image: AssetImage('assets/images/mi_fondo.png'),
```

## 🎨 Diseño Actual de Login

La pantalla de login ahora tiene:
- ✅ Imagen de fondo a pantalla completa
- ✅ Contenedor semi-transparente (oscuro) para mejor legibilidad
- ✅ Bordes redondeados en el formulario
- ✅ Campos de texto con estilos mejorados (fondo semi-transparente, bordes azules)
- ✅ Colores blancos para texto (visible sobre fondo oscuro)

## 🎬 Videos (Opcional)

Si en el futuro quieres agregar un video de fondo:
1. Primero instala la dependencia en `pubspec.yaml`:
   ```yaml
   dependencies:
     video_player: ^2.8.0
   ```
2. Coloca el video en: `assets/videos/`
3. Contacta para implementar la reproducción

## ✅ Checklist de Implementación

- [x] Carpetas `assets/images` y `assets/videos` creadas
- [x] `pubspec.yaml` actualizado para incluir assets
- [x] Pantalla de login modificada para mostrar imagen de fondo
- [x] Contenedor semi-transparente agregado para legibilidad
- [x] Campos de texto estilizados para funcionar con fondo oscuro
- [ ] Imagen `login_background.jpg` colocada en la carpeta (TÚ DEBES HACER ESTO)

## 📝 Próximos Pasos

1. **Obtén una imagen** de fondo para login (puedes usar sitios como Unsplash, Pexels, etc.)
2. **Optimiza la imagen** (redimensiona a 1440x2560px, comprime a < 500KB)
3. **Coloca la imagen** en `C:\Users\IK\Desktop\ofiicial\assets\images\login_background.jpg`
4. **Guarda el proyecto** (Ctrl+S en el editor)
5. **Recarga la app** (presiona `r` en la terminal de Flutter)

¡Listo! Tu pantalla de login tendrá un fondo hermoso.

## 🔧 Solución de Problemas

### La imagen no aparece
- Verifica que el nombre sea exactamente `login_background.jpg`
- Asegúrate de que esté en la carpeta correcta: `assets/images/`
- Ejecuta `flutter pub get` en la terminal
- Recarga la app (presiona `r`)

### La imagen se ve borrosa
- Aumenta la resolución de la imagen a 1440 x 2560px
- Usa un formato de mejor calidad (prueba PNG en lugar de JPG)

### El texto no se ve bien sobre la imagen
- Ajusta la opacidad del contenedor oscuro en `Login.dart` línea ~31:
  ```dart
  color: Colors.black.withOpacity(0.6), // Cambia 0.6 a 0.5 (más claro) o 0.8 (más oscuro)
  ```
