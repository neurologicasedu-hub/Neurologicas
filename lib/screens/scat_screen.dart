import 'package:flutter/material.dart';
import '../models/scat_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class SCATScreen extends StatefulWidget {
  const SCATScreen({super.key});

  @override
  State<SCATScreen> createState() => _SCATScreenState();
}

class _SCATScreenState extends State<SCATScreen> {
  final SCATData _data = SCATData();

  Future<void> _salvarSCAT() async {
    try {
      final score = CompletedScore(
        scoreName: 'SCAT - Sport Concussion Assessment Tool',
        scoreData: {
          'sintomasSeveridade': _data.sintomasSeveridade,
          'orientacao': _data.orientacao,
          'memoriaImediata': _data.memoriaImediata,
          'concentracao': _data.concentracao,
          'equilibrio': _data.equilibrio,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala SCAT salva com sucesso!'),
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
  final List<String> _sintomas = [
    'Cefaleia', 'Náusea', 'Vômito', 'Tontura', 'Fadiga', 'Sensibilidade à luz',
    'Sensibilidade ao som', 'Irritabilidade', 'Nervosismo', 'Confusão',
    'Dificuldade de concentração', 'Dificuldade de memória',
  ];
  final List<int> _sintomasValores = List.filled(12, 0);

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    final interpretacao = _data.interpretacao;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SCAT - Sport Concussion Assessment Tool'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Avaliação de Concussão Esportiva',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text('Sintomas (0-6 cada)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ...List.generate(_sintomas.length, (index) {
            return _buildSliderItem(_sintomas[index], _sintomasValores[index], (val) {
              setState(() {
                _sintomasValores[index] = val;
                _data.sintomasSeveridade = _sintomasValores.reduce((a, b) => a + b);
              });
            });
          }),
          const SizedBox(height: 12),
          const Text('Orientação (0-5)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('Orientação', _data.orientacao, (val) => setState(() => _data.orientacao = val), max: 5),
          const Text('Memória Imediata (0-5)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('Memória Imediata', _data.memoriaImediata, (val) => setState(() => _data.memoriaImediata = val), max: 5),
          const Text('Concentração (0-5)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('Concentração', _data.concentracao, (val) => setState(() => _data.concentracao = val), max: 5),
          const Text('Equilíbrio (0-3)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('Equilíbrio', _data.equilibrio, (val) => setState(() => _data.equilibrio = val), max: 3),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(score),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Pontuação Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarSCAT();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala SCAT'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged, {int max = 6}) {
    String getSeverityLabel(int val) {
      if (max == 6) {
        if (val == 0) return 'Nenhum sintoma';
        if (val <= 2) return 'Sintoma leve';
        if (val <= 4) return 'Sintoma moderado';
        return 'Sintoma severo';
      }
      return '$val';
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
                Text('$value/$max', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            if (max == 6) ...[
              const SizedBox(height: 4),
              Text(
                getSeverityLabel(value),
                style: TextStyle(
                  fontSize: 11,
                  color: value == 0 ? Colors.green : value <= 2 ? Colors.lightGreen : value <= 4 ? Colors.orange : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '0: Nenhum | 1-2: Leve | 3-4: Moderado | 5-6: Severo',
                style: TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ],
            Slider(
              value: value.toDouble(),
              min: 0,
              max: max.toDouble(),
              divisions: max,
              label: getSeverityLabel(value),
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.lightBlue,
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 20) return Colors.green;
    if (score >= 15) return Colors.lightGreen;
    if (score >= 10) return Colors.orange;
    return Colors.red;
  }
}

