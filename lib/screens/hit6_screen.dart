import 'package:flutter/material.dart';
import '../models/hit6_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class HIT6Screen extends StatefulWidget {
  const HIT6Screen({super.key});

  @override
  State<HIT6Screen> createState() => _HIT6ScreenState();
}

class _HIT6ScreenState extends State<HIT6Screen> {
  final HIT6Data _data = HIT6Data();

  final List<String> _questions = [
    'Quando você tem dor de cabeça, com que frequência a dor é muito severa?',
    'Com que frequência a dor de cabeça limita sua capacidade de realizar atividades diárias?',
    'Quando você tem dor de cabeça, com que frequência deseja descansar?',
    'Nas últimas 4 semanas, com que frequência você sentiu cansado, fatigado ou com pouca energia por causa de sua dor de cabeça?',
    'Nas últimas 4 semanas, com que frequência você sentiu irritado por causa de sua dor de cabeça?',
    'Nas últimas 4 semanas, com que frequência a dor de cabeça limitou sua capacidade de se concentrar em atividades?',
  ];

  Future<void> _salvarHIT6() async {
    try {
      final score = CompletedScore(
        scoreName: 'Headache Impact Test (HIT-6)',
        scoreData: {
          'dorSevera': _data.dorSevera,
          'limitaAtividades': _data.limitaAtividades,
          'desejaDescansar': _data.desejaDescansar,
          'cansaco': _data.cansaco,
          'irritado': _data.irritado,
          'dificuldadeConcentrar': _data.dificuldadeConcentrar,
        },
        resultado: '${_data.totalScore}/78 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala HIT-6 salva com sucesso!'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'HIT-6',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Nas últimas 4 semanas, com que frequência você teve os seguintes problemas?',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          _buildQuestionItem(0, _questions[0], _data.dorSevera, (v) => setState(() => _data.dorSevera = v)),
          _buildQuestionItem(1, _questions[1], _data.limitaAtividades, (v) => setState(() => _data.limitaAtividades = v)),
          _buildQuestionItem(2, _questions[2], _data.desejaDescansar, (v) => setState(() => _data.desejaDescansar = v)),
          _buildQuestionItem(3, _questions[3], _data.cansaco, (v) => setState(() => _data.cansaco = v)),
          _buildQuestionItem(4, _questions[4], _data.irritado, (v) => setState(() => _data.irritado = v)),
          _buildQuestionItem(5, _questions[5], _data.dificuldadeConcentrar, (v) => setState(() => _data.dificuldadeConcentrar = v)),

          // Result Card
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(score),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(score).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('HIT-6 SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const Text(
                  '/ 78',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                   child: Text(
                    _data.interpretation,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarHIT6,
        backgroundColor: Colors.amber.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildQuestionItem(int index, String question, int value, ValueChanged<int> onChanged) {
    return QuestionCard<int>(
      title: '${index + 1}. $question',
      value: value,
      onChanged: onChanged,
      options: const [
        QuestionOption(label: 'Nunca (6)', value: 6),
        QuestionOption(label: 'Raramente (8)', value: 8),
        QuestionOption(label: 'Às vezes (10)', value: 10),
        QuestionOption(label: 'Muito frequentemente (11)', value: 11),
        QuestionOption(label: 'Sempre (13)', value: 13),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 49) return Colors.green;
    if (score <= 55) return Colors.lightGreen;
    if (score <= 59) return Colors.orange;
    return Colors.red;
  }
}
