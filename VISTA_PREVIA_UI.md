# 🎨 Vista Previa Visual - Herramientas

## Menú Principal con Nueva Opción

```
┌─────────────────────────────────┐
│ ≡                               │  ← Menú de 3 puntos
└─────────────────────────────────┘

      (después de tocar ≡)

╔═════════════════════════════════╗
║      Más opciones               ║
╠═════════════════════════════════╣
║                                 ║
║  👤 Mi Perfil                   ║
║  ➕ Publicar Receta             ║
║  ⚖️ IMC                         ║
║  📊 Registro de Peso            ║
║  📈 Balance de Peso             ║
║  ─────────────────────────────  ║
║  🌓 Modo Claro/Oscuro           ║
║  🔧 Herramientas         ← NUEVO║
║  ─────────────────────────────  ║
║  🚪 Cerrar Sesión               ║
║  ❌ Salir                       ║
║                                 ║
╚═════════════════════════════════╝
```

---

## Pantalla de Herramientas - Vista Completa

```
╔════════════════════════════════════════════════════════╗
║  < HERRAMIENTAS                                        ║
╠════════════════════════════════════════════════════════╣
║                                                        ║
║  Base de Datos                                         ║
║                                                        ║
║  ┌──────────────────────────────────────────────────┐  ║
║  │  📍 Ubicación                                    │  ║
║  │  /data/data/com.example.proyecto/...            │  ║
║  │  proyecto912.db                                  │  ║
║  │  Sistema de archivos local                       │  ║
║  └──────────────────────────────────────────────────┘  ║
║                                                        ║
║  ┌──────────────────────────────────────────────────┐  ║
║  │  💾 Tamaño                                       │  ║
║  │  2,548.75 KB                                     │  ║
║  │  Espacio ocupado                                 │  ║
║  └──────────────────────────────────────────────────┘  ║
║                                                        ║
║  ┌──────────────────────────────────────────────────┐  ║
║  │  ⏰ Última Actualización                         │  ║
║  │  Hace 2 minutos                                  │  ║
║  │  Cambios registrados                             │  ║
║  └──────────────────────────────────────────────────┘  ║
║                                                        ║
║  Acciones                                              ║
║                                                        ║
║  ┌──────────────────────────────────────────────────┐  ║
║  │  📥 Descargar Base de Datos                      │  ║
║  └──────────────────────────────────────────────────┘  ║
║                                                        ║
║  Información                                           ║
║                                                        ║
║  ℹ️  Sobre esta aplicación                            ║
║     Proyecto912 v1.0.0                                ║
║     →                                                 ║
║                                                        ║
║  📦 Base de datos SQLite                              ║
║     Almacenamiento local seguro                       ║
║     →                                                 ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
```

---

## Detalles de Cada Sección

### 📍 Ubicación
```
Muestra la ruta completa de la base de datos
Ejemplo: /data/data/com.example.proyecto/databases/proyecto912.db
O en iOS: /var/mobile/Containers/Data/Application/.../proyecto912.db
O en Windows: C:\Users\Usuario\AppData\Local\proyecto912.db
```

### 💾 Tamaño
```
Muestra el tamaño del archivo en KB
Se actualiza automáticamente cuando la BD crece
Útil para monitorear consumo de almacenamiento
```

### ⏰ Última Actualización
```
Muestra cuándo se modificó la BD por última vez
Formatos:
- "Hace 30 segundos"
- "Hace 5 minutos"
- "Hace 1 hora"
- "Hace 3 días"
- "15/12/2024" (formato fecha si es más viejo)
```

### 📥 Descargar Base de Datos
```
Al tocar el botón:
1. Copia la BD desde documentos a descargas
2. Agrega timestamp a la copia (proyecto912_2024-12-11_143045.db)
3. Muestra mensaje de confirmación
4. Archivo disponible en carpeta de descargas del dispositivo
```

---

## Estados Visuales

### Estado Normal (BD Actualizada Hace Poco)
```
⏰ Última Actualización
Hace 2 minutos ✅
Cambios registrados
```

### Estado Actualización Reciente (Justo Ahora)
```
⏰ Última Actualización
Hace menos de un minuto ⚡
Cambios registrados
```

### Estado BD Antigua (No se ha modificado)
```
⏰ Última Actualización
15/12/2024 ⚠️
Cambios registrados
```

---

## Tema Claro

