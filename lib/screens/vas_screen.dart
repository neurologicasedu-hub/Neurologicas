import 'package:flutter/material.dart';
import '../models/vas_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visual Analog Scale (VAS) - Dor'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'VAS - Visual Analog Scale para Dor\nDeslize para indicar a intensidade da sua dor',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sem dor', style: TextStyle(fontSize: 12)),
                      Text(
                        '$score/10',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Text('Pior dor\nimaginável', style: TextStyle(fontSize: 12), textAlign: TextAlign.right),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: score.toDouble(),
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: '$score',
                    onChanged: (val) => setState(() => _data.intensidadeDor = val.toInt()),
                    activeColor: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: score == 0 ? Colors.green.shade50 : score <= 3 ? Colors.lightGreen.shade50 : score <= 6 ? Colors.orange.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Intensidade da Dor',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: score == 0 ? Colors.green.shade900 : score <= 3 ? Colors.lightGreen.shade900 : score <= 6 ? Colors.orange.shade900 : Colors.red.shade900),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _data.interpretation,
                          style: TextStyle(fontSize: 14, color: score == 0 ? Colors.green.shade900 : score <= 3 ? Colors.lightGreen.shade900 : score <= 6 ? Colors.orange.shade900 : Colors.red.shade900),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarVAS,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala VAS'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

