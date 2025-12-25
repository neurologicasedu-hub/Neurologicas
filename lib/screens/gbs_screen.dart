import 'package:flutter/material.dart';
import '../models/gbs_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class GBSScreen extends StatefulWidget {
  const GBSScreen({super.key});
  @override
  State<GBSScreen> createState() => _GBSScreenState();
}

class _GBSScreenState extends State<GBSScreen> {
  final GBSData _data = GBSData();

  Future<void> _salvarGBS() async {
    try {
      final score = CompletedScore(
        scoreName: 'GBS Disability Score',
        scoreData: {
          'nivelDeficiencia': _data.nivelDeficiencia,
        },
        resultado: '${_data.interpretacao} - ${_data.conduta}',
        totalScore: _data.nivelDeficiencia,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala GBS salva com sucesso!'),
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
    return Scaffold(
      appBar: AppBar(title: const Text('GBS Disability Score'), centerTitle: true, backgroundColor: Colors.green.shade700),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Guillain-Barré Syndrome Disability Score', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ...List.generate(7, (index) {
            int nivel = index;
            final tempData = GBSData(nivelDeficiencia: nivel);
            return _buildRadioItem('Nível $nivel', tempData.descricao, nivel == _data.nivelDeficiencia, () => setState(() => _data.nivelDeficiencia = nivel));
          }),
          const SizedBox(height: 16),
          Card(color: _getScoreColor(_data.nivelDeficiencia), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 6, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [Text('Nível ${_data.nivelDeficiencia}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), Text(_data.interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center), const SizedBox(height: 12), Text(_data.conduta, style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center)]))),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarGBS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala GBS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Voltar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12))),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String title, String description, bool selected, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: selected ? 4 : 1,
      color: selected ? Colors.green.shade50 : null,
      child: RadioListTile<int>(
        title: Text(title, style: TextStyle(fontSize: 14, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text(description, style: const TextStyle(fontSize: 12)),
        value: 1,
        groupValue: selected ? 1 : null,
        onChanged: (_) => onTap(),
        activeColor: Colors.green.shade700,
      ),
    );
  }

  Color _getScoreColor(int nivel) {
    if (nivel <= 2) return Colors.green;
    if (nivel == 3) return Colors.orange;
    return Colors.red;
  }
}

