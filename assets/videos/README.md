# Videos de la Aplicación

Esta carpeta está reservada para archivos de video.

## Para agregar videos a la app

1. Flutter no soporta videos nativamente sin dependencias extras
2. Si necesitas videos, debes usar un paquete como `video_player`

Para agregar soporte de video:

```yaml
dependencies:
  video_player: ^2.8.0
```

Luego en tu código:
```dart
import 'package:video_player/video_player.dart';

VideoPlayer(VideoPlayerController.asset('assets/videos/mi_video.mp4'))
```

Coloca tus videos aquí si decides implementar esta funcionalidad.
