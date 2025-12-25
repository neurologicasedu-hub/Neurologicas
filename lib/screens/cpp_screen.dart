import 'package:flutter/material.dart';
import '../models/cpp_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class CPPScreen extends StatefulWidget {
  const CPPScreen({super.key});
  @override
  State<CPPScreen> createState() => _CPPScreenState();
}

class _CPPScreenState extends State<CPPScreen> {
  final CPPData _data = CPPData();

  Future<void> _salvarCPP() async {
    try {
      final score = CompletedScore(
        scoreName: 'Cerebral Perfusion Pressure (CPP)',
        scoreData: {
          'pressaoArterialMedia': _data.pressaoArterialMedia,
          'pressaoIntracraniana': _data.pressaoIntracraniana,
        },
        resultado: '${_data.interpretacao} - ${_data.conduta}',
        totalScore: _data.cpp.round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala CPP salva com sucesso!'),
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
  final TextEditingController _pamController = TextEditingController(text: '80.0');
  final TextEditingController _icpController = TextEditingController(text: '10.0');

  @override
  void dispose() {
    _pamController.dispose();
    _icpController.dispose();
    super.dispose();
  }

  void _updateData() {
    setState(() {
      _data.pressaoArterialMedia = double.tryParse(_pamController.text) ?? 80.0;
      _data.pressaoIntracraniana = double.tryParse(_icpController.text) ?? 10.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cpp = _data.cpp;
    final interpretacao = _data.interpretacao;
    final conduta = _data.conduta;

    return Scaffold(
      appBar: AppBar(title: const Text('Cerebral Perfusion Pressure (CPP)'), centerTitle: true, backgroundColor: Colors.cyan),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('CPP = PAM - ICP', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextField(controller: _pamController, decoration: const InputDecoration(labelText: 'Pressão Arterial Média (PAM) - mmHg', border: OutlineInputBorder()), keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (_) => _updateData()),
          const SizedBox(height: 12),
          TextField(controller: _icpController, decoration: const InputDecoration(labelText: 'Pressão Intracraniana (ICP) - mmHg', border: OutlineInputBorder()), keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (_) => _updateData()),
          const SizedBox(height: 16),
          Card(color: _getCPPColor(cpp), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 6, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text('CPP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 8), Text('${cpp.toStringAsFixed(1)} mmHg', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), Text(interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center), const SizedBox(height: 12), Text(conduta, style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center)]))),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarCPP();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala CPP'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Voltar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12))),
        ],
      ),
    );
  }

  Color _getCPPColor(double cpp) {
    if (cpp >= 70 && cpp <= 100) return Colors.green;
    if (cpp >= 60 && cpp < 70) return Colors.orange;
    if (cpp < 60) return Colors.red;
    return Colors.orange;
  }
}

