import 'package:flutter/material.dart';
import '../models/neuromuscular_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class NeuromuscularScreen extends StatefulWidget {
  const NeuromuscularScreen({super.key});
  @override
  State<NeuromuscularScreen> createState() => _NeuromuscularScreenState();
}

class _NeuromuscularScreenState extends State<NeuromuscularScreen> {
  final NeuromuscularData _data = NeuromuscularData();

  Future<void> _salvarNeuromuscular() async {
    try {
      final score = CompletedScore(
        scoreName: 'Doenças Neuromusculares / Crise Aguda',
        scoreData: {
          'forcaMuscular': _data.forcaMuscular,
          'reflexos': _data.reflexos,
          'sensibilidade': _data.sensibilidade,
          'insuficienciaRespiratoria': _data.insuficienciaRespiratoria,
          'disfagia': _data.disfagia,
          'ptosePalpebral': _data.ptosePalpebral,
          'diplopia': _data.diplopia,
          'disartria': _data.disartria,
          'fraquezaBulbar': _data.fraquezaBulbar,
        },
        resultado: '${_data.interpretacao} - ${_data.conduta}',
        totalScore: _data.severidade,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Neuromuscular salva com sucesso!'),
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
    final severidade = _data.severidade;
    return Scaffold(
      appBar: AppBar(title: const Text('Doenças Neuromusculares / Crise Aguda'), centerTitle: true, backgroundColor: Colors.red.shade700),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Avaliação de Crise Neuromuscular Aguda', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          _buildSliderItem('Força Muscular', _data.forcaMuscular, 5, (val) => setState(() => _data.forcaMuscular = val)),
          _buildSliderItem('Reflexos', _data.reflexos, 2, (val) => setState(() => _data.reflexos = val)),
          _buildSliderItem('Sensibilidade', _data.sensibilidade, 2, (val) => setState(() => _data.sensibilidade = val)),
          _buildCheckboxItem('Insuficiência Respiratória', _data.insuficienciaRespiratoria, (val) => setState(() => _data.insuficienciaRespiratoria = val)),
          _buildCheckboxItem('Disfagia', _data.disfagia, (val) => setState(() => _data.disfagia = val)),
          _buildCheckboxItem('Ptose Palpebral', _data.ptosePalpebral, (val) => setState(() => _data.ptosePalpebral = val)),
          _buildCheckboxItem('Diplopia', _data.diplopia, (val) => setState(() => _data.diplopia = val)),
          _buildCheckboxItem('Disartria', _data.disartria, (val) => setState(() => _data.disartria = val)),
          _buildCheckboxItem('Fraqueza Bulbar', _data.fraquezaBulbar, (val) => setState(() => _data.fraquezaBulbar = val)),
          const SizedBox(height: 16),
          Card(color: _getSeveridadeColor(severidade), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 6, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text('Severidade', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 8), Text('$severidade', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), Text(_data.interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center), const SizedBox(height: 12), Text(_data.conduta, style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center)]))),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarNeuromuscular();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Neuromuscular'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Voltar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12))),
        ],
      ),
    );
  }

  Widget _buildSliderItem(String title, int value, int max, ValueChanged<int> onChanged) {
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
                Text('$value/$max', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: max.toDouble(),
              divisions: max > 0 ? max : 1,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.red.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Card(margin: const EdgeInsets.symmetric(vertical: 4), elevation: 1, child: CheckboxListTile(title: Text(title, style: const TextStyle(fontSize: 14)), value: value, onChanged: (val) => onChanged(val ?? false), activeColor: Colors.red.shade700));
  }

  Color _getSeveridadeColor(int severidade) {
    if (severidade <= 5) return Colors.green;
    if (severidade <= 10) return Colors.orange;
    return Colors.red;
  }
}