```
Fondo: Blanco/Gris muy claro
Texto: Negro/Gris oscuro
Acento: Azul
Cards: Blanco con sombra
Botón: Azul con texto blanco
```

---

## Tema Oscuro

```
Fondo: Gris muy oscuro
Texto: Blanco/Gris claro
Acento: Azul más claro
Cards: Gris oscuro
Botón: Azul con texto blanco
```

---

## Flujo de Descarga

```
Usuario toca "Descargar Base de Datos"
        ↓
Verifica que la ruta existe
        ↓
Obtiene carpeta de descargas del dispositivo
        ↓
Crea nombre único: proyecto912_TIMESTAMP.db
        ↓
Copia archivo a carpeta de descargas
        ↓
Muestra notificación: "Base de datos descargada en: /storage/emulated/0/Download/..."
        ↓
Usuario puede acceder al archivo desde el administrador de archivos
```

---

## Animaciones

### Carga Inicial
- Cards aparecen con transición suave
- Información se carga y aparece gradualmente
- Tiempo total: ~500ms

### Actualización de Timestamp
- El texto se actualiza en tiempo real
- Sin parpadeo ni refresco de página
- Cambios inmediatos cuando se registra nuevos datos

### Interacción del Botón
- Hover/Touch: Cambio de color
- Descarga: Muestra snackbar con progreso
- Error: Muestra snackbar rojo con mensaje

---

## Responsividad

### Móvil (Portrait)
```
Pantalla completa
Scroll vertical si contenido es muy largo
Cards full-width con padding
```

### Tablet (Landscape)
```
Máximo ancho 600dp
Mantiene padding proporcional
Cards se centran si hay espacio
```

### Desktop
```
Máximo ancho 800dp
Padding generoso en los lados
Cursor cambia en botones (hover effect)
```

---

## Elementos Interactivos

### Botón "Descargar Base de Datos"
```
Normal:
  Color: Azul
  Icono: 📥
  Texto: "Descargar Base de Datos"
  Padding: 12px vertical, 16px horizontal

Hover (Desktop):
  Color: Azul más oscuro
  Elevación: Mayor sombra
  Cursor: Pointer

Presionado (Móvil):
  Animación de onda (ripple effect)
  Feedback táctil (vibración)
```

### Información de BD
```
Copiable: El texto se puede seleccionar y copiar
Actualizable: Se actualiza automáticamente
Legible: Fuente monoespaciada para ruta (opcional)
```

---

## Notificaciones del Usuario

### Descarga Exitosa
```
[✓] Base de datos descargada en: /storage/emulated/0/Download/proyecto912_2024-12-11_143045.db
(Dura 4 segundos)
```

### Error - Archivo No Encontrado
```
[✗] No se pudo encontrar la base de datos
(Dura 3 segundos)
```

### Error - Carpeta de Descargas No Accesible
```
[✗] No se pudo acceder a la carpeta de descargas
(Dura 3 segundos)
```

### Error General
```
[✗] Error: [Mensaje de error específico]
(Dura 3 segundos)
```

---

## Accesibilidad

### Colores
- Alto contraste en ambos temas
- No depende solo del color (usa iconos + color)
- Compatible con daltonismo

### Texto
- Tamaño legible (12-18sp)
- Jerarquía clara con pesos de fuente
- Labels descriptivos

### Interacción
- Botones grandes (min 48x48dp)
- Spacing adecuado entre elementos
- Feedback visual en cada interacción

### Screen Reader
- Descripciones de iconos
- Labels en botones
- Contenido organizado lógicamente

---

## Performance Visual

- ✅ Carga rápida de información
- ✅ Sin lag al actualizar timestamps
- ✅ Scroll suave
- ✅ Animaciones fluidas (60fps)
- ✅ Sin parpadeos

---

## Casos de Uso Visuales

### Usuario Acaba de Registrar un Peso
```
Antes:
⏰ Última Actualización: Hace 10 minutos

Después:
⏰ Última Actualización: Hace 5 segundos ⚡
```

### Usuario Abre Herramientas por Primera Vez
```
⏰ Última Actualización: Hace menos de un minuto
(Primer startup de la app)
```

### Usuario Deja la App Abierta
```
Tiempo transcurrido:
- T=0s: Hace menos de un minuto
- T=30s: Hace 30 segundos
- T=60s: Hace 1 minuto
- T=300s: Hace 5 minutos
(Sin que el usuario haga nada)
```

---

**Estado Visual:** ✅ Completo y funcional
