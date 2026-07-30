import 'package:flutter/material.dart';
import '../models/fss_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

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
              onPressed: () => Navigator.pushReplacementNamed(context, '/report'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(title, style: const TextStyle(fontSize: 14)),
           const SizedBox(height: 4),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               const Text('Discordo (1)', style: TextStyle(fontSize: 11, color: Colors.grey)),
               Text('$value', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
               const Text('Concordo (7)', style: TextStyle(fontSize: 11, color: Colors.grey)),
             ],
           ),
           SliderTheme(
             data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.orange, thumbColor: Colors.orange),
             child: Slider(
               value: value.toDouble(),
               min: 1, max: 7, divisions: 6,
               onChanged: (val) => onChanged(val.toInt()),
             ),
           ),
           const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avgScore = _data.averageScore;
    return CalculatorScaffold(
      title: 'FSS - Fatigue Severity Scale',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Avalie de 1 (Discordo) a 7 (Concordo)',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSliderItem('1. Minha motivação é menor quando estou fatigado', _data.item1, (val) => setState(() => _data.item1 = val)),
                  _buildSliderItem('2. O exercício produz sensação de fadiga', _data.item2, (val) => setState(() => _data.item2 = val)),
                  _buildSliderItem('3. Eu me sinto facilmente fatigado', _data.item3, (val) => setState(() => _data.item3 = val)),
                  _buildSliderItem('4. A fadiga interfere com meu funcionamento físico', _data.item4, (val) => setState(() => _data.item4 = val)),
                  _buildSliderItem('5. A fadiga causa frequentes problemas para mim', _data.item5, (val) => setState(() => _data.item5 = val)),
                  _buildSliderItem('6. Minha fadiga impede o desempenho de certas tarefas físicas', _data.item6, (val) => setState(() => _data.item6 = val)),
                  _buildSliderItem('7. A fadiga interfere com a realização de certas responsabilidades', _data.item7, (val) => setState(() => _data.item7 = val)),
                  _buildSliderItem('8. A fadiga está entre meus três sintomas mais incapacitantes', _data.item8, (val) => setState(() => _data.item8 = val)),
                  _buildSliderItem('9. A fadiga interfere com meu trabalho, família ou vida social', _data.item9, (val) => setState(() => _data.item9 = val)),
                ],
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: avgScore >= 4.0 ? Colors.red : avgScore >= 3.0 ? Colors.orange : Colors.green,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (avgScore >= 4.0 ? Colors.red : avgScore >= 3.0 ? Colors.orange : Colors.green).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('FSS SCORE MÉDIO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                 const SizedBox(height: 8),
                Text(avgScore.toStringAsFixed(2), style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 12),
                Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarFSS,
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
