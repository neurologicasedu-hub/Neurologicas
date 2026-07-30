import 'package:flutter/material.dart';
import '../models/hdi_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

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

  final List<String> _options = ['Não (0)', 'Às vezes (2)', 'Sim (4)'];
  final List<int> _optionValues = [0, 2, 4];

  Future<void> _salvarHDI() async {
    try {
      final score = CompletedScore(
        scoreName: 'Headache Disability Inventory (HDI)',
        scoreData: {'respostas': _data.respostas},
        resultado: '${_data.totalScore}/100 - ${_data.interpretation} (E: ${_data.scoreEmocional}, F: ${_data.scoreFuncional})',
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

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'HDI',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Headache Disability Inventory\nAvalie o impacto da cefaleia (25 itens)',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          ...List.generate(_questions.length, (index) {
             final int val = _data.respostas[index];
             final String currentLabel = _options[_optionValues.indexOf(val)];
             return QuestionCard<String>(
              title: '${index + 1}. ${_questions[index]}',
              options: _options.map((e) => QuestionOption(label: e, value: e)).toList(),
              value: currentLabel,
              onChanged: (v) {
                final int newVal = _optionValues[_options.indexOf(v)];
                setState(() => _data.respostas[index] = newVal);
              },
            );
          }),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 29 ? Colors.green : score <= 59 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 29 ? Colors.green : score <= 59 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('HDI SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$score', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 8),
                Text('Funcional: ${_data.scoreFuncional}  Emocional: ${_data.scoreEmocional}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 12),
                Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarHDI,
        backgroundColor: Colors.brown,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
