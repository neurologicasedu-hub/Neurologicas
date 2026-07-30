import 'package:flutter/material.dart';
import '../models/sf12_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class SF12Screen extends StatefulWidget {
  const SF12Screen({super.key});

  @override
  State<SF12Screen> createState() => _SF12ScreenState();
}

class _SF12ScreenState extends State<SF12Screen> {
  final SF12Data _data = SF12Data();

  final List<Map<String, dynamic>> _questions = [
    {'title': 'Em geral, você diria que sua saúde é:', 'field': 'saudeGeral', 'options': ['Excelente (5)', 'Muito boa (4)', 'Boa (3)', 'Regular (2)', 'Ruim (1)'], 'values': [5, 4, 3, 2, 1]},
    {'title': 'Suas atividades moderadas são limitadas por problemas físicos?', 'field': 'limitacaoAtividades', 'options': ['Muito limitado (1)', 'Um pouco limitado (2)', 'Nada limitado (3)'], 'values': [1, 2, 3]},
    {'title': 'Seu trabalho ou outras atividades diárias são limitadas por problemas físicos?', 'field': 'limitacaoTrabalho', 'options': ['Sim, limitado (1)', 'Não, não limitado (2)'], 'values': [1, 2]},
    {'title': 'Quanto dor corporal você teve nas últimas 4 semanas?', 'field': 'dorCorporal', 'options': ['Nenhuma (5)', 'Muito leve (4)', 'Leve (3)', 'Moderada (2)', 'Severa (1)'], 'values': [5, 4, 3, 2, 1]},
    {'title': 'Quanta energia você teve nas últimas 4 semanas?', 'field': 'energia', 'options': ['Nenhuma (1)', 'Muito pouca (2)', 'Pouca (3)', 'Alguma (4)', 'Bastante (5)', 'Muita (6)'], 'values': [1, 2, 3, 4, 5, 6]},
    {'title': 'Problemas físicos ou emocionais interferiram nas suas atividades sociais?', 'field': 'limitacaoSocial', 'options': ['Sim, interferiram muito (1)', 'Não, não interferiram (2)'], 'values': [1, 2]},
    {'title': 'Quanto você se preocupou com problemas emocionais nas últimas 4 semanas?', 'field': 'saudeEmocional', 'options': ['Nunca (5)', 'Raramente (4)', 'Às vezes (3)', 'Frequentemente (2)', 'Sempre (1)'], 'values': [5, 4, 3, 2, 1]},
    {'title': 'Problemas emocionais limitaram seu trabalho ou atividades?', 'field': 'limitacaoEmocional', 'options': ['Sim, limitaram muito (1)', 'Não, não limitaram (2)'], 'values': [1, 2]},
    {'title': 'Quanto tempo nas últimas 4 semanas você se sentiu calmo e tranquilo?', 'field': 'sentimentoCalmo', 'options': ['Nunca (1)', 'Raramente (2)', 'Às vezes (3)', 'Frequentemente (4)', 'Quase sempre (5)', 'Sempre (6)'], 'values': [1, 2, 3, 4, 5, 6]},
    {'title': 'Quanta energia você teve nas últimas 4 semanas? (Bem estar)', 'field': 'sentimentoBem', 'options': ['Nenhuma (1)', 'Muito pouca (2)', 'Pouca (3)', 'Alguma (4)', 'Bastante (5)', 'Muita (6)'], 'values': [1, 2, 3, 4, 5, 6]},
    {'title': 'Quanto dor interferiu no seu trabalho normal?', 'field': 'dorLimita', 'options': ['Nada (5)', 'Levemente (4)', 'Moderadamente (3)', 'Muito (2)', 'Extremamente (1)'], 'values': [5, 4, 3, 2, 1]},
    {'title': 'Quanto tempo nas últimas 4 semanas você se sentiu deprimido?', 'field': 'saudeMental', 'options': ['Nunca (6)', 'Quase nunca (5)', 'Às vezes (4)', 'Frequentemente (3)', 'Muito frequentemente (2)', 'Sempre (1)'], 'values': [6, 5, 4, 3, 2, 1]},
  ];

