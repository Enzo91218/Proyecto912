/// Archivo de configuración para API keys y constantes sensibles
/// Las API keys se cargan desde .env para protegerlas

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  /// Obtiene la API key de Google Gemini desde variables de entorno
  /// Asegúrate de tener .env con: GOOGLE_GEMINI_API_KEY=tu_api_key
  static String get googleGeminiApiKey {
    final apiKey = dotenv.env['GOOGLE_GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'GOOGLE_GEMINI_API_KEY no configurada en .env. '
        'Copia .env.example a .env y agrega tu API key.',
      );
    }
    return apiKey;
  }

  // Flag para cambiar entre IA local y Google Gemini
  static const bool useLocalIA = false; // Cambiar a true para usar respuestas locales

  // Otros ajustes
  static const Duration requestTimeout = Duration(seconds: 60);
}
