import 'package:flutter/foundation.dart';
import '../adaptadores/sqlite/database_provider.dart';

class DatabaseUpdateService extends ChangeNotifier {
  final DatabaseProvider _databaseProvider;
  DateTime? _lastUpdate;

  DatabaseUpdateService(this._databaseProvider);

  /// Obtiene la última fecha de actualización
  DateTime? get lastUpdate => _lastUpdate;

  /// Obtiene la última actualización formateada como texto
  String get lastUpdateFormatted {
    if (_lastUpdate == null) {
      return 'Nunca';
    }
    final now = DateTime.now();
    final difference = now.difference(_lastUpdate!);

    if (difference.inSeconds < 60) {
      return 'Hace ${difference.inSeconds} segundos';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else {
      return '${_lastUpdate!.day}/${_lastUpdate!.month}/${_lastUpdate!.year}';
    }
  }

  /// Registra una actualización en la base de datos
  void recordUpdate() {
    _lastUpdate = DateTime.now();
    _databaseProvider.recordDatabaseUpdate();
    notifyListeners();
  }

  /// Inicializa el servicio con la última actualización conocida
  void initialize() {
    _lastUpdate = _databaseProvider.lastUpdate;
    if (_lastUpdate == null) {
      _lastUpdate = DateTime.now();
    }
  }
}
