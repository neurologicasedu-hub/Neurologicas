import 'package:flutter/material.dart';
import '../models/lundberg_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class LundbergScreen extends StatefulWidget {
  const LundbergScreen({super.key});

  @override
  State<LundbergScreen> createState() => _LundbergScreenState();
}

class _LundbergScreenState extends State<LundbergScreen> {
  final LundbergData _data = LundbergData();

  Future<void> _salvarLundberg() async {
    try {
      final score = CompletedScore(
        scoreName: 'Lundberg Waves (ICP)',
        scoreData: {
          'tipoOnda': _data.tipoOnda,
          'amplitude': _data.amplitude,
          'frequencia': _data.frequencia,
          'duracao': _data.duracao,
        },
        resultado: '${_data.interpretacao} - ${_data.condutaRecomendada}',
        totalScore: null,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Lundberg salva com sucesso!'),
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
    final descricao = _data.descricaoOnda;
    final interpretacao = _data.interpretacao;
    final conduta = _data.condutaRecomendada;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lundberg Waves (ICP)'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Ondas de Lundberg - Padrões de ICP',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _buildRadioItem('Tipo de Onda', [
            'Normal',
            'Ondas C',
            'Ondas B',
            'Ondas A'
          ], ['normal', 'C', 'B', 'A'], _data.tipoOnda, (val) => setState(() => _data.tipoOnda = val)),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(_data.tipoOnda),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(_data.tipoOnda.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(descricao, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.blueGrey.shade700,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Conduta Recomendada', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(conduta, style: const TextStyle(fontSize: 13, color: Colors.white), textAlign: TextAlign.left),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarLundberg();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Lundberg'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String title, List<String> labels, List<String> values, String selected, ValueChanged<String> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...labels.asMap().entries.map((entry) {
              int index = entry.key;
              String label = entry.value;
              String value = values[index];
              return RadioListTile<String>(
                title: Text(label, style: const TextStyle(fontSize: 13)),
                value: value,
                groupValue: selected,
                onChanged: (val) => onChanged(val ?? 'normal'),
                activeColor: Colors.teal,
                dense: true,
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(String tipo) {
    switch (tipo) {
      case 'A':
        return Colors.red;
      case 'B':
        return Colors.orange;
      case 'C':
      case 'normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

