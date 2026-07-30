import 'package:flutter/material.dart';
import '../models/pcs_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class PainCatastrophizingScreen extends StatefulWidget {
  const PainCatastrophizingScreen({super.key});

  @override
  State<PainCatastrophizingScreen> createState() => _PainCatastrophizingScreenState();
}

class _PainCatastrophizingScreenState extends State<PainCatastrophizingScreen> {
  final PCSData _data = PCSData();

  final List<String> _questions = [
    'Quando estou com dor, fico preocupado(a) que nunca vai melhorar', // Ruminação (1)
    'Quando estou com dor, sinto que não posso deixar de pensar na dor', // Ruminação (2)
    'Quando estou com dor, fico preocupado(a) que vai piorar', // Ruminação (3)
    'Quando estou com dor, penso em outras situações dolorosas', // Ruminação (4)
    'Quando estou com dor, penso que a dor é terrível e que não suporto', // Magnificação (5)
    'Quando estou com dor, penso que algo sério pode estar acontecendo', // Magnificação (6)
    'Quando estou com dor, penso que outros não entendem como a dor é severa', // Magnificação (7)
    'Quando estou com dor, não consigo deixar a dor fora da minha mente', // Desamparo (8)
    'Quando estou com dor, não consigo ir em frente com a dor', // Desamparo (9)
    'Quando estou com dor, não há nada que eu possa fazer para reduzir a intensidade da dor', // Desamparo (10)
    'Quando estou com dor, sinto que não posso lidar com a dor', // Desamparo (11)
    'Quando estou com dor, sinto que minha vida não vale a pena', // Desamparo (12)
    'Quando estou com dor, sinto que não posso continuar assim', // Desamparo (13)
  ];

  final List<String> _options = ['Não (0)', 'Leve (1)', 'Moderado (2)', 'Severo (3)', 'Sempre (4)'];

  Future<void> _salvarPCS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Pain Catastrophizing Scale (PCS)',
        scoreData: {'respostas': _data.respostas},
        resultado: '${_data.totalScore}/52 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala PCS salva com sucesso!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ver Relatório',
              textColor: Colors.white,
              onPressed: () => Navigator.pushReplacementNamed(context, '/report'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'PCS',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Pain Catastrophizing Scale\n0=Não, 4=Sempre',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          ...List.generate(_questions.length, (index) {
             String subscale = '';
             if (index < 4) subscale = 'Ruminação';
             else if (index < 7) subscale = 'Magnificação';
             else subscale = 'Desamparo';

             return QuestionCard<String>(
               title: '${index + 1}. ${_questions[index]} ($subscale)',
               options: _options.map((e) => QuestionOption(label: e, value: e)).toList(),
               value: _options[_data.respostas[index]],
               onChanged: (val) {
                 final valIndex = _options.indexOf(val);
                 setState(() => _data.respostas[index] = valIndex);
               },
             );
          }),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 20 ? Colors.green : score <= 40 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 20 ? Colors.green : score <= 40 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('PCS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$score', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 8),
                Text('R: ${_data.scoreRumination}  M: ${_data.scoreMagnification}  D: ${_data.scoreHelplessness}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 12),
                Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarPCS,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
