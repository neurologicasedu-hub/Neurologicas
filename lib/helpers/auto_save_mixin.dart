import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auto_save_service.dart';

/// Mixin para facilitar o auto-save em telas de escalas
/// 
/// Uso:
/// ```dart
/// class _MyScaleScreenState extends State<MyScaleScreen> with AutoSaveMixin {
///   @override
///   String get scaleName => 'my_scale';
///   
///   @override
///   Map<String, dynamic> getDataToSave() {
///     return {
///       'field1': value1,
///       'field2': value2,
///     };
///   }
///   
///   @override
///   Future<void> restoreData(Map<String, dynamic> data) async {
///     setState(() {
///       value1 = data['field1'] ?? defaultValue;
///       value2 = data['field2'] ?? defaultValue;
///     });
///   }
/// }
/// ```
mixin AutoSaveMixin<T extends StatefulWidget> on State<T> {
  Timer? _autoSaveTimer;
  bool _isRestoring = false;

  /// Nome único da escala (usado como chave para salvar)
  String get scaleName;

  /// Retorna os dados atuais para salvar
  Map<String, dynamic> getDataToSave();

  /// Restaura os dados salvos
  Future<void> restoreData(Map<String, dynamic> data);

  /// Chamado quando há mudanças nos dados (opcional, para override)
  void onDataChanged() {
    scheduleAutoSave();
  }

  /// Agenda um auto-save (com debounce de 2 segundos)
  void scheduleAutoSave() {
    // Cancela o timer anterior
    _autoSaveTimer?.cancel();
    
    // Agenda um novo auto-save em 2 segundos
    _autoSaveTimer = Timer(const Duration(seconds: 2), () {
      _performAutoSave();
    });
  }

  /// Executa o auto-save
  Future<void> _performAutoSave() async {
    if (_isRestoring) return;
    
    try {
      final data = getDataToSave();
      await AutoSaveService.saveTemporaryData(scaleName, data);
    } catch (e) {
      print('Erro ao executar auto-save: $e');
    }
  }

  /// Carrega dados salvos temporariamente
  Future<void> loadTemporaryData() async {
    try {
      final data = await AutoSaveService.loadTemporaryData(scaleName);
      if (data != null && mounted) {
        _isRestoring = true;
        await restoreData(data);
        _isRestoring = false;
        
        // Mostra um aviso discreto se houver dados restaurados
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dados temporários restaurados'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.blue,
            ),
          );
        }
      }
    } catch (e) {
      print('Erro ao carregar dados temporários: $e');
      _isRestoring = false;
    }
  }

  /// Limpa dados temporários salvos
  Future<void> clearTemporaryData() async {
    await AutoSaveService.clearTemporaryData(scaleName);
  }

  /// Salva imediatamente (sem esperar o timer)
  Future<void> saveImmediately() async {
    _autoSaveTimer?.cancel();
    await _performAutoSave();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}

