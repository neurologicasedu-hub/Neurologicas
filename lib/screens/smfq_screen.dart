import 'package:flutter/material.dart';
import '../models/smfq_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class SMFQScreen extends StatefulWidget {
  const SMFQScreen({super.key});

  @override
  State<SMFQScreen> createState() => _SMFQScreenState();
}

class _SMFQScreenState extends State<SMFQScreen> {
  final SMFQData _data = SMFQData();

  final List<String> _questions = [
    'Eu senti que não tinha valor',
    'Eu senti que estava triste',
    'Eu senti que não conseguia fazer nada direito',
    'Eu senti que estava cansado o tempo todo',
    'Eu senti que o que eu fiz foi um erro',
    'Eu senti que não tinha interesse em nada',
    'Eu senti que estava preguiçoso',
    'Eu senti que as coisas não iriam funcionar para mim',
    'Eu senti que estava infeliz',
    'Eu senti que as pessoas não gostavam de mim',
    'Eu senti que não conseguia me divertir',
    'Eu senti que estava muito quieto',
    'Eu senti que era um péssimo aluno',
  ];

  final List<String> _options = ['Não é verdadeiro (0)', 'Às vezes (1)', 'Verdadeiro (2)'];

  Future<void> _salvarSMFQ() async {
    try {
      final score = CompletedScore(
        scoreName: 'Short Mood and Feelings Questionnaire (SMFQ)',
        scoreData: {'respostas': _data.respostas},
        resultado: '${_data.totalScore}/26 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala SMFQ salva com sucesso!'),
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

  Widget _buildQuestionItem(int index, String question, int value, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index + 1}. $question', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _options.asMap().entries.map((entry) {
                final isSelected = value == entry.key;
                return ChoiceChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  selectedColor: Colors.pink.shade100,
                  onSelected: (selected) {
                    if (selected) onChanged(entry.key);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'SMFQ',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Short Mood and Feelings Questionnaire\nPara crianças e adolescentes - Como você se sentiu nas últimas 2 semanas?',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          ...List.generate(13, (i) => _buildQuestionItem(i, _questions[i], _data.respostas[i], (v) => setState(() => _data.respostas[i] = v))),
          
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 7 ? Colors.green : score <= 11 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 7 ? Colors.green : score <= 11 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('SMFQ Score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$score', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 12),
                Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarSMFQ,
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
