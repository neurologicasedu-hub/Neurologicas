import 'package:flutter/material.dart';
import '../models/stess_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class STESSScreen extends StatefulWidget {
  const STESSScreen({super.key});
  @override
  State<STESSScreen> createState() => _STESSScreenState();
}

class _STESSScreenState extends State<STESSScreen> {
  final STESSData _data = STESSData();

  Future<void> _salvarSTESS() async {
    try {
      final score = CompletedScore(
        scoreName: 'STESS',
        scoreData: {
          'idade': _data.idade,
          'tipoSE': _data.tipoSE,
          'nivelConsciencia': _data.nivelConsciencia,
          'frequenciaEpileptica': _data.frequenciaEpileptica,
        },
        resultado: '${_data.interpretacao} - Mortalidade: ${_data.mortalidadeEstimada}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala STESS salva com sucesso!'),
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
    final interpretacao = _data.interpretacao;
    final mortalidade = _data.mortalidadeEstimada;

    return Scaffold(
      appBar: AppBar(title: const Text('STESS'), centerTitle: true, backgroundColor: Colors.deepPurple),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Status Epilepticus Severity Score', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          _buildRadioItem('Idade', ['<65 anos (0)', '≥65 anos (1)'], _data.idade, (val) => setState(() => _data.idade = val)),
          _buildRadioItem('Tipo de SE', ['Não convulsivo (0)', 'Convulsivo (1)', 'Refratário (2)'], _data.tipoSE, (val) => setState(() => _data.tipoSE = val)),
          _buildRadioItem('Nível de Consciência', ['Outro (0)', 'Stupor/Coma (1)'], _data.nivelConsciencia, (val) => setState(() => _data.nivelConsciencia = val)),
          _buildRadioItem('Frequência Epiléptica', ['Sem convulsão após 1h (0)', 'Com convulsão (1)'], _data.frequenciaEpileptica, (val) => setState(() => _data.frequenciaEpileptica = val)),
          const SizedBox(height: 16),
          Card(color: _getScoreColor(score), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 6, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text('STESS Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 8), Text('$score', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), Text(interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center), const SizedBox(height: 8), Text('Mortalidade: $mortalidade', style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center)]))),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarSTESS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala STESS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Voltar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12))),
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
                activeColor: Colors.deepPurple,
                dense: true,
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 2) return Colors.green;
    if (score == 3) return Colors.orange;
    return Colors.red;
  }
}

