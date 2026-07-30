import 'package:flutter/material.dart';
import '../models/hunt_hess_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class HuntHessScreen extends StatefulWidget {
  const HuntHessScreen({super.key});

  @override
  State<HuntHessScreen> createState() => _HuntHessScreenState();
}

class _HuntHessScreenState extends State<HuntHessScreen> with AutoSaveMixin {
  final HuntHessData _data = HuntHessData();

  @override
  String get scaleName => 'hunt_hess';

  @override
  Map<String, dynamic> getDataToSave() {
    return {'nivel': _data.nivel};
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.nivel = data['nivel'] ?? 1;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarHuntHess() async {
    try {
      final score = CompletedScore(
        scoreName: 'Hunt and Hess Scale',
        scoreData: {
          'nivel': _data.nivel,
        },
        resultado: '${_data.interpretacao} - Mortalidade estimada: ${_data.mortalidadeEstimada}',
        totalScore: _data.nivel,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Hunt and Hess salva com sucesso!'),
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
    return CalculatorScaffold(
      title: 'Hunt & Hess',
      body: [
         Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Classificação de Hemorragia Subaracnóidea.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          QuestionCard<int>(
            title: 'Sinais e Sintomas',
            value: _data.nivel,
            onChanged: (v) {
              setState(() => _data.nivel = v);
              onDataChanged();
            },
            options: const [
              QuestionOption(label: 'Grau 1: Assintomático, cefaleia leve, rigidez nuca leve', value: 1),
              QuestionOption(label: 'Grau 2: Cefaleia moderada a severa, rigidez de nuca, sem déficit focal (exceto paralisia NC)', value: 2),
              QuestionOption(label: 'Grau 3: Sonolência, confusão, déficit focal leve', value: 3),
              QuestionOption(label: 'Grau 4: Estupor, hemiparesia moderada a severa, rigidez de descerebração precoce', value: 4),
              QuestionOption(label: 'Grau 5: Coma profundo, rigidez de descerebração, aparência moribunda', value: 5),
            ],
          ),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(_data.nivel),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(_data.nivel).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('HUNT & HESS GRADE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '${_data.nivel}',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 12),
                 Text(
                  'Mortalidade Estimada: ${_data.mortalidadeEstimada}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarHuntHess,
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getScoreColor(int nivel) {
    if (nivel <= 2) return Colors.green;
    if (nivel == 3) return Colors.orange;
    return Colors.red;
  }
}
