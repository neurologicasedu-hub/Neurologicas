import 'package:flutter/material.dart';
import '../models/tug_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class TUGScreen extends StatefulWidget {
  const TUGScreen({super.key});

  @override
  State<TUGScreen> createState() => _TUGScreenState();
}

class _TUGScreenState extends State<TUGScreen> {
  final TUGData _data = TUGData();
  final TextEditingController _tempoController = TextEditingController();

  @override
  void dispose() {
    _tempoController.dispose();
    super.dispose();
  }

  void _updateTempo() {
    setState(() {
      _data.tempoSegundos = double.tryParse(_tempoController.text.replaceAll(',', '.')) ?? 0.0;
    });
  }

  Future<void> _salvarTUG() async {
    try {
      final score = CompletedScore(
        scoreName: 'Timed Up & Go (TUG)',
        scoreData: {
          'tempoSegundos': _data.tempoSegundos,
        },
        resultado: _data.interpretacao,
        totalScore: _data.tempoSegundos.round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala TUG salva com sucesso!'),
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
    final tempo = _data.tempoSegundos;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timed Up & Go (TUG)'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Timed Up & Go (TUG)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Procedimento:\nPaciente levanta-se da cadeira, anda 3 m, vira, volta e senta.\nCronometra-se o tempo em segundos.',
            style: TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tempoController,
            decoration: const InputDecoration(
              labelText: 'Tempo (segundos)',
              hintText: 'Ex: 12.5',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _updateTempo(),
          ),
          const SizedBox(height: 16),
          Card(
            color: tempo <= 10 ? Colors.green : tempo <= 13 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Tempo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${tempo.toStringAsFixed(1)} s',
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _data.interpretacao,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Risco de quedas: ${_data.riscoQuedas}',
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarTUG();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala TUG'),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
