import 'package:flutter/material.dart';
import 'dart:math';
import '../models/msfc_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class MSFCScreen extends StatefulWidget {
  const MSFCScreen({super.key});

  @override
  State<MSFCScreen> createState() => _MSFCScreenState();
}

class _MSFCScreenState extends State<MSFCScreen> {
  final MSFCData _data = MSFCData();
  final TextEditingController _t25fwController = TextEditingController();
  final TextEditingController _hptEsqController = TextEditingController();
  final TextEditingController _hptDirController = TextEditingController();
  
  // PASAT-3
  int _pasat3CurrentIndex = 0;
  final List<int> _pasat3Numeros = [];
  final TextEditingController _pasat3RespostaController = TextEditingController();
  bool _pasat3Iniciado = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _gerarSequenciaPASAT3();
  }

  void _gerarSequenciaPASAT3() {
    // Gera 61 números aleatórios de 1 a 9 para PASAT-3
    _pasat3Numeros.clear();
    for (int i = 0; i < 61; i++) {
      _pasat3Numeros.add(_random.nextInt(9) + 1);
    }
  }

  void _iniciarPASAT3() {
    setState(() {
      _pasat3Iniciado = true;
      _pasat3CurrentIndex = 0;
      _pasat3RespostaController.clear();
    });
  }

  void _verificarRespostaPASAT3() {
    // PASAT-3: soma cada número com o anterior
    // Primeiro número (índice 0) não tem soma, apenas mostramos
    // Começamos a somar a partir do índice 1 (60 somas no total)
    
    if (_pasat3CurrentIndex == 0) {
      // Primeiro número: apenas mostra, passa para próxima
      setState(() {
        _pasat3CurrentIndex = 1;
        _pasat3RespostaController.clear();
      });
      return;
    }

    // A partir do índice 1, verificamos a soma
    final resposta = int.tryParse(_pasat3RespostaController.text);
    if (resposta == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira uma resposta numérica'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final numeroAtual = _pasat3Numeros[_pasat3CurrentIndex];
    final numeroAnterior = _pasat3Numeros[_pasat3CurrentIndex - 1];
    final respostaCorreta = numeroAtual + numeroAnterior;

    final estaCorreta = resposta == respostaCorreta;
    
    setState(() {
      // Armazena a resposta (índice da lista de respostas começa em 0, mas CurrentIndex começa em 1)
      _data.pasat3Respostas[_pasat3CurrentIndex - 1] = estaCorreta;
      
      if (_pasat3CurrentIndex < 60) {
        _pasat3CurrentIndex++;
        _pasat3RespostaController.clear();
      } else {
        // Teste completo - calcula o score
        _data.calcularPASAT3();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PASAT-3 completo! Score: ${_data.pasat3Score}/60'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  Future<void> _salvarMSFC() async {
    try {
      final score = CompletedScore(
        scoreName: 'MSFC (Multiple Sclerosis Functional Composite)',
        scoreData: {
          't25fwSegundos': _data.t25fwSegundos,
          'nineHptEsquerda': _data.nineHptEsquerda,
          'nineHptDireita': _data.nineHptDireita,
          'pasat3Score': _data.pasat3Score,
        },
        resultado: _data.interpretation,
        totalScore: _data.totalScore?.round() ?? 0,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala MSFC salva com sucesso!'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('MSFC - Multiple Sclerosis Functional Composite'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'MSFC - Composto Funcional de Esclerose Múltipla',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. T25FW - Timed 25-Foot Walk', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const Text('Tempo em segundos para caminhar 25 pés (~7.6 metros)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _t25fwController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Tempo (segundos)',
                      border: OutlineInputBorder(),
                      suffixText: 's',
                    ),
                    onChanged: (val) {
                      final time = double.tryParse(val.replaceAll(',', '.'));
                      if (time != null) {
                        setState(() => _data.t25fwSegundos = time);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('2. 9HPT - 9-Hole Peg Test', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const Text('Tempo em segundos para cada mão', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _hptEsqController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Mão Esquerda (s)',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            final time = double.tryParse(val.replaceAll(',', '.'));
                            if (time != null) {
                              setState(() => _data.nineHptEsquerda = time);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _hptDirController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Mão Direita (s)',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            final time = double.tryParse(val.replaceAll(',', '.'));
                            if (time != null) {
                              setState(() => _data.nineHptDireita = time);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('3. PASAT-3 - Paced Auditory Serial Addition Test', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const Text('Some cada número ao anterior. 60 perguntas.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 8),
                  if (!_pasat3Iniciado)
                    ElevatedButton(
                      onPressed: _iniciarPASAT3,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Iniciar PASAT-3'),
                    )
                  else ...[
                    Text(
                      _pasat3CurrentIndex == 0 
                        ? 'Número inicial (1/61)' 
                        : 'Pergunta $_pasat3CurrentIndex/60',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (_pasat3CurrentIndex == 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Primeiro número (apenas escute/anote, não há soma):',
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Número: ${_pasat3Numeros[0]}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Número anterior: ${_pasat3Numeros[_pasat3CurrentIndex - 1]}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          Text(
                            'Número atual: ${_pasat3Numeros[_pasat3CurrentIndex]}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Qual é a soma?',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    if (_pasat3CurrentIndex > 0) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _pasat3RespostaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Resposta',
                          border: OutlineInputBorder(),
                          hintText: 'Digite a soma',
                        ),
                        autofocus: true,
                        onSubmitted: (_) => _verificarRespostaPASAT3(),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _verificarRespostaPASAT3,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(_pasat3CurrentIndex == 0 ? 'Próximo número' : _pasat3CurrentIndex >= 60 ? 'Finalizar' : 'Próxima'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _pasat3CurrentIndex == 0 
                        ? 'Progresso: 0/60 respostas (número inicial)' 
                        : 'Progresso: $_pasat3CurrentIndex/60 respostas',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_data.totalScore != null)
            Card(
              color: _data.totalScore! >= 70 ? Colors.green : _data.totalScore! >= 50 ? Colors.orange : Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('MSFC Score: ${_data.totalScore!.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('PASAT-3: ${_data.pasat3Score}/60', style: const TextStyle(fontSize: 14, color: Colors.white)),
                    const SizedBox(height: 12),
                    Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarMSFC();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala MSFC'),
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
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _t25fwController.dispose();
    _hptEsqController.dispose();
    _hptDirController.dispose();
    _pasat3RespostaController.dispose();
    super.dispose();
  }
}