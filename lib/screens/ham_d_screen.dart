import 'package:flutter/material.dart';
import '../models/ham_d_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class HAMDScreen extends StatefulWidget {
  const HAMDScreen({super.key});

  @override
  State<HAMDScreen> createState() => _HAMDScreenState();
}

class _HAMDScreenState extends State<HAMDScreen> {
  final HAMDData _data = HAMDData();

  final List<Map<String, dynamic>> _items = [
    {'title': 'Humor Deprimido', 'max': 4, 'description': 'Tristeza, desesperança, impotência, inutilidade.'},
    {'title': 'Sentimento de Culpa', 'max': 4, 'description': 'Auto-reprovação, culpa patológica.'},
    {'title': 'Suicídio', 'max': 4, 'description': 'Pensamentos de morte ou suicídio.'},
    {'title': 'Insônia Inicial', 'max': 2, 'description': 'Dificuldade em adormecer.'},
    {'title': 'Insônia do Meio', 'max': 2, 'description': 'Sono inquieto ou despertar noturno.'},
    {'title': 'Insônia Final', 'max': 2, 'description': 'Despertar matinal precoce.'},
    {'title': 'Trabalho e Atividades', 'max': 4, 'description': 'Perda de interesse ou fadiga no trabalho/lazer.'},
    {'title': 'Retardo Psicomotor', 'max': 4, 'description': 'Lentidão de pensamento e fala; dificuldade de concentração.'},
    {'title': 'Agitação', 'max': 4, 'description': 'Inquietação motora.'},
    {'title': 'Ansiedade Psíquica', 'max': 4, 'description': 'Tensão, irritabilidade, preocupação.'},
    {'title': 'Ansiedade Somática', 'max': 4, 'description': 'Sintomas físicos da ansiedade (GI, CV, etc).'},
    {'title': 'Sintomas Somáticos GI', 'max': 2, 'description': 'Perda de apetite, constipação.'},
    {'title': 'Sintomas Somáticos Gerais', 'max': 2, 'description': 'Fadiga, dores musculares, peso.'},
    {'title': 'Sintomas Genitais', 'max': 2, 'description': 'Perda de libido, distúrbios menstruais.'},
    {'title': 'Hipocondria', 'max': 4, 'description': 'Preocupação excessiva com a saúde.'},
    {'title': 'Perda de Peso', 'max': 2, 'description': 'Perda de peso evidente.'},
    {'title': 'Insight', 'max': 2, 'description': 'Consciência da doença.'},
  ];

  Future<void> _salvarHAMD() async {
    try {
      final score = CompletedScore(
        scoreName: 'Hamilton Depression Rating Scale (HAM-D)',
        scoreData: {
          'humorDeprimido': _data.humorDeprimido,
          'sentimentoCulpa': _data.sentimentoCulpa,
          'suicidio': _data.suicidio,
          'insoniaInicial': _data.insoniaInicial,
          'insoniaMeio': _data.insoniaMeio,
          'insoniaFinal': _data.insoniaFinal,
          'trabalhoAtividades': _data.trabalhoAtividades,
          'retardoPsicomotor': _data.retardoPsicomotor,
          'agitacao': _data.agitacao,
          'ansiedadePsiquica': _data.ansiedadePsiquica,
          'ansiedadeSomatica': _data.ansiedadeSomatica,
          'sintomasSomaticosGI': _data.sintomasSomaticosGI,
          'sintomasSomaticosGerais': _data.sintomasSomaticosGerais,
          'sintomasGenitais': _data.sintomasGenitais,
          'hipocondria': _data.hipocondria,
          'perdaPeso': _data.perdaPeso,
          'insight': _data.insight,
        },
        resultado: '${_data.totalScore}/52 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala HAM-D salva com sucesso!'),
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
      title: 'HAM-D (Hamilton)',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Avaliação clínica de 17 itens para depressão.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          _buildItem(0, _items[0], _data.humorDeprimido, (v) => setState(() => _data.humorDeprimido = v)),
          _buildItem(1, _items[1], _data.sentimentoCulpa, (v) => setState(() => _data.sentimentoCulpa = v)),
          _buildItem(2, _items[2], _data.suicidio, (v) => setState(() => _data.suicidio = v)),
          _buildItem(3, _items[3], _data.insoniaInicial, (v) => setState(() => _data.insoniaInicial = v)),
          _buildItem(4, _items[4], _data.insoniaMeio, (v) => setState(() => _data.insoniaMeio = v)),
          _buildItem(5, _items[5], _data.insoniaFinal, (v) => setState(() => _data.insoniaFinal = v)),
          _buildItem(6, _items[6], _data.trabalhoAtividades, (v) => setState(() => _data.trabalhoAtividades = v)),
          _buildItem(7, _items[7], _data.retardoPsicomotor, (v) => setState(() => _data.retardoPsicomotor = v)),
          _buildItem(8, _items[8], _data.agitacao, (v) => setState(() => _data.agitacao = v)),
          _buildItem(9, _items[9], _data.ansiedadePsiquica, (v) => setState(() => _data.ansiedadePsiquica = v)),
          _buildItem(10, _items[10], _data.ansiedadeSomatica, (v) => setState(() => _data.ansiedadeSomatica = v)),
          _buildItem(11, _items[11], _data.sintomasSomaticosGI, (v) => setState(() => _data.sintomasSomaticosGI = v)),
          _buildItem(12, _items[12], _data.sintomasSomaticosGerais, (v) => setState(() => _data.sintomasSomaticosGerais = v)),
          _buildItem(13, _items[13], _data.sintomasGenitais, (v) => setState(() => _data.sintomasGenitais = v)),
          _buildItem(14, _items[14], _data.hipocondria, (v) => setState(() => _data.hipocondria = v)),
          _buildItem(15, _items[15], _data.perdaPeso, (v) => setState(() => _data.perdaPeso = v)),
          _buildItem(16, _items[16], _data.insight, (v) => setState(() => _data.insight = v)),

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
                const Text('HAM-D SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const Text(
                  '/ 52',
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
        onPressed: _salvarHAMD,
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildItem(int index, Map<String, dynamic> item, int value, ValueChanged<int> onChanged) {
    // Determine options based on max score (2 or 4)
    List<QuestionOption<int>> options;
    if (item['max'] == 2) {
      options = [
        const QuestionOption(label: '0 - Ausente', value: 0),
        const QuestionOption(label: '1 - Leve/Provável', value: 1),
        const QuestionOption(label: '2 - Grave/Definitivo', value: 2),
      ];
    } else {
      options = [
        const QuestionOption(label: '0 - Ausente', value: 0),
        const QuestionOption(label: '1 - Leve', value: 1),
        const QuestionOption(label: '2 - Moderado', value: 2),
        const QuestionOption(label: '3 - Grave', value: 3),
        const QuestionOption(label: '4 - Muito Grave/Incapacitante', value: 4),
      ];
    }

    return QuestionCard<int>(
      title: '${index + 1}. ${item['title']}',
      subtitle: item['description'],
      value: value,
      onChanged: onChanged,
      options: options,
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 7) return Colors.green;
    if (score <= 17) return Colors.lightGreen;
    if (score <= 24) return Colors.orange;
    return Colors.red;
  }
}
