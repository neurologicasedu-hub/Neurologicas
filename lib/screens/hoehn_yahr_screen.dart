import 'package:flutter/material.dart';
import '../models/hoehn_yahr_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class HoehnYahrScreen extends StatefulWidget {
  const HoehnYahrScreen({super.key});

  @override
  State<HoehnYahrScreen> createState() => _HoehnYahrScreenState();
}

class _HoehnYahrScreenState extends State<HoehnYahrScreen> {
  final HoehnYahrData _data = HoehnYahrData();

  Future<void> _salvarHoehnYahr() async {
    try {
      final score = CompletedScore(
        scoreName: 'Hoehn and Yahr Scale',
        scoreData: {'stage': _data.stage},
        resultado: 'Estágio ${_data.stage} - ${_data.stageDescription} - ${_data.interpretation}',
        totalScore: _data.stage,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Hoehn and Yahr salva com sucesso!'),
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

  Widget _buildStageOption(int stage, String title) {
    final isSelected = _data.stage == stage;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Colors.blue.shade50 : null,
      child: RadioListTile<int>(
        title: Text('Estágio $stage: $title', style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        value: stage,
        groupValue: _data.stage,
        onChanged: (val) => setState(() => _data.stage = val ?? 0),
        activeColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoehn and Yahr Scale'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Hoehn and Yahr Scale - Estadiamento da Doença de Parkinson',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildStageOption(0, 'Sem sinais de doença'),
          _buildStageOption(1, 'Doença unilateral apenas'),
          _buildStageOption(2, 'Doença bilateral sem comprometimento do equilíbrio'),
          _buildStageOption(3, 'Doença bilateral leve a moderada com comprometimento postural. O paciente é fisicamente independente.'),
          _buildStageOption(4, 'Incapacidade grave; ainda é capaz de andar ou ficar em pé sem ajuda'),
          _buildStageOption(5, 'Confinado à cadeira de rodas ou acamado, a menos que auxiliado'),
          const SizedBox(height: 16),
          if (_data.stage > 0)
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estágio ${_data.stage}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_data.stageDescription, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(_data.interpretation, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue.shade700)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarHoehnYahr();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Hoehn and Yahr'),
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
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
