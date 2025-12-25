import 'package:flutter/material.dart';
import '../models/pvi_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class PVIScreen extends StatefulWidget {
  const PVIScreen({super.key});
  @override
  State<PVIScreen> createState() => _PVIScreenState();
}

class _PVIScreenState extends State<PVIScreen> {
  final PVIData _data = PVIData();

  Future<void> _salvarPVI() async {
    try {
      final score = CompletedScore(
        scoreName: 'Pressure-Volume Index (PVI)',
        scoreData: {
          'volumeInjetado': _data.volumeInjetado,
          'icpInicial': _data.icpInicial,
          'icpFinal': _data.icpFinal,
        },
        resultado: '${_data.interpretacao} - ${_data.conduta}',
        totalScore: _data.pvi.round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala PVI salva com sucesso!'),
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
  final TextEditingController _volController = TextEditingController(text: '1.0');
  final TextEditingController _icpIniController = TextEditingController(text: '15.0');
  final TextEditingController _icpFinController = TextEditingController(text: '20.0');

  @override
  void dispose() {
    _volController.dispose();
    _icpIniController.dispose();
    _icpFinController.dispose();
    super.dispose();
  }

  void _updateData() {
    setState(() {
      _data.volumeInjetado = double.tryParse(_volController.text) ?? 1.0;
      _data.icpInicial = double.tryParse(_icpIniController.text) ?? 15.0;
      _data.icpFinal = double.tryParse(_icpFinController.text) ?? 20.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pvi = _data.pvi;
    final interpretacao = _data.interpretacao;
    final conduta = _data.conduta;

    return Scaffold(
      appBar: AppBar(title: const Text('Pressure-Volume Index (PVI)'), centerTitle: true, backgroundColor: Colors.blueGrey),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Cálculo do PVI', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextField(controller: _volController, decoration: const InputDecoration(labelText: 'Volume Injetado (ml)', border: OutlineInputBorder()), keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (_) => _updateData()),
          const SizedBox(height: 12),
          TextField(controller: _icpIniController, decoration: const InputDecoration(labelText: 'ICP Inicial (mmHg)', border: OutlineInputBorder()), keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (_) => _updateData()),
          const SizedBox(height: 12),
          TextField(controller: _icpFinController, decoration: const InputDecoration(labelText: 'ICP Final (mmHg)', border: OutlineInputBorder()), keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (_) => _updateData()),
          const SizedBox(height: 16),
          Card(color: Colors.blueGrey.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 6, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text('PVI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 8), Text(pvi.toStringAsFixed(2), style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), Text(interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center), const SizedBox(height: 12), Text(conduta, style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center)]))),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarPVI();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala PVI'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Voltar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12))),
        ],
      ),
    );
  }
}

