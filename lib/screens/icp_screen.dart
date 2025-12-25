import 'package:flutter/material.dart';
import '../models/icp_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class ICPScreen extends StatefulWidget {
  const ICPScreen({super.key});

  @override
  State<ICPScreen> createState() => _ICPScreenState();
}

class _ICPScreenState extends State<ICPScreen> {
  final ICPData _data = ICPData();

  Future<void> _salvarICP() async {
    try {
      final score = CompletedScore(
        scoreName: 'ICP Monitoring',
        scoreData: {
          'pressaoIntracraniana': _data.pressaoIntracraniana,
          'pressaoArterialMedia': _data.pressaoArterialMedia,
          'pressaoPerfusaoCerebral': _data.pressaoPerfusaoCerebralCalculada,
        },
        resultado: 'ICP: ${_data.classificacaoICP} | PPC: ${_data.classificacaoPPC} - ${_data.conduta}',
        totalScore: _data.pressaoIntracraniana.round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ICP salva com sucesso!'),
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
  final TextEditingController _icpController = TextEditingController(text: '10');
  final TextEditingController _pamController = TextEditingController(text: '70');

  @override
  void dispose() {
    _icpController.dispose();
    _pamController.dispose();
    super.dispose();
  }

  void _updateData() {
    setState(() {
      _data.pressaoIntracraniana = double.tryParse(_icpController.text) ?? 10;
      _data.pressaoArterialMedia = double.tryParse(_pamController.text) ?? 70;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ppc = _data.pressaoPerfusaoCerebralCalculada;
    final classificacaoICP = _data.classificacaoICP;
    final classificacaoPPC = _data.classificacaoPPC;
    final conduta = _data.conduta;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ICP Monitoring'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Monitorização de Pressão Intracraniana',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _icpController,
            decoration: const InputDecoration(
              labelText: 'Pressão Intracraniana (ICP) - mmHg',
              hintText: 'Ex: 15',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _updateData(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pamController,
            decoration: const InputDecoration(
              labelText: 'Pressão Arterial Média (PAM) - mmHg',
              hintText: 'Ex: 70',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _updateData(),
          ),
          const SizedBox(height: 16),
          Card(
            color: _getICPPCColor(_data.pressaoIntracraniana),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('${_data.pressaoIntracraniana.toStringAsFixed(1)} mmHg', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(classificacaoICP, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: _getPPCColor(ppc),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('${ppc.toStringAsFixed(1)} mmHg', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('Pressão de Perfusão Cerebral (PPC)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(classificacaoPPC, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
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
              await _salvarICP();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala ICP'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  Color _getICPPCColor(double value) {
    if (value < 15) return Colors.green;
    if (value < 20) return Colors.lightGreen;
    if (value < 25) return Colors.orange;
    if (value < 35) return Colors.deepOrange;
    return Colors.red;
  }

  Color _getPPCColor(double value) {
    if (value >= 70) return Colors.green;
    if (value >= 50) return Colors.orange;
    if (value >= 40) return Colors.deepOrange;
    return Colors.red;
  }
}

