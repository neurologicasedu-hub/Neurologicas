import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Serviço para salvamento automático temporário de dados de escalas
/// Permite restaurar dados se o aplicativo for fechado acidentalmente
class AutoSaveService {
  // Prefixo para as chaves de auto-save
  static const String _autoSavePrefix = 'autosave_';

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// Salva dados temporários de uma escala
  /// [scaleName] - Nome único da escala (ex: 'nihss', 'glasgow', 'moca')
  /// [data] - Map com os dados a serem salvos (deve ser serializável para JSON)
  static Future<void> saveTemporaryData(String scaleName, Map<String, dynamic> data) async {
    try {
      final key = '$_autoSavePrefix$scaleName';
      final json = jsonEncode(data);
      await _storage.write(key: key, value: json);
    } catch (e) {
      // Silenciosamente falha se não conseguir salvar
      // Não queremos interromper o fluxo do usuário
      print('Erro ao salvar auto-save para $scaleName: $e');
    }
  }

  /// Carrega dados temporários salvos de uma escala
  /// Retorna null se não houver dados salvos
  static Future<Map<String, dynamic>?> loadTemporaryData(String scaleName) async {
    try {
      final key = '$_autoSavePrefix$scaleName';
      final json = await _storage.read(key: key);
      
      if (json == null) return null;
      
      final data = jsonDecode(json) as Map<String, dynamic>;
      return data;
    } catch (e) {
      print('Erro ao carregar auto-save para $scaleName: $e');
      return null;
    }
  }

  /// Limpa dados temporários de uma escala
  /// Usado quando a escala é salva permanentemente ou quando o usuário limpa manualmente
  static Future<void> clearTemporaryData(String scaleName) async {
    try {
      final key = '$_autoSavePrefix$scaleName';
      await _storage.delete(key: key);
    } catch (e) {
      print('Erro ao limpar auto-save para $scaleName: $e');
    }
  }

  /// Verifica se há dados temporários salvos para uma escala
  static Future<bool> hasTemporaryData(String scaleName) async {
    try {
      final key = '$_autoSavePrefix$scaleName';
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      return false;
    }
  }

  /// Limpa todos os dados temporários (útil para limpeza geral)
  static Future<void> clearAllTemporaryData() async {
    try {
      final allData = await _storage.readAll();
      
      for (final key in allData.keys) {
        if (key.startsWith(_autoSavePrefix)) {
          await _storage.delete(key: key);
        }
      }
    } catch (e) {
      print('Erro ao limpar todos os auto-saves: $e');
    }
  }
}

