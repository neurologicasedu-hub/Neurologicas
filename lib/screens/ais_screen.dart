import 'package:flutter/material.dart';
import '../models/ais_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class AISScreen extends StatefulWidget {
  const AISScreen({super.key});

  @override
  State<AISScreen> createState() => _AISScreenState();
}

class _AISScreenState extends State<AISScreen> {
  final AISData _data = AISData();

  Future<void> _salvarAIS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Abbreviated Injury Scale (AIS)',
        scoreData: {
          'cabecaPescoco': _data.cabecaPescoco,
          'face': _data.face,
          'torax': _data.torax,
          'abdomen': _data.abdomen,
          'extremidades': _data.extremidades,
          'externo': _data.externo,
        },
        resultado: '${_data.severidadeGeral} - ${_data.interpretacao}',
        totalScore: _data.maxAIS,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala AIS salva com sucesso!'),
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

  @override
  Widget build(BuildContext context) {
    final maxAIS = _data.maxAIS;
    final severidade = _data.severidadeGeral;
    final interpretacao = _data.interpretacao;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Abbreviated Injury Scale (AIS)'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Abbreviated Injury Scale por Região',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _buildSliderItem('Cabeça e Pescoço', _data.cabecaPescoco, (val) => setState(() => _data.cabecaPescoco = val)),
          _buildSliderItem('Face', _data.face, (val) => setState(() => _data.face = val)),
          _buildSliderItem('Tórax', _data.torax, (val) => setState(() => _data.torax = val)),
          _buildSliderItem('Abdome', _data.abdomen, (val) => setState(() => _data.abdomen = val)),
          _buildSliderItem('Extremidades', _data.extremidades, (val) => setState(() => _data.extremidades = val)),
          _buildSliderItem('Externo', _data.externo, (val) => setState(() => _data.externo = val)),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(maxAIS),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Max AIS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$maxAIS', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(severidade, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(interpretacao, style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarAIS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala AIS'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 13)),
                Text('$value/6', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 1,
              max: 6,
              divisions: 5,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int maxAIS) {
    if (maxAIS <= 2) return Colors.green;
    if (maxAIS == 3) return Colors.orange;
    return Colors.red;
  }
}

