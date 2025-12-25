import 'package:flutter/material.dart';
import '../models/seos_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class SEOSScreen extends StatefulWidget {
  const SEOSScreen({super.key});
  @override
  State<SEOSScreen> createState() => _SEOSScreenState();
}

class _SEOSScreenState extends State<SEOSScreen> {
  final SEOSData _data = SEOSData();

  Future<void> _salvarSEOS() async {
    try {
      final score = CompletedScore(
        scoreName: 'SEOS',
        scoreData: {
          'idade': _data.idade,
          'tipoSE': _data.tipoSE,
          'nivelConsciencia': _data.nivelConsciencia,
          'duracaoSE': _data.duracaoSE,
          'etiologia': _data.etiologia,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala SEOS salva com sucesso!'),
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
      appBar: AppBar(title: const Text('SEOS'), centerTitle: true, backgroundColor: Colors.indigo),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Status Epilepticus Outcome Score', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          _buildRadioItem('Idade', ['<65 (0)', '≥65 (1)'], _data.idade, (val) => setState(() => _data.idade = val)),
          _buildRadioItem('Tipo SE', ['Não convulsivo (0)', 'Convulsivo (1)'], _data.tipoSE, (val) => setState(() => _data.tipoSE = val)),
          _buildRadioItem('Consciência', ['Normal/Confuso (0)', 'Estupor/Coma (1)'], _data.nivelConsciencia, (val) => setState(() => _data.nivelConsciencia = val)),
          _buildRadioItem('Duração SE', ['<24h (0)', '≥24h (1)'], _data.duracaoSE, (val) => setState(() => _data.duracaoSE = val)),
          _buildRadioItem('Etiologia', ['Não estrutural (0)', 'Estrutural (1)'], _data.etiologia, (val) => setState(() => _data.etiologia = val)),
          const SizedBox(height: 16),
          Card(color: _getScoreColor(score), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 6, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text('SEOS Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 8), Text('$score', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), Text(_data.interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center)]))),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarSEOS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala SEOS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Voltar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12))),
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
                activeColor: Colors.indigo,
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
    if (score <= 4) return Colors.orange;
    return Colors.red;
  }
}

