import 'package:flutter/material.dart';
import '../models/gad7_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class GAD7Screen extends StatefulWidget {
  const GAD7Screen({super.key});

  @override
  State<GAD7Screen> createState() => _GAD7ScreenState();
}

class _GAD7ScreenState extends State<GAD7Screen> {
  final GAD7Data _data = GAD7Data();

  final List<String> _questions = [
    'Sentir-se nervoso(a), ansioso(a) ou muito tenso(a)',
    'Não conseguir parar ou controlar a preocupação',
    'Preocupar-se demais com diferentes coisas',
    'Dificuldade para relaxar',
    'Ficar tão inquieto(a) que é difícil ficar sentado(a)',
    'Ficar facilmente aborrecido(a) ou irritado(a)',
    'Sentir medo como se algo horrível fosse acontecer',
  ];

  Future<void> _salvarGAD7() async {
    try {
      final score = CompletedScore(
        scoreName: 'Generalized Anxiety Disorder-7 (GAD-7)',
        scoreData: {
          'nervosismo': _data.nervosismo,
          'controlePreocupacao': _data.controlePreocupacao,
          'preocupacaoExcessiva': _data.preocupacaoExcessiva,
          'dificuldadeRelaxar': _data.dificuldadeRelaxar,
          'inquietacao': _data.inquietacao,
          'irritabilidade': _data.irritabilidade,
          'medo': _data.medo,
        },
        resultado: '${_data.totalScore}/21 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala GAD-7 salva com sucesso!'),
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
      title: 'GAD-7',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Nas últimas 2 semanas, com que frequência você foi incomodado(a) pelos seguintes problemas?',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          _buildQuestionItem(0, _questions[0], _data.nervosismo, (v) => setState(() => _data.nervosismo = v)),
          _buildQuestionItem(1, _questions[1], _data.controlePreocupacao, (v) => setState(() => _data.controlePreocupacao = v)),
          _buildQuestionItem(2, _questions[2], _data.preocupacaoExcessiva, (v) => setState(() => _data.preocupacaoExcessiva = v)),
          _buildQuestionItem(3, _questions[3], _data.dificuldadeRelaxar, (v) => setState(() => _data.dificuldadeRelaxar = v)),
          _buildQuestionItem(4, _questions[4], _data.inquietacao, (v) => setState(() => _data.inquietacao = v)),
          _buildQuestionItem(5, _questions[5], _data.irritabilidade, (v) => setState(() => _data.irritabilidade = v)),
          _buildQuestionItem(6, _questions[6], _data.medo, (v) => setState(() => _data.medo = v)),

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
                const Text('GAD-7 SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const Text(
                  '/ 21',
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
        onPressed: _salvarGAD7,
        backgroundColor: Colors.purple,
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
    return Colors.red;
  }
}
