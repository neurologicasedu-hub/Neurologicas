import 'package:flutter/material.dart';
import '../models/hoehn_yahr_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class HoehnYahrScreen extends StatefulWidget {
  const HoehnYahrScreen({super.key});

  @override
  State<HoehnYahrScreen> createState() => _HoehnYahrScreenState();
}

class _HoehnYahrScreenState extends State<HoehnYahrScreen> {
  final HoehnYahrData _data = HoehnYahrData();

  Future<void> _salvarHoehnYahr() async {
    try {
      final score = CompletedScore(
        scoreName: 'Hoehn and Yahr Scale',
        scoreData: {'stage': _data.stage},
        resultado: 'Estágio ${_data.stage} - ${_data.stageDescription} - ${_data.interpretation}',
        totalScore: _data.stage,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Hoehn and Yahr salva com sucesso!'),
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
      title: 'Hoehn & Yahr',
      body: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Estadiamento da Doença de Parkinson.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),

        QuestionCard<int>(
          title: 'Estágio Clínico',
          subtitle: 'Selecione a melhor descrição para o paciente.',
          value: _data.stage,
          onChanged: (v) => setState(() => _data.stage = v),
          options: const [
            QuestionOption(label: '0 - Sem sinais de doença', value: 0),
            QuestionOption(label: '1 - Doença unilateral apenas', value: 1),
            QuestionOption(label: '2 - Doença bilateral sem comprometimento do equilíbrio', value: 2),
            QuestionOption(label: '3 - Doença bilateral leve/moderada; equilíbrio comprometido; independente', value: 3),
            QuestionOption(label: '4 - Incapacidade grave; deambula sem ajuda', value: 4), // Shortened for UI fit
            QuestionOption(label: '5 - Confinado à cadeira de rodas ou leito', value: 5),
          ],
        ),

        if (_data.stage > 0)
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue.shade800),
                    const SizedBox(width: 8),
                    Text('Interpretação', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(_data.stageDescription, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 8),
                Text(_data.interpretation, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarHoehnYahr,
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
