import 'package:flutter/material.dart';
import '../models/sdmt_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import 'dart:async';

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
      setState(() {
        if (_segundos > 0) {
          _segundos--;
        } else {
          _finalizarTeste();
        }
      });
    });
  }

  void _finalizarTeste() {
    _timer?.cancel();
    setState(() {
      _testeIniciado = false;
    });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('SDMT'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.cyan.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Instruções', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(
                    'O paciente deve associar símbolos a números seguindo a chave fornecida.\n'
                    'Tempo limite: 90 segundos\n'
                    'Conte o número de respostas corretas.',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          if (_testeIniciado) ...[
            Card(
              color: _segundos <= 10 ? Colors.red.shade100 : Colors.cyan.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Tempo Restante', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      '$_segundos segundos',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _segundos <= 10 ? Colors.red : Colors.cyan.shade900),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _finalizarTeste,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      child: const Text('Finalizar Teste'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Clique para iniciar o teste de 90 segundos', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _iniciarTeste,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Iniciar Teste'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Respostas Corretas', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _corretasController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Número de respostas corretas',
                      hintText: 'Ex: 45',
                      border: OutlineInputBorder(),
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

          const SizedBox(height: 16),
          Card(
            color: score >= 45 ? Colors.green : score >= 35 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('SDMT Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score respostas corretas', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('Tempo: 90 segundos', style: TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarSDMT,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala SDMT'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

