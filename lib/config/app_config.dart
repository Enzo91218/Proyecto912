/// Archivo de configuración para API keys y constantes sensibles
/// IMPORTANTE: Reemplaza YOUR_API_KEY_HERE con tu propia API key de Gemini
/// UPDATED: Recompilación forzada

class AppConfig {
  // Google Gemini API Key
  // Obtén tu API key en: https://aistudio.google.com/app/apikey
  // Reemplaza "YOUR_API_KEY_HERE" con tu propia key
  static const String googleGeminiApiKey = 'AIzaSyCfy3CaFehvQj9DwBiHRZw2bOaO5sSToaU';

  // Flag para cambiar entre IA local y Google Gemini
  static const bool useLocalIA =
      false; // Cambiar a true para usar respuestas locales

  // Otros ajustes
  static const Duration requestTimeout = Duration(seconds: 60);
}
