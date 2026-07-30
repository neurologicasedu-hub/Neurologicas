import 'package:flutter/material.dart';
import '../models/vas_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class VASScreen extends StatefulWidget {
  const VASScreen({super.key});

  @override
  State<VASScreen> createState() => _VASScreenState();
}

class _VASScreenState extends State<VASScreen> {
  final VASData _data = VASData();

  Future<void> _salvarVAS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Visual Analog Scale (VAS) - Dor',
        scoreData: {'intensidadeDor': _data.intensidadeDor},
        resultado: '${_data.intensidadeDor}/10 - ${_data.interpretation}',
        totalScore: _data.intensidadeDor,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala VAS salva com sucesso!'),
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
    final score = _data.intensidadeDor;
    return CalculatorScaffold(
      title: 'VAS - Escala Visual Analógica',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Text(
              'Deslize para indicar a intensidade da sua dor',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: const [
                       Text('Sem Dor', style: TextStyle(color: Colors.green)),
                       Text('Pior Dor', style: TextStyle(color: Colors.red)),
                     ],
                   ),
                   const SizedBox(height: 16),
                   SliderTheme(
                     data: SliderTheme.of(context).copyWith(
                       trackHeight: 12,
                       thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
                       overlayShape: const RoundSliderOverlayShape(overlayRadius: 28),
                       activeTrackColor: _getColor(score),
                       inactiveTrackColor: Colors.grey.shade200,
                       thumbColor: _getColor(score),
                     ),
                     child: Slider(
                       value: score.toDouble(),
                       min: 0,
                       max: 10,
                       divisions: 10,
                       label: '$score',
                       onChanged: (val) => setState(() => _data.intensidadeDor = val.toInt()),
                     ),
                   ),
                   const SizedBox(height: 16),
                   Text(
                     '$score / 10',
                     style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _getColor(score)),
                   ),
                   const SizedBox(height: 8),
                   Text(
                     _data.interpretation,
                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: _getColor(score)),
                     textAlign: TextAlign.center,
                   ),
                ],
              ),
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarVAS,
        backgroundColor: _getColor(score),
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
  
  Color _getColor(int score) {
    if (score == 0) return Colors.green.shade700;
    if (score <= 3) return Colors.lightGreen.shade700;
    if (score <= 6) return Colors.orange;
    if (score <= 8) return Colors.deepOrange;
    return Colors.red;
  }
}
