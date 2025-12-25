import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para salvamento automático temporário de dados de escalas
/// Permite restaurar dados se o aplicativo for fechado acidentalmente
class AutoSaveService {
  // Prefixo para as chaves de auto-save
  static const String _autoSavePrefix = 'autosave_';

  /// Salva dados temporários de uma escala
  /// [scaleName] - Nome único da escala (ex: 'nihss', 'glasgow', 'moca')
  /// [data] - Map com os dados a serem salvos (deve ser serializável para JSON)
  static Future<void> saveTemporaryData(String scaleName, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_autoSavePrefix$scaleName';
      final json = jsonEncode(data);
      await prefs.setString(key, json);
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
      final prefs = await SharedPreferences.getInstance();
      final key = '$_autoSavePrefix$scaleName';
      final json = prefs.getString(key);
      
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
      final prefs = await SharedPreferences.getInstance();
      final key = '$_autoSavePrefix$scaleName';
      await prefs.remove(key);
    } catch (e) {
      print('Erro ao limpar auto-save para $scaleName: $e');
    }
  }

  /// Verifica se há dados temporários salvos para uma escala
  static Future<bool> hasTemporaryData(String scaleName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_autoSavePrefix$scaleName';
      return prefs.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  /// Limpa todos os dados temporários (útil para limpeza geral)
  static Future<void> clearAllTemporaryData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        if (key.startsWith(_autoSavePrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Erro ao limpar todos os auto-saves: $e');
    }
  }
}

