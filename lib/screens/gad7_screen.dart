import 'package:flutter/material.dart';
import '../models/gad7_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

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

  final List<String> _options = ['Nunca (0)', 'Vários dias (1)', 'Mais da metade dos dias (2)', 'Quase todos os dias (3)'];

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
              activeColor: Colors.purple,
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
        title: const Text('GAD-7'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'GAD-7 - Generalized Anxiety Disorder-7\nNas últimas 2 semanas, com que frequência você foi incomodado(a) pelos seguintes problemas?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildQuestionItem(0, _questions[0], _data.nervosismo, (v) => setState(() => _data.nervosismo = v)),
          _buildQuestionItem(1, _questions[1], _data.controlePreocupacao, (v) => setState(() => _data.controlePreocupacao = v)),
          _buildQuestionItem(2, _questions[2], _data.preocupacaoExcessiva, (v) => setState(() => _data.preocupacaoExcessiva = v)),
          _buildQuestionItem(3, _questions[3], _data.dificuldadeRelaxar, (v) => setState(() => _data.dificuldadeRelaxar = v)),
          _buildQuestionItem(4, _questions[4], _data.inquietacao, (v) => setState(() => _data.inquietacao = v)),
          _buildQuestionItem(5, _questions[5], _data.irritabilidade, (v) => setState(() => _data.irritabilidade = v)),
          _buildQuestionItem(6, _questions[6], _data.medo, (v) => setState(() => _data.medo = v)),
          const SizedBox(height: 16),
          Card(
            color: score <= 4 ? Colors.green : score <= 9 ? Colors.lightGreen : score <= 14 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('GAD-7 Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/21', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarGAD7,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala GAD-7'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

