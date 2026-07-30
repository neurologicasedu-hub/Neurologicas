import 'package:flutter/material.dart';
import '../models/fisher_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class FisherScreen extends StatefulWidget {
  const FisherScreen({super.key});

  @override
  State<FisherScreen> createState() => _FisherScreenState();
}

class _FisherScreenState extends State<FisherScreen> with AutoSaveMixin {
  final FisherData _data = FisherData();

  @override
  String get scaleName => 'fisher';

  @override
  Map<String, dynamic> getDataToSave() {
    return {'grau': _data.grau};
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.grau = data['grau'] ?? 1;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarFisher() async {
    try {
      final score = CompletedScore(
        scoreName: 'Fisher Scale',
        scoreData: {
          'grau': _data.grau,
        },
        resultado: '${_data.interpretacao} - Risco de Vasoespasmo: ${_data.riscoVasoespasmo}',
        totalScore: _data.grau,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Fisher salva com sucesso!'),
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
      title: 'Fisher Scale',
      body: [
         Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Classificação de Hemorragia Subaracnóidea em TC',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          QuestionCard<int>(
            title: 'Achados na Tomografia',
            value: _data.grau,
            onChanged: (v) => setState(() {
              _data.grau = v;
              onDataChanged();
            }),
            options: [
              QuestionOption(label: 'Grau 1: Sem sangue detectado', value: 1),
              QuestionOption(label: 'Grau 2: Sangue difuso fino (<1mm)', value: 2),
              QuestionOption(label: 'Grau 3: Coágulo localizado ou sangue espesso (>1mm)', value: 3),
              QuestionOption(label: 'Grau 4: Hemorragia intraventricular ou intraparenquimatosa', value: 4),
            ],
          ),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(_data.grau),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(_data.grau).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('FISHER GRADE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '${_data.grau}',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 12),
                 Text(
                  'Risco de Vasoespasmo: ${_data.riscoVasoespasmo}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarFisher,
        backgroundColor: Colors.amber.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getScoreColor(int grau) {
    if (grau <= 2) return Colors.green;
    return Colors.orange;
  }
}
