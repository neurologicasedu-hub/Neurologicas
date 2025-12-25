import 'package:flutter/material.dart';
import '../models/smfq_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

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
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index + 1}. $question', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._options.asMap().entries.map((entry) => RadioListTile<int>(
              title: Text(entry.value, style: const TextStyle(fontSize: 12)),
              value: entry.key,
              groupValue: value,
              onChanged: (val) => onChanged(val ?? 0),
              activeColor: Colors.pink,
              dense: true,
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMFQ'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'SMFQ - Short Mood and Feelings Questionnaire\nPara crianças e adolescentes - Como você se sentiu nas últimas 2 semanas?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ...List.generate(13, (i) => _buildQuestionItem(i, _questions[i], _data.respostas[i], (v) => setState(() => _data.respostas[i] = v))),
          const SizedBox(height: 16),
          Card(
            color: score <= 7 ? Colors.green : score <= 11 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('SMFQ Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/26', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarSMFQ,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala SMFQ'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

