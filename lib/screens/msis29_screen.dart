import 'package:flutter/material.dart';
import '../models/msis29_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class MSIS29Screen extends StatefulWidget {
  const MSIS29Screen({super.key});

  @override
  State<MSIS29Screen> createState() => _MSIS29ScreenState();
}

class _MSIS29ScreenState extends State<MSIS29Screen> {
  final MSIS29Data _data = MSIS29Data();

  // Textos dos 20 itens físicos
  static const List<String> _itensFisicos = [
    'Nas últimas duas semanas, a esclerose múltipla limitou sua habilidade para realizar tarefas que exijam mais esforço físico?',
    'Nas últimas duas semanas, a esclerose múltipla limitou sua habilidade para segurar coisas com firmeza (ex.: abrir uma torneira)?',
    'Nas últimas duas semanas, a esclerose múltipla limitou sua habilidade para carregar coisas (ex.: sacola com objetos)?',
    'Nas últimas duas semanas, você se sentiu incomodado por problemas com equilíbrio?',
    'Nas últimas duas semanas, você se sentiu incomodado por dificuldades para se locomover em ambientes fechados (ex.: dentro de casa)?',
    'Nas últimas duas semanas, você se sentiu incomodado por ter atitudes desastradas (ex.: tropeçar, esbarrar em algo)?',
    'Nas últimas duas semanas, você se sentiu incomodado por sentir rigidez nas articulações (juntas)?',
    'Nas últimas duas semanas, você se sentiu incomodado por sentir os braços e/ou pernas pesados?',
    'Nas últimas duas semanas, você se sentiu incomodado por apresentar tremores nos braços ou pernas?',
    'Nas últimas duas semanas, você se sentiu incomodado por sentir espasmos (contração muscular) passageiros e sem controle nos membros do corpo?',
    'Nas últimas duas semanas, você se sentiu incomodado por sentir seu corpo não obedecer ao seu comando?',
    'Nas últimas duas semanas, a esclerose múltipla limitou sua habilidade porque você precisa depender de outras pessoas para fazer coisas por você?',
    'Nas últimas duas semanas, a esclerose múltipla limitou sua habilidade por limitações na sua vida social e em atividades de lazer em casa?',
    'Nas últimas duas semanas, a esclerose múltipla limitou sua habilidade fazendo você ficar em casa mais tempo do que gostaria?',
    'Nas últimas duas semanas, a esclerose múltipla limitou sua habilidade por sentir dificuldades em usar suas mãos durante atividades diárias (escrever, arrumar a casa)?',
    'Nas últimas duas semanas, a esclerose múltipla limitou sua habilidade por reduzir o tempo dedicado ao trabalho ou outras atividades diárias?',
    'Nas últimas duas semanas, a esclerose múltipla limitou sua habilidade por ter dificuldades em usar meios de transporte (exemplo: carro, ônibus)?',
    'Nas últimas duas semanas, a esclerose múltipla limitou sua habilidade por demorar mais tempo para fazer as coisas?',
    'Nas últimas duas semanas, a esclerose múltipla limitou sua habilidade por ter dificuldades para fazer coisas sem planejar (ex.: sair de repente)?',
    'Nas últimas duas semanas, a esclerose múltipla limitou sua habilidade por precisar ir ao banheiro com urgência?',
  ];

  // Textos dos 9 itens psicológicos
  static const List<String> _itensPsicologicos = [
    'Nas duas últimas semanas você se sentiu incomodado por sentir desânimo?',
    'Nas duas últimas semanas você se sentiu incomodado por ter problemas para dormir?',
    'Nas duas últimas semanas você se sentiu incomodado por sentir cansaço mental?',
    'Nas duas últimas semanas você se sentiu incomodado por ter preocupações a respeito da esclerose múltipla?',
    'Nas duas últimas semanas você se sentiu incomodado por se sentir ansioso(a) ou tenso(a)?',
    'Nas duas últimas semanas você se sentiu incomodado por se sentir irritado(a), impaciente ou de mau humor?',
    'Nas duas últimas semanas você se sentiu incomodado por ter problemas de concentração?',
    'Nas duas últimas semanas você se sentiu incomodado por falta de confiança em si mesmo?',
    'Nas duas últimas semanas você se sentiu incomodado por se sentir deprimido(a)?',
  ];

  Future<void> _salvarMSIS29() async {
    try {
      final score = CompletedScore(
        scoreName: 'MSIS-29 (Multiple Sclerosis Impact Scale)',
        scoreData: {
          'percentualTotal': _data.percentualTotal,
          'percentualFisico': _data.percentualFisico,
          'percentualPsicologico': _data.percentualPsicologico,
        },
        resultado: 'Total: ${_data.percentualTotal.toStringAsFixed(1)}% - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala MSIS-29 salva com sucesso!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ver Relatório',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/report');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSliderItem(String question, int value, ValueChanged<int> onChanged, int itemNumber) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$itemNumber. $question',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nada (1)', style: TextStyle(fontSize: 10)),
                Text('$value', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Text('Extremamente (5)', style: TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: value == 1 ? 'Nada' : value == 2 ? 'Um pouco' : value == 3 ? 'Moderadamente' : value == 4 ? 'Bastante' : 'Extremamente',
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.cyan,
            ),
            Text(
              value == 1 ? 'Nada' : value == 2 ? 'Um pouco' : value == 3 ? 'Moderadamente' : value == 4 ? 'Bastante' : 'Extremamente',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final percentual = _data.percentualTotal;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MSIS-29 - Multiple Sclerosis Impact Scale'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'MSIS-29 - Escala de Impacto da Esclerose Múltipla',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Avalie cada item de 1 (Nada) a 5 (Extremamente)',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('DOMÍNIO FÍSICO (${_data.fisico.length} itens)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              initiallyExpanded: true,
              children: [
                ...List.generate(_itensFisicos.length, (i) => _buildSliderItem(
                  _itensFisicos[i],
                  _data.fisico[i],
                  (val) => setState(() => _data.fisico[i] = val),
                  i + 1,
                )),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('DOMÍNIO PSICOLÓGICO (${_data.psicologico.length} itens)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              initiallyExpanded: true,
              children: [
                ...List.generate(_itensPsicologicos.length, (i) => _buildSliderItem(
                  _itensPsicologicos[i],
                  _data.psicologico[i],
                  (val) => setState(() => _data.psicologico[i] = val),
                  i + 21, // Itens 21-29
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: percentual <= 25 ? Colors.green : percentual <= 50 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('MSIS-29: ${percentual.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Físico: ${_data.percentualFisico.toStringAsFixed(1)}% | Psicológico: ${_data.percentualPsicologico.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarMSIS29();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala MSIS-29'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}