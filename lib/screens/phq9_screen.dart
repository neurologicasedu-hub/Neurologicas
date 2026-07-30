import 'package:flutter/material.dart';
import '../models/phq9_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class PHQ9Screen extends StatefulWidget {
  const PHQ9Screen({super.key});

  @override
  State<PHQ9Screen> createState() => _PHQ9ScreenState();
}

class _PHQ9ScreenState extends State<PHQ9Screen> {
  final PHQ9Data _data = PHQ9Data();

  final List<String> _questions = [
    'Pouco interesse ou prazer em fazer coisas',
    'Sente-se deprimido(a), sem esperança ou sem perspectiva',
    'Dificuldade para pegar no sono, permanecer dormindo ou dormir demais',
    'Sente-se cansado(a) ou com pouca energia',
    'Pouco apetite ou come demais',
    'Sente-se mal consigo mesmo(a) - ou sente que fracassou ou decepcionou a si mesmo(a) ou sua família',
    'Dificuldade para se concentrar em coisas, como ler o jornal ou assistir televisão',
    'Mover-se/falar tão devagar ou estar tão inquieto(a) que outros notaram',
    'Pensamentos de que seria melhor estar morto(a) ou de machucar a si mesmo(a)',
  ];

  Future<void> _salvarPHQ9() async {
    try {
      final score = CompletedScore(
        scoreName: 'Patient Health Questionnaire-9 (PHQ-9)',
        scoreData: {
          'interesse': _data.interesse,
          'tristeza': _data.tristeza,
          'sono': _data.sono,
          'energia': _data.energia,
          'apetite': _data.apetite,
          'autoestima': _data.autoestima,
          'concentracao': _data.concentracao,
          'velocidade': _data.velocidade,
          'suicidio': _data.suicidio,
        },
        resultado: '${_data.totalScore}/27 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala PHQ-9 salva com sucesso!'),
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
      title: 'PHQ-9',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Nas últimas 2 semanas, com que frequência você foi incomodado(a) pelos seguintes problemas?',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          _buildQuestionItem(0, _questions[0], _data.interesse, (v) => setState(() => _data.interesse = v)),
          _buildQuestionItem(1, _questions[1], _data.tristeza, (v) => setState(() => _data.tristeza = v)),
          _buildQuestionItem(2, _questions[2], _data.sono, (v) => setState(() => _data.sono = v)),
          _buildQuestionItem(3, _questions[3], _data.energia, (v) => setState(() => _data.energia = v)),
          _buildQuestionItem(4, _questions[4], _data.apetite, (v) => setState(() => _data.apetite = v)),
          _buildQuestionItem(5, _questions[5], _data.autoestima, (v) => setState(() => _data.autoestima = v)),
          _buildQuestionItem(6, _questions[6], _data.concentracao, (v) => setState(() => _data.concentracao = v)),
          _buildQuestionItem(7, _questions[7], _data.velocidade, (v) => setState(() => _data.velocidade = v)),
          _buildQuestionItem(8, _questions[8], _data.suicidio, (v) => setState(() => _data.suicidio = v)),

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
                const Text('PHQ-9 SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const Text(
                  '/ 27',
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
        onPressed: _salvarPHQ9,
        backgroundColor: Colors.blue,
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
        QuestionOption(label: 'Nenhuma vez (0)', value: 0),
        QuestionOption(label: 'Vários dias (1)', value: 1),
        QuestionOption(label: '> Metade dos dias (2)', value: 2),
        QuestionOption(label: 'Quase todos os dias (3)', value: 3),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 4) return Colors.green;
    if (score <= 9) return Colors.lightGreen;
    if (score <= 14) return Colors.orange;
    if (score <= 19) return Colors.deepOrange;
    return Colors.red;
  }
}
