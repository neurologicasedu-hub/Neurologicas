import 'package:flutter/material.dart';
import '../models/abcd_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

class ABCDScreen extends StatefulWidget {
  const ABCDScreen({super.key});

  @override
  State<ABCDScreen> createState() => _ABCDScreenState();
}

class _ABCDScreenState extends State<ABCDScreen> with AutoSaveMixin {
  final ABCDData _abcdData = ABCDData();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _systolicController = TextEditingController(text: '140');
  final TextEditingController _diastolicController = TextEditingController(text: '90');
  final TextEditingController _durationController = TextEditingController(text: '10');

  @override
  String get scaleName => 'abcd';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'age': _abcdData.age,
      'systolicBP': _abcdData.systolicBP,
      'diastolicBP': _abcdData.diastolicBP,
      'durationMinutes': _abcdData.durationMinutes,
      'clinicalWeakness': _abcdData.clinicalWeakness,
      'clinicalSpeech': _abcdData.clinicalSpeech,
      'diabetes': _abcdData.diabetes,
      'twoTIAsWithin7Days': _abcdData.twoTIAsWithin7Days,
      'dwiPositive': _abcdData.dwiPositive,
      'carotidStenosisIpsilateral50': _abcdData.carotidStenosisIpsilateral50,
      'ageText': _ageController.text,
      'systolicText': _systolicController.text,
      'diastolicText': _diastolicController.text,
      'durationText': _durationController.text,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _abcdData.age = data['age'] ?? 65;
    _abcdData.systolicBP = data['systolicBP'] ?? 140;
    _abcdData.diastolicBP = data['diastolicBP'] ?? 90;
    _abcdData.durationMinutes = data['durationMinutes'] ?? 10;
    _abcdData.clinicalWeakness = data['clinicalWeakness'] ?? false;
    _abcdData.clinicalSpeech = data['clinicalSpeech'] ?? false;
    _abcdData.diabetes = data['diabetes'] ?? false;
    _abcdData.twoTIAsWithin7Days = data['twoTIAsWithin7Days'] ?? false;
    _abcdData.dwiPositive = data['dwiPositive'] ?? false;
    _abcdData.carotidStenosisIpsilateral50 = data['carotidStenosisIpsilateral50'] ?? false;
    if (data.containsKey('ageText')) _ageController.text = data['ageText'] ?? '';
    if (data.containsKey('systolicText')) _systolicController.text = data['systolicText'] ?? '';
    if (data.containsKey('diastolicText')) _diastolicController.text = data['diastolicText'] ?? '';
    if (data.containsKey('durationText')) _durationController.text = data['durationText'] ?? '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadPatientData();
    _updateFields();
    loadTemporaryData();
  }

  Future<void> _loadPatientData() async {
    final patient = await PatientService.loadPatientData();
    if (patient != null && patient.idade != null) {
      _ageController.text = patient.idade!.toString();
      setState(() {
        _abcdData.age = patient.idade!;
      });
    } else {
      _ageController.text = _abcdData.age.toString();
    }
  }

  void _updateFields() {
    _systolicController.text = _abcdData.systolicBP.toString();
    _diastolicController.text = _abcdData.diastolicBP.toString();
    _durationController.text = _abcdData.durationMinutes.toString();
  }

  Future<void> _salvarABCD() async {
    try {
      final score = CompletedScore(
        scoreName: 'ABCD2 / ABCD3-I',
        scoreData: {
          'age': _abcdData.age,
          'systolicBP': _abcdData.systolicBP,
          'diastolicBP': _abcdData.diastolicBP,
          'durationMinutes': _abcdData.durationMinutes,
          'clinicalWeakness': _abcdData.clinicalWeakness,
          'clinicalSpeech': _abcdData.clinicalSpeech,
          'diabetes': _abcdData.diabetes,
          'twoTIAsWithin7Days': _abcdData.twoTIAsWithin7Days,
          'dwiPositive': _abcdData.dwiPositive,
          'carotidStenosisIpsilateral50': _abcdData.carotidStenosisIpsilateral50,
        },
        resultado: 'ABCD2: ${_abcdData.abcd2Score} - ${_abcdData.interpretacaoABCD2}\nABCD3-I: ${_abcdData.abcd3IScore} - ${_abcdData.interpretacaoABCD3I}',
        totalScore: _abcdData.abcd3IScore, // Usa ABCD3-I como score principal
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ABCD2/ABCD3-I salva com sucesso!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ver Relatório',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/report');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final abcd2 = _abcdData.abcd2Score;
    final abcd3i = _abcdData.abcd3IScore;
    final interpretacao2 = _abcdData.interpretacaoABCD2;
    final interpretacao3i = _abcdData.interpretacaoABCD3I;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ABCD2 / ABCD3-I'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Preencha dados do paciente para calcular ABCD2 e ABCD3-I:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Idade',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    setState(() {
                      _abcdData.age = int.tryParse(v) ?? _abcdData.age;
                    });
                    onDataChanged();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _systolicController,
                  decoration: const InputDecoration(
                    labelText: 'PAS (mmHg)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    setState(() {
                      _abcdData.systolicBP = int.tryParse(v) ?? _abcdData.systolicBP;
                    });
                    onDataChanged();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _diastolicController,
                  decoration: const InputDecoration(
                    labelText: 'PAD (mmHg)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    setState(() {
                      _abcdData.diastolicBP = int.tryParse(v) ?? _abcdData.diastolicBP;
                    });
                    onDataChanged();
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          _buildSwitchItem(
            'Clínica: paresia focal (+2 pontos)',
            _abcdData.clinicalWeakness,
            (val) {
              setState(() {
                _abcdData.clinicalWeakness = val;
                if (val) _abcdData.clinicalSpeech = false;
              });
              onDataChanged();
            },
          ),
          _buildSwitchItem(
            'Clínica: distúrbio isolado de linguagem (+1 ponto)',
            _abcdData.clinicalSpeech,
            (val) {
              setState(() {
                _abcdData.clinicalSpeech = val;
                if (val) _abcdData.clinicalWeakness = false;
              });
              onDataChanged();
            },
          ),
          
          TextField(
            controller: _durationController,
            decoration: const InputDecoration(
              labelText: 'Duração do sintoma (minutos)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              setState(() {
                _abcdData.durationMinutes = int.tryParse(v) ?? _abcdData.durationMinutes;
              });
              onDataChanged();
            },
          ),
          
          const SizedBox(height: 8),
          
          _buildSwitchItem(
            'Diabetes presente (+1)',
            _abcdData.diabetes,
            (val) {
              setState(() => _abcdData.diabetes = val);
              onDataChanged();
            },
          ),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          
          const Text(
            'Fatores adicionais ABCD3-I:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          _buildSwitchItem(
            'Dois TIAs em 7 dias (recorrência) (+2)',
            _abcdData.twoTIAsWithin7Days,
            (val) {
              setState(() => _abcdData.twoTIAsWithin7Days = val);
              onDataChanged();
            },
          ),
          _buildSwitchItem(
            'Lesão DWI positiva na ressonância (+2)',
            _abcdData.dwiPositive,
            (val) {
              setState(() => _abcdData.dwiPositive = val);
              onDataChanged();
            },
          ),
          _buildSwitchItem(
            'Estenose carotídea ipsilateral >=50% (+2)',
            _abcdData.carotidStenosisIpsilateral50,
            (val) {
              setState(() => _abcdData.carotidStenosisIpsilateral50 = val);
              onDataChanged();
            },
          ),
          
          const SizedBox(height: 16),
          
          // Resultado ABCD2
          Card(
            color: Colors.cyan.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'ABCD2',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$abcd2',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    interpretacao2,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.cyan.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Resultado ABCD3-I
          Card(
            color: Colors.teal.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'ABCD3-I',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$abcd3i',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    interpretacao3i,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.teal.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Observação: ABCD2 provê um risco clínico inicial; ABCD3-I melhora estratificação com imagem/recorrência. Use em combinação com avaliação clínica.',
              style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Botões
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarABCD();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala ABCD2/ABCD3-I'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Início'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.cyan,
        dense: true,
      ),
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
