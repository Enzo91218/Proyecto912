import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService extends ChangeNotifier {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _isInitialized = false;

  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;
  bool get isInitialized => _isInitialized;

  AudioService() {
    _audioPlayer = AudioPlayer();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      print('DEBUG: Iniciando AudioService con audioplayers...');
      
      // Cargar desde assets
      await _audioPlayer.setSource(AssetSource('audio/background_music.mp3'));
      print('✅ Audio cargado desde assets');
      
      // Establecer volumen a 0.3 (30%)
      await _audioPlayer.setVolume(0.3);
      print('✅ Volumen establecido a 30%');
      
      // Configurar para reproducir en bucle
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      print('✅ Loop activado');
      
      _isInitialized = true;
      notifyListeners();
      
      print('✅ AudioService inicializado correctamente');
    } catch (e) {
      print('❌ Error inicializando AudioService: $e');
      print('DEBUG: Stack trace: ${e.toString()}');
      _isInitialized = false;
      notifyListeners();
    }
  }

  Future<void> play() async {
    try {
      if (!_isInitialized) {
        print('⚠️ AudioService no está inicializado');
        return;
      }
      
      if (!_isPlaying) {
        await _audioPlayer.resume();
        _isPlaying = true;
        notifyListeners();
        print('▶️ Reproduciendo música');
      }
    } catch (e) {
      print('❌ Error reproduciendo: $e');
    }
  }

  Future<void> pause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        _isPlaying = false;
        notifyListeners();
        print('⏸️ Pausa en música');
      }
    } catch (e) {
      print('❌ Error pausando: $e');
    }
  }

  Future<void> toggleMute() async {
    try {
      _isMuted = !_isMuted;
      
      if (_isMuted) {
        await _audioPlayer.setVolume(0);
        print('🔇 Música silenciada');
      } else {
        await _audioPlayer.setVolume(0.3);
        print('🔊 Música activada');
      }
      notifyListeners();
    } catch (e) {
      print('❌ Error silenciando: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
