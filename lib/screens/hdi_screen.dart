import 'package:flutter/material.dart';
import '../models/hdi_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class HDIScreen extends StatefulWidget {
  const HDIScreen({super.key});

  @override
  State<HDIScreen> createState() => _HDIScreenState();
}

class _HDIScreenState extends State<HDIScreen> {
  final HDIData _data = HDIData();

  final List<String> _questions = [
    'Por causa da minha dor de cabeça, eu limito minhas atividades quando tenho dor',
    'Por causa da minha dor de cabeça, eu fico frustrado(a)',
    'Por causa da minha dor de cabeça, eu não consigo trabalhar em casa',
    'Por causa da minha dor de cabeça, eu tenho medo de deixar pessoas importantes na minha vida para baixo',
    'Por causa da minha dor de cabeça, eu não consigo fazer meu trabalho de casa normalmente',
    'Por causa da minha dor de cabeça, eu me sinto incapacitado(a)',
    'Por causa da minha dor de cabeça, eu me sinto sem esperança',
    'Por causa da minha dor de cabeça, eu tenho medo de fazer planos',
    'Por causa da minha dor de cabeça, eu sinto que sou um fardo para a família',
    'Por causa da minha dor de cabeça, eu me sinto embaraçado(a)',
    'Por causa da minha dor de cabeça, eu me sinto frustrado(a)',
    'Por causa da minha dor de cabeça, eu me sinto irritado(a)',
    'Por causa da minha dor de cabeça, eu não consigo me concentrar',
    'Por causa da minha dor de cabeça, eu não consigo dormir o suficiente',
    'Por causa da minha dor de cabeça, eu não consigo ler como normalmente faria',
    'Por causa da minha dor de cabeça, eu não consigo focar bem',
    'Por causa da minha dor de cabeça, eu não consigo exercitar como normalmente faria',
    'Por causa da minha dor de cabeça, eu não consigo trabalhar no meu emprego ou profissão normalmente',
    'Por causa da minha dor de cabeça, eu não consigo participar de atividades recreativas normalmente',
    'Por causa da minha dor de cabeça, eu não consigo fazer atividades sociais normalmente',
    'Por causa da minha dor de cabeça, eu não consigo fazer tarefas domésticas normalmente',
    'Por causa da minha dor de cabeça, eu não consigo fazer atividades não essenciais normalmente',
    'Por causa da minha dor de cabeça, eu não consigo cuidar de mim mesmo(a) normalmente',
    'Por causa da minha dor de cabeça, eu não consigo cuidar de outros normalmente',
    'Por causa da minha dor de cabeça, eu não consigo fazer tarefas relacionadas ao trabalho normalmente',
  ];

  final List<String> _options = ['Sim (4 pontos)', 'Às vezes (2 pontos)', 'Não (0 pontos)'];
  final List<int> _optionValues = [4, 2, 0];

  Future<void> _salvarHDI() async {
    try {
      final score = CompletedScore(
        scoreName: 'Headache Disability Inventory (HDI)',
        scoreData: {'respostas': _data.respostas},
        resultado: '${_data.totalScore}/100 - ${_data.interpretation} (Emocional: ${_data.scoreEmocional}/52, Funcional: ${_data.scoreFuncional}/48)',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala HDI salva com sucesso!'),
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
              onChanged: (val) => onChanged(val ?? 0),
              activeColor: Colors.brown,
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
        title: const Text('HDI'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'HDI - Headache Disability Inventory\nAvalia o impacto da cefaleia na vida diária (25 itens)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ...List.generate(25, (i) => _buildQuestionItem(i, _questions[i], _data.respostas[i], (v) => setState(() => _data.respostas[i] = v))),
          const SizedBox(height: 16),
          Card(
            color: score <= 24 ? Colors.green : score <= 49 ? Colors.lightGreen : score <= 74 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('HDI Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/100', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Emocional: ${_data.scoreEmocional}/52', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  Text('Funcional: ${_data.scoreFuncional}/48', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarHDI,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala HDI'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

