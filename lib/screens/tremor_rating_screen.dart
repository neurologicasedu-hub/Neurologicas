import 'package:flutter/material.dart';
import '../models/tremor_rating_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class TremorRatingScreen extends StatefulWidget {
  const TremorRatingScreen({super.key});

  @override
  State<TremorRatingScreen> createState() => _TremorRatingScreenState();
}

class _TremorRatingScreenState extends State<TremorRatingScreen> {
  final TremorRatingData _data = TremorRatingData();

  Future<void> _salvarTremor() async {
    try {
      final score = CompletedScore(
        scoreName: 'Tremor Rating Scale',
        scoreData: {
          'restingTremorScore': _data.restingTremorScore,
          'posturalTremorScore': _data.posturalTremorScore,
          'kineticTremorScore': _data.kineticTremorScore,
        },
        resultado: 'Total: ${_data.totalScore} - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Tremor Rating salva com sucesso!'),
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
                const Text('0', style: TextStyle(fontSize: 11)),
                Text('$value/4', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Text('4', style: TextStyle(fontSize: 11)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.brown,
            ),
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
        title: const Text('Tremor Rating Scale'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tremor Rating Scale - Avaliação de Tremor',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text('Tremor de Repouso (0-4 cada)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('Face', _data.restingFace, (val) => setState(() => _data.restingFace = val)),
          _buildSliderItem('Mandíbula', _data.restingJaw, (val) => setState(() => _data.restingJaw = val)),
          _buildSliderItem('Língua', _data.restingTongue, (val) => setState(() => _data.restingTongue = val)),
          _buildSliderItem('Braço Esquerdo', _data.restingLeftArm, (val) => setState(() => _data.restingLeftArm = val)),
          _buildSliderItem('Braço Direito', _data.restingRightArm, (val) => setState(() => _data.restingRightArm = val)),
          _buildSliderItem('Perna Esquerda', _data.restingLeftLeg, (val) => setState(() => _data.restingLeftLeg = val)),
          _buildSliderItem('Perna Direita', _data.restingRightLeg, (val) => setState(() => _data.restingRightLeg = val)),
          const SizedBox(height: 8),
          const Text('Tremor Postural (0-4 cada)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('Braço Esquerdo', _data.posturalLeftArm, (val) => setState(() => _data.posturalLeftArm = val)),
          _buildSliderItem('Braço Direito', _data.posturalRightArm, (val) => setState(() => _data.posturalRightArm = val)),
          const SizedBox(height: 8),
          const Text('Tremor Cinético (0-4 cada)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('Braço Esquerdo', _data.kineticLeftArm, (val) => setState(() => _data.kineticLeftArm = val)),
          _buildSliderItem('Braço Direito', _data.kineticRightArm, (val) => setState(() => _data.kineticRightArm = val)),
          const SizedBox(height: 8),
          const Text('Outros (0-4 cada)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('Escrita', _data.handwriting, (val) => setState(() => _data.handwriting = val)),
          _buildSliderItem('Atividades de Vida Diária', _data.atividadesVidaDiaria, (val) => setState(() => _data.atividadesVidaDiaria = val)),
          const SizedBox(height: 16),
          Card(
            color: score <= 10 ? Colors.green : score <= 25 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Total: $score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Repouso: ${_data.restingTremorScore} | Postural: ${_data.posturalTremorScore} | Cinético: ${_data.kineticTremorScore}', style: const TextStyle(fontSize: 12, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarTremor();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Tremor Rating'),
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
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
