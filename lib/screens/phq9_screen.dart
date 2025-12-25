import 'package:flutter/material.dart';
import '../models/phq9_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

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
    'Mover ou falar tão devagar que os outros perceberam. Ou o contrário - estar tão inquieto(a) ou agitado(a) que tem ficado andando de um lado para o outro muito mais que o normal',
    'Pensamentos de que seria melhor estar morto(a) ou de machucar a si mesmo(a) de alguma forma',
  ];

  final List<String> _options = ['Não de jeito nenhum (0)', 'Vários dias (1)', 'Mais da metade dos dias (2)', 'Quase todos os dias (3)'];

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
              activeColor: Colors.blue,
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
        title: const Text('PHQ-9'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'PHQ-9 - Patient Health Questionnaire\nNas últimas 2 semanas, com que frequência você foi incomodado(a) pelos seguintes problemas?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildQuestionItem(0, _questions[0], _data.interesse, (v) => setState(() => _data.interesse = v)),
          _buildQuestionItem(1, _questions[1], _data.tristeza, (v) => setState(() => _data.tristeza = v)),
          _buildQuestionItem(2, _questions[2], _data.sono, (v) => setState(() => _data.sono = v)),
          _buildQuestionItem(3, _questions[3], _data.energia, (v) => setState(() => _data.energia = v)),
          _buildQuestionItem(4, _questions[4], _data.apetite, (v) => setState(() => _data.apetite = v)),
          _buildQuestionItem(5, _questions[5], _data.autoestima, (v) => setState(() => _data.autoestima = v)),
          _buildQuestionItem(6, _questions[6], _data.concentracao, (v) => setState(() => _data.concentracao = v)),
          _buildQuestionItem(7, _questions[7], _data.velocidade, (v) => setState(() => _data.velocidade = v)),
          _buildQuestionItem(8, _questions[8], _data.suicidio, (v) => setState(() => _data.suicidio = v)),
          const SizedBox(height: 16),
          Card(
            color: score <= 4 ? Colors.green : score <= 9 ? Colors.lightGreen : score <= 14 ? Colors.orange : score <= 19 ? Colors.deepOrange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('PHQ-9 Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/27', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarPHQ9,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala PHQ-9'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

