import 'package:flutter/material.dart';
import '../models/tug_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

import 'dart:async'; // Add this import

class TUGScreen extends StatefulWidget {
  const TUGScreen({super.key});

  @override
  State<TUGScreen> createState() => _TUGScreenState();
}


class _TUGScreenState extends State<TUGScreen> {
  final TUGData _data = TUGData();
  final TextEditingController _tempoController = TextEditingController();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _tempoController.dispose();
    super.dispose();
  }

  void _toggleStopwatch() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
        _timer?.cancel();
        // Update the input field when stopped
        double seconds = _stopwatch.elapsedMilliseconds / 1000.0;
        _tempoController.text = seconds.toStringAsFixed(1);
        _data.tempoSegundos = seconds;
      } else {
        _stopwatch.start();
        _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
          setState(() {});
        });
      }
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      _stopwatch.stop();
      _timer?.cancel();
      _tempoController.text = '';
      _data.tempoSegundos = 0.0;
    });
  }

  String _formatTime() {
    final int milliseconds = _stopwatch.elapsedMilliseconds;
    final int seconds = (milliseconds / 1000).truncate();
    final int minutes = (seconds / 60).truncate();

    final String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    final String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    final String hundredsStr = ((milliseconds % 1000) / 10).truncate().toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr.$hundredsStr';
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
        resultado: '${_data.tempoSegundos.toStringAsFixed(1)}s - ${_data.interpretacao}',
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
    return CalculatorScaffold(
      title: 'Timed Up & Go (TUG)',
      body: [
         Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(Icons.timer_outlined, size: 48, color: Colors.pink),
                const SizedBox(height: 16),
                const Text(
                  'Instruções',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                ),
                const SizedBox(height: 8),
                Text(
                  '1. Paciente sentado em cadeira com braços.\n2. Levanta-se, caminha 3 metros.\n3. Vira-se, retorna e senta-se.\n4. Cronometre o tempo.',
                  style: TextStyle(fontSize: 14, color: Colors.pink.shade900, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
         ),
         
         const SizedBox(height: 24),

         // Stopwatch Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              children: [
                const Text('Cronômetro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.pink)),
                const SizedBox(height: 16),
                Text(
                  _formatTime(),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.large(
                      heroTag: 'play_pause',
                      onPressed: _toggleStopwatch,
                      backgroundColor: _stopwatch.isRunning ? Colors.orange : Colors.green,
                      child: Icon(_stopwatch.isRunning ? Icons.pause : Icons.play_arrow, size: 36, color: Colors.white),
                    ),
                    const SizedBox(width: 24),
                    FloatingActionButton(
                      heroTag: 'reset',
                      onPressed: _resetStopwatch,
                      backgroundColor: Colors.grey.shade200,
                      elevation: 0,
                      child: const Icon(Icons.refresh, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

         const SizedBox(height: 24),
         
         Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tempo Manual (segundos)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                TextField(
                  controller: _tempoController,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.pink),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixText: 'seg',
                    suffixStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                    hintText: '0.0',
                    filled: true,
                    fillColor: Colors.pink.shade50.withOpacity(0.3),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => _updateTempo(),
                ),
              ],
            ),
          ),

          // Result Card
          Container(
            margin: const EdgeInsets.only(top: 24, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(tempo),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(tempo).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('INTERPRETAÇÃO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  _data.interpretacao,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Risco de Queda: ${_data.riscoQuedas}',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarTUG,
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getScoreColor(double tempo) {
    if (tempo == 0) return Colors.grey;
    if (tempo <= 10) return Colors.green;
    if (tempo <= 20) return Colors.orange;
    return Colors.red;
  }
}
