/// Archivo de configuración para API keys y constantes sensibles
/// IMPORTANTE: Este archivo no debe ser versionado en git para proteger las API keys

class AppConfig {
  // Google Gemini API Key
  // Obtén tu API key en: https://ai.google.dev/
  static const String googleGeminiApiKey = 'AIzaSyAoCSkrM3gn85cALcIK0vcgzPZJeQhtIyI';

  // Alternativamente, puedes dejar esto vacío y pasar la clave
  // desde variables de entorno o configuración en tiempo de ejecución
  static String? get geminiApiKeyEnv {
    // En producción, podrías obtener esto de variables de entorno
    return googleGeminiApiKey.isEmpty ? null : googleGeminiApiKey;
  }

  // Flag para cambiar entre IA local y Google Gemini
  static const bool useLocalIA = false; // Cambiar a true para usar respuestas locales

  // Otros ajustes
  static const Duration requestTimeout = Duration(seconds: 30);
}
