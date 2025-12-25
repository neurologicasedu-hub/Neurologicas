import 'package:flutter/material.dart';
import '../models/mgfa_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class MGFAScreen extends StatefulWidget {
  const MGFAScreen({super.key});
  @override
  State<MGFAScreen> createState() => _MGFAScreenState();
}

class _MGFAScreenState extends State<MGFAScreen> {
  final MGFAData _data = MGFAData();

  Future<void> _salvarMGFA() async {
    try {
      final score = CompletedScore(
        scoreName: 'MGFA Classification',
        scoreData: {
          'classe': _data.classe,
        },
        resultado: _data.interpretacao,
        totalScore: _data.classe,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala MGFA salva com sucesso!'),
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
      appBar: AppBar(title: const Text('MGFA Classification'), centerTitle: true, backgroundColor: Colors.blue.shade800),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Myasthenia Gravis Foundation of America', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ...List.generate(5, (index) {
            int classe = index + 1;
            final tempData = MGFAData(classe: classe);
            return _buildRadioItem('Classe $classe', tempData.descricao, classe == _data.classe, () => setState(() => _data.classe = classe));
          }),
          const SizedBox(height: 16),
          Card(color: _getScoreColor(_data.classe), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 6, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [Text('Classe ${_data.classe}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), Text(_data.interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center)]))),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarMGFA();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala MGFA'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Voltar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12))),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String title, String description, bool selected, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: selected ? 4 : 1,
      color: selected ? Colors.blue.shade50 : null,
      child: RadioListTile<int>(
        title: Text(title, style: TextStyle(fontSize: 14, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text(description, style: const TextStyle(fontSize: 12)),
        value: 1,
        groupValue: selected ? 1 : null,
        onChanged: (_) => onTap(),
        activeColor: Colors.blue.shade800,
      ),
    );
  }

  Color _getScoreColor(int classe) {
    if (classe <= 2) return Colors.green;
    if (classe <= 3) return Colors.orange;
    return Colors.red;
  }
}