  Future<void> _salvarSF12() async {
    try {
      final score = CompletedScore(
        scoreName: 'SF-12 Health Survey',
        scoreData: {
          'saudeGeral': _data.saudeGeral,
          'limitacaoAtividades': _data.limitacaoAtividades,
          'limitacaoTrabalho': _data.limitacaoTrabalho,
          'dorCorporal': _data.dorCorporal,
          'energia': _data.energia,
          'limitacaoSocial': _data.limitacaoSocial,
          'saudeEmocional': _data.saudeEmocional,
          'limitacaoEmocional': _data.limitacaoEmocional,
          'saudeMental': _data.saudeMental,
          'dorLimita': _data.dorLimita,
          'sentimentoBem': _data.sentimentoBem,
          'sentimentoCalmo': _data.sentimentoCalmo,
        },
        resultado: '${_data.totalScore} pontos - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala SF-12 salva com sucesso!'),
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

  int _getValue(String field) {
    switch (field) {
      case 'saudeGeral': return _data.saudeGeral;
      case 'limitacaoAtividades': return _data.limitacaoAtividades;
      case 'limitacaoTrabalho': return _data.limitacaoTrabalho;
      case 'dorCorporal': return _data.dorCorporal;
      case 'energia': return _data.energia;
      case 'limitacaoSocial': return _data.limitacaoSocial;
      case 'saudeEmocional': return _data.saudeEmocional;
      case 'limitacaoEmocional': return _data.limitacaoEmocional;
      case 'saudeMental': return _data.saudeMental;
      case 'dorLimita': return _data.dorLimita;
      case 'sentimentoBem': return _data.sentimentoBem;
      case 'sentimentoCalmo': return _data.sentimentoCalmo;
      default: return 1;
    }
  }

  void _setValue(String field, int value) {
    switch (field) {
      case 'saudeGeral': setState(() => _data.saudeGeral = value); break;
      case 'limitacaoAtividades': setState(() => _data.limitacaoAtividades = value); break;
      case 'limitacaoTrabalho': setState(() => _data.limitacaoTrabalho = value); break;
      case 'dorCorporal': setState(() => _data.dorCorporal = value); break;
      case 'energia': setState(() => _data.energia = value); break;
      case 'limitacaoSocial': setState(() => _data.limitacaoSocial = value); break;
      case 'saudeEmocional': setState(() => _data.saudeEmocional = value); break;
      case 'limitacaoEmocional': setState(() => _data.limitacaoEmocional = value); break;
      case 'saudeMental': setState(() => _data.saudeMental = value); break;
      case 'dorLimita': setState(() => _data.dorLimita = value); break;
      case 'sentimentoBem': setState(() => _data.sentimentoBem = value); break;
      case 'sentimentoCalmo': setState(() => _data.sentimentoCalmo = value); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'SF-12',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Avaliação de qualidade de vida relacionada à saúde (12 itens).',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          ...List.generate(_questions.length, (i) => _buildQuestionItem(i, _questions[i], _getValue(_questions[i]['field'] as String), (v) => _setValue(_questions[i]['field'] as String, v))),

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
                const Text('SF-12 SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
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
        onPressed: _salvarSF12,
        backgroundColor: Colors.lime.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildQuestionItem(int index, Map<String, dynamic> question, int value, ValueChanged<int> onChanged) {
    final options = (question['options'] as List<String>).asMap().entries.map((entry) {
        final val = (question['values'] as List<int>)[entry.key];
        return QuestionOption<int>(label: entry.value, value: val);
    }).toList();

    return QuestionCard<int>(
      title: '${index + 1}. ${question['title']}',
      value: value,
      onChanged: onChanged,
      options: options,
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 39) return Colors.green;
    if (score >= 26) return Colors.orange;
    return Colors.red;
  }
}
