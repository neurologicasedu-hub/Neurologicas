import 'package:flutter/material.dart';
import '../models/fss_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class FSSScreen extends StatefulWidget {
  const FSSScreen({super.key});

  @override
  State<FSSScreen> createState() => _FSSScreenState();
}

class _FSSScreenState extends State<FSSScreen> {
  final FSSData _data = FSSData();

  Future<void> _salvarFSS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Fatigue Severity Scale (FSS)',
        scoreData: {
          'item1': _data.item1,
          'item2': _data.item2,
          'item3': _data.item3,
          'item4': _data.item4,
          'item5': _data.item5,
          'item6': _data.item6,
          'item7': _data.item7,
          'item8': _data.item8,
          'item9': _data.item9,
        },
        resultado: 'Score médio: ${_data.averageScore.toStringAsFixed(2)} - ${_data.interpretation}',
        totalScore: (_data.averageScore * 10).round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala FSS salva com sucesso!'),
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

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Discordo totalmente (1)', style: TextStyle(fontSize: 11)),
                Text('$value', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Text('Concordo totalmente (7)', style: TextStyle(fontSize: 11)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avgScore = _data.averageScore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fatigue Severity Scale (FSS)'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Fatigue Severity Scale',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Avalie cada afirmação de 1 (Discordo totalmente) a 7 (Concordo totalmente)',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildSliderItem('1. Minha motivação é menor quando estou fatigado', _data.item1, (val) => setState(() => _data.item1 = val)),
          _buildSliderItem('2. O exercício produz sensação de fadiga', _data.item2, (val) => setState(() => _data.item2 = val)),
          _buildSliderItem('3. Eu me sinto facilmente fatigado', _data.item3, (val) => setState(() => _data.item3 = val)),
          _buildSliderItem('4. A fadiga interfere com meu funcionamento físico', _data.item4, (val) => setState(() => _data.item4 = val)),
          _buildSliderItem('5. A fadiga causa frequentes problemas para mim', _data.item5, (val) => setState(() => _data.item5 = val)),
          _buildSliderItem('6. Minha fadiga impede o desempenho de certas tarefas físicas', _data.item6, (val) => setState(() => _data.item6 = val)),
          _buildSliderItem('7. A fadiga interfere com a realização de certas responsabilidades', _data.item7, (val) => setState(() => _data.item7 = val)),
          _buildSliderItem('8. A fadiga está entre meus três sintomas mais incapacitantes', _data.item8, (val) => setState(() => _data.item8 = val)),
          _buildSliderItem('9. A fadiga interfere com meu trabalho, família ou vida social', _data.item9, (val) => setState(() => _data.item9 = val)),
          const SizedBox(height: 16),
          Card(
            color: avgScore >= 4.0 ? Colors.red : avgScore >= 3.0 ? Colors.orange : Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Score Médio FSS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('${avgScore.toStringAsFixed(2)}/7.0', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarFSS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala FSS'),
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
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
