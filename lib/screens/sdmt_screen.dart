import 'package:flutter/material.dart';
import '../models/sdmt_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import 'dart:async';
import '../widgets/calculator_scaffold.dart';

class SDMTScreen extends StatefulWidget {
  const SDMTScreen({super.key});

  @override
  State<SDMTScreen> createState() => _SDMTScreenState();
}

class _SDMTScreenState extends State<SDMTScreen> {
  final SDMTData _data = SDMTData();
  final TextEditingController _corretasController = TextEditingController();
  
  Timer? _timer;
  int _segundos = 90;
  bool _testeIniciado = false;

  @override
  void dispose() {
    _timer?.cancel();
    _corretasController.dispose();
    super.dispose();
  }

  void _iniciarTeste() {
    setState(() {
      _testeIniciado = true;
      _segundos = 90;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_segundos > 0) {
            _segundos--;
          } else {
            _finalizarTeste();
          }
        });
      }
    });
  }

  void _finalizarTeste() {
    _timer?.cancel();
    if (mounted) {
      setState(() {
        _testeIniciado = false;
      });
    }
  }

  Future<void> _salvarSDMT() async {
    try {
      final score = CompletedScore(
        scoreName: 'Symbol Digit Modalities Test (SDMT)',
        scoreData: {
          'respostasCorretas': _data.respostasCorretas,
        },
        resultado: '${_data.totalScore} respostas corretas em 90s - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala SDMT salva com sucesso!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ver Relatório',
              textColor: Colors.white,
              onPressed: () => Navigator.pushReplacementNamed(context, '/report'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'SDMT',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Associe símbolos a números. Tempo limite: 90s.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

          if (_testeIniciado)
            Card(
              color: _segundos <= 10 ? Colors.red.shade50 : Colors.cyan.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      '$_segundos',
                      style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: _segundos <= 10 ? Colors.red : Colors.cyan.shade800),
                    ),
                    const Text('segundos restantes', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _finalizarTeste,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      child: const Text('Parar Teste'),
                    ),
                  ],
                ),
              ),
            )
          else
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.timer, size: 48, color: Colors.cyan),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _iniciarTeste,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Iniciar Timer (90s)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan, 
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
           const SizedBox(height: 16),
           
           Card(
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text('Resultados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                   const SizedBox(height: 16),
                   TextField(
                      controller: _corretasController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Número de Respostas Corretas',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.check_circle_outline),
                      ),
                      onChanged: (value) {
                        final num = int.tryParse(value) ?? 0;
                        setState(() => _data.respostasCorretas = num);
                      },
                    ),
                 ],
               ),
             ),
           ),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score >= 45 ? Colors.green : score >= 35 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score >= 45 ? Colors.green : score >= 35 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('SDMT SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$score', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 12),
                Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarSDMT,
        backgroundColor: Colors.cyan,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
