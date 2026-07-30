import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/patient_data.dart';
import '../models/completed_score.dart';

class PatientService {
  static const String _currentPatientKey = 'current_patient_data';
  static const String _allPatientsKey = 'all_patients_data';
  static const String _completedScoresKey = 'completed_scores';

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // --- GERENCIAMENTO DE múltiplos PACIENTES ---

  // Retorna a lista de todos os pacientes salvos
  static Future<List<PatientData>> getPatients() async {
    try {
      final jsonString = await _storage.read(key: _allPatientsKey);
      if (jsonString == null) return [];

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((e) => PatientData.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Salva (ou atualiza) um paciente na lista e define como ativo
  static Future<void> savePatient(PatientData patient) async {
    final patients = await getPatients();

    // Verifica se já existe (pelo ID) e substitui ou adiciona
    final index = patients.indexWhere((p) => p.id == patient.id);
    if (index >= 0) {
      patients[index] = patient;
    } else {
      patients.add(patient);
    }

    // Salva a lista atualizada
    final jsonList = patients.map((p) => p.toJson()).toList();
    await _storage.write(key: _allPatientsKey, value: jsonEncode(jsonList));

    // Define este paciente como o ativo
    await setActivePatient(patient);
  }

  // Exclui um paciente
  static Future<void> deletePatient(String id) async {
    final patients = await getPatients();
    
    // Remove o paciente da lista
    patients.removeWhere((p) => p.id == id);
    
    // Salva a lista atualizada
    final jsonList = patients.map((p) => p.toJson()).toList();
    await _storage.write(key: _allPatientsKey, value: jsonEncode(jsonList));

    // Se o paciente excluído era o ativo, limpa o ativo
    final active = await loadPatientData();
    if (active != null && active.id == id) {
      await clearActivePatient();
    }
  }

  // --- GERENCIAMENTO DO PACIENTE ATIVO ---

  // Define qual paciente é o "atual" (ativo)
  static Future<void> setActivePatient(PatientData patient) async {
    final json = jsonEncode(patient.toJson());
    await _storage.write(key: _currentPatientKey, value: json);
  }

  // Carrega o paciente ativo (usado pelos formulários/escalas)
  static Future<PatientData?> loadPatientData() async {
    try {
      final json = await _storage.read(key: _currentPatientKey);
      if (json == null) return null;
      
      final data = jsonDecode(json) as Map<String, dynamic>;
      return PatientData.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  // Limpa apenas o paciente ativo (deslogar paciente)
  static Future<void> clearActivePatient() async {
    await _storage.delete(key: _currentPatientKey);
  }

  // Método legado para manter compatibilidade, mas agora apenas limpa o ativo
  static Future<void> clearPatientData() async {
    await clearActivePatient();
  }

  // --- GERENCIAMENTO DE SCORES ---

  // Salvar escala completada (DENTRO DO PACIENTE ATIVO)
  static Future<void> saveCompletedScore(CompletedScore score) async {
    try {
      final activePatient = await loadPatientData();
      
      // Vincula o score ao paciente ativo se houver
      if (activePatient != null) {
        score.patientId = activePatient.id;
      }

      final scores = await getAllCompletedScores(); // Carrega tudo para não perder de outros pacientes
      
      // Lógica de substituição: (mesmo nome, mesmo paciente)
      scores.removeWhere((s) => 
        s.scoreName == score.scoreName && 
        s.patientId == score.patientId
      );
      
      scores.add(score);
      
      final jsonList = scores.map((s) => s.toJson()).toList();
      await _storage.write(key: _completedScoresKey, value: jsonEncode(jsonList));
    } catch (e) {
      throw Exception('Erro ao salvar escala: $e');
    }
  }

  // Retorna scores APENAS do paciente ativo
  static Future<List<CompletedScore>> getCompletedScores() async {
    final activePatient = await loadPatientData();
    if (activePatient == null) return [];

    final allScores = await getAllCompletedScores();
    return allScores.where((s) => s.patientId == activePatient.id).toList();
  }

  // Helper privado para carregar TUDO do storage (sem filtro)
  static Future<List<CompletedScore>> getAllCompletedScores() async {
    try {
      final json = await _storage.read(key: _completedScoresKey);
      if (json == null) return [];
      
      final jsonList = jsonDecode(json) as List<dynamic>;
      return jsonList
          .map((item) => CompletedScore.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> clearCompletedScores() async {
    await _storage.delete(key: _completedScoresKey);
  }

  static Future<bool> isScoreCompleted(String scoreName) async {
    final scores = await getCompletedScores(); // Já filtra pelo paciente ativo
    return scores.any((s) => s.scoreName == scoreName);
  }

  static Future<void> deleteCompletedScore(CompletedScore score) async {
    try {
      final scores = await getAllCompletedScores(); // Carrega todos
      
      scores.removeWhere((s) => 
        s.scoreName == score.scoreName && 
        s.dataHora == score.dataHora &&
        s.patientId == score.patientId
      );
      
      final jsonList = scores.map((s) => s.toJson()).toList();
      await _storage.write(key: _completedScoresKey, value: jsonEncode(jsonList));
    } catch (e) {
      throw Exception('Erro ao excluir escala: $e');
    }
  }
}

