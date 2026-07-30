import 'package:flutter/material.dart';
import '../models/abcd_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

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
        totalScore: _abcdData.abcd3IScore, 
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

    return CalculatorScaffold(
      title: 'ABCD2 / ABCD3-I',
      body: [
        _buildDemographicsCard(),
        
        QuestionCard<String>(
          title: "Sintomas Clínicos",
          subtitle: "Selecione o sintoma primário",
          value: _getClinicalSymptom(),
          options: const [
            QuestionOption(label: 'Paresia focal (+2)', value: 'weakness'),
            QuestionOption(label: 'Distúrbio de linguagem isolado (+1)', value: 'speech'),
            QuestionOption(label: 'Nenhum destes (0)', value: 'none'),
          ],
          onChanged: (val) {
            setState(() {
              if (val == 'weakness') {
                _abcdData.clinicalWeakness = true;
                _abcdData.clinicalSpeech = false;
              } else if (val == 'speech') {
                _abcdData.clinicalWeakness = false;
                _abcdData.clinicalSpeech = true;
              } else {
                _abcdData.clinicalWeakness = false;
                _abcdData.clinicalSpeech = false;
              }
            });
            onDataChanged();
          },
        ),

        QuestionCard<bool>(
          title: "Duração dos Sintomas",
          value: false, // Not using toggle behavior here, custom input
          content: TextField(
            controller: _durationController,
            decoration: InputDecoration(
              labelText: 'Duração em minutos',
              hintText: 'Ex: 45',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
               contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              setState(() {
                _abcdData.durationMinutes = int.tryParse(v) ?? _abcdData.durationMinutes;
              });
              onDataChanged();
            },
          ),
          options: const [], // Empty options as it is an input only card, or we could add quick select chips
          onChanged: (_) {},
        ),

        QuestionCard<bool>(
          title: "Fatores de Risco",
          value: _abcdData.diabetes,
          options: const [QuestionOption(label: 'Diabetes presente (+1)', value: true)],
          onChanged: (val) {
             setState(() => _abcdData.diabetes = !_abcdData.diabetes);
             onDataChanged();
          },
        ),

        Container(
          margin: const EdgeInsets.all(16),
          child: const Divider(),
        ),

        QuestionCard<String>(
          title: "Fatores ABCD3-I (Imagem/Recorrência)",
          value: 'dummy', // Using as multi-select list basically
          options: const [],
          content: Column(
            children: [
               _buildSwitchTile('Dois TIAs em 7 dias (+2)', _abcdData.twoTIAsWithin7Days, (v) {
                 setState(() => _abcdData.twoTIAsWithin7Days = v);
                 onDataChanged();
               }),
               _buildSwitchTile('DWI positivo na RM (+2)', _abcdData.dwiPositive, (v) {
                 setState(() => _abcdData.dwiPositive = v);
                 onDataChanged();
               }),
               _buildSwitchTile('Estenose carotídea >=50% (+2)', _abcdData.carotidStenosisIpsilateral50, (v) {
                 setState(() => _abcdData.carotidStenosisIpsilateral50 = v);
                 onDataChanged();
               }),
            ],
          ),
          onChanged: (_) {},
        ),

        // Results Card
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                  color: Colors.cyan.shade50,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.cyan.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('ABCD2', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan)),
                    const SizedBox(height: 4),
                    Text('$abcd2', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.cyan.shade700)),
                    Text(interpretacao2, style: TextStyle(fontSize: 11, color: Colors.cyan.shade800), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
               child: Container(
                padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                    BoxShadow(color: Colors.teal.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('ABCD3-I', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                     const SizedBox(height: 4),
                    Text('$abcd3i', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal.shade700)),
                    Text(interpretacao3i, style: TextStyle(fontSize: 11, color: Colors.teal.shade800), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarABCD,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: value ? Colors.teal.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: value ? Colors.teal : Colors.transparent),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: TextStyle(fontSize: 13, fontWeight: value ? FontWeight.bold : FontWeight.normal))),
          Switch(
            value: value, 
            onChanged: onChanged,
            activeColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  String _getClinicalSymptom() {
    if (_abcdData.clinicalWeakness) return 'weakness';
    if (_abcdData.clinicalSpeech) return 'speech';
    return 'none';
  }

  Widget _buildDemographicsCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Idade', 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    setState(() => _abcdData.age = int.tryParse(v) ?? _abcdData.age);
                    onDataChanged();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
               Expanded(
                child: TextField(
                  controller: _systolicController,
                  decoration: InputDecoration(
                    labelText: 'PAS', 
                    suffixText: 'mmHg',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    setState(() => _abcdData.systolicBP = int.tryParse(v) ?? _abcdData.systolicBP);
                    onDataChanged();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _diastolicController,
                  decoration: InputDecoration(
                    labelText: 'PAD', 
                    suffixText: 'mmHg',
                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    setState(() => _abcdData.diastolicBP = int.tryParse(v) ?? _abcdData.diastolicBP);
                    onDataChanged();
                  },
                ),
              ),
            ],
          ),
        ],
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
