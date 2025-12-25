import 'package:flutter/material.dart';
import '../models/hit6_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

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

  final List<String> _options = ['Nunca (6)', 'Raramente (8)', 'Às vezes (10)', 'Muito frequentemente (11)', 'Sempre (13)'];
  final List<int> _optionValues = [6, 8, 10, 11, 13];

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
              value: _optionValues[entry.key],
              groupValue: value,
              onChanged: (val) => onChanged(val ?? 6),
              activeColor: Colors.amber,
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
        title: const Text('HIT-6'),
        centerTitle: true,
        backgroundColor: Colors.amber.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'HIT-6 - Headache Impact Test\nNas últimas 4 semanas, com que frequência você teve os seguintes problemas?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildQuestionItem(0, _questions[0], _data.dorSevera, (v) => setState(() => _data.dorSevera = v)),
          _buildQuestionItem(1, _questions[1], _data.limitaAtividades, (v) => setState(() => _data.limitaAtividades = v)),
          _buildQuestionItem(2, _questions[2], _data.desejaDescansar, (v) => setState(() => _data.desejaDescansar = v)),
          _buildQuestionItem(3, _questions[3], _data.cansaco, (v) => setState(() => _data.cansaco = v)),
          _buildQuestionItem(4, _questions[4], _data.irritado, (v) => setState(() => _data.irritado = v)),
          _buildQuestionItem(5, _questions[5], _data.dificuldadeConcentrar, (v) => setState(() => _data.dificuldadeConcentrar = v)),
          const SizedBox(height: 16),
          Card(
            color: score <= 49 ? Colors.green : score <= 55 ? Colors.lightGreen : score <= 59 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('HIT-6 Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/78', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarHIT6,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala HIT-6'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

