import 'package:flutter/material.dart';
import '../models/mstess_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class MSTESSScreen extends StatefulWidget {
  const MSTESSScreen({super.key});
  @override
  State<MSTESSScreen> createState() => _MSTESSScreenState();
}

class _MSTESSScreenState extends State<MSTESSScreen> {
  final MSTESSData _data = MSTESSData();

  Future<void> _salvarMSTESS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Modified STESS (mSTESS)',
        scoreData: {
          'idade': _data.idade,
          'historiaEpilepsia': _data.historiaEpilepsia,
          'tipoSE': _data.tipoSE,
          'nivelConsciencia': _data.nivelConsciencia,
          'horaInicio': _data.horaInicio,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala mSTESS salva com sucesso!'),
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
    final score = _data.totalScore;
    return Scaffold(
      appBar: AppBar(title: const Text('Modified STESS (mSTESS)'), centerTitle: true, backgroundColor: Colors.purpleAccent),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Modified Status Epilepticus Severity Score', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          _buildRadioItem('Idade', ['<40 (0)', '40-59 (1)', '≥60 (2)'], _data.idade, (val) => setState(() => _data.idade = val)),
          _buildRadioItem('História de Epilepsia', ['Não (0)', 'Sim (1)'], _data.historiaEpilepsia, (val) => setState(() => _data.historiaEpilepsia = val)),
          _buildRadioItem('Tipo SE', ['Focal (0)', 'Generalizado (1)', 'Convulsivo (2)', 'Refratário (3)'], _data.tipoSE, (val) => setState(() => _data.tipoSE = val)),
          _buildRadioItem('Nível Consciência', ['Normal/Confuso (0)', 'Estupor/Coma (1)'], _data.nivelConsciencia, (val) => setState(() => _data.nivelConsciencia = val)),
          _buildRadioItem('Hora Início', ['≤1h (0)', '>1h (1)'], _data.horaInicio, (val) => setState(() => _data.horaInicio = val)),
          const SizedBox(height: 16),
          Card(color: _getScoreColor(score), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 6, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text('mSTESS Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 8), Text('$score', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), Text(_data.interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center)]))),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarMSTESS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala mSTESS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Voltar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12))),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String title, List<String> options, int value, ValueChanged<int> onChanged) {
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
            ...options.asMap().entries.map((entry) {
              return RadioListTile<int>(
                title: Text(entry.value, style: const TextStyle(fontSize: 13)),
                value: entry.key,
                groupValue: value,
                onChanged: (val) => onChanged(val ?? 0),
                activeColor: Colors.purpleAccent,
                dense: true,
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 3) return Colors.green;
    if (score <= 5) return Colors.orange;
    return Colors.red;
  }
}

