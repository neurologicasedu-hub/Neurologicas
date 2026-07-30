import 'package:flutter/material.dart';
import 'dart:math';
import '../models/msfc_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

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
    if (_pasat3CurrentIndex == 0) {
      setState(() {
        _pasat3CurrentIndex = 1;
        _pasat3RespostaController.clear();
      });
      return;
    }

    final resposta = int.tryParse(_pasat3RespostaController.text);
    if (resposta == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insira número'), backgroundColor: Colors.red));
      return;
    }

    final numeroAtual = _pasat3Numeros[_pasat3CurrentIndex];
    final numeroAnterior = _pasat3Numeros[_pasat3CurrentIndex - 1];
    final respostaCorreta = numeroAtual + numeroAnterior;
    final estaCorreta = resposta == respostaCorreta;
    
    setState(() {
      _data.pasat3Respostas[_pasat3CurrentIndex - 1] = estaCorreta;
      if (_pasat3CurrentIndex < 60) {
        _pasat3CurrentIndex++;
        _pasat3RespostaController.clear();
      } else {
        _data.calcularPASAT3();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PASAT-3 completo! Score: ${_data.pasat3Score}/60'), backgroundColor: Colors.green));
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
              onPressed: () => Navigator.pushReplacementNamed(context, '/report'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'MSFC',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Multiple Sclerosis Functional Composite',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

          _buildComponentCard('1. T25FW - Caminhada 25 Pés', 
            TextField(
              controller: _t25fwController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tempo (s)', border: OutlineInputBorder(), suffixText: 's'),
              onChanged: (v) {
                final d = double.tryParse(v.replaceAll(',', '.'));
                if(d != null) setState(() => _data.t25fwSegundos = d);
              },
            ),
          ),

          _buildComponentCard('2. 9HPT - Teste dos 9 Pinos', 
            Row(children: [
              Expanded(child: TextField(
                controller: _hptEsqController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Mão Esq (s)', border: OutlineInputBorder()),
                onChanged: (v) {
                   final d = double.tryParse(v.replaceAll(',', '.'));
                   if(d != null) setState(() => _data.nineHptEsquerda = d);
                },
              )),
              const SizedBox(width: 8),
              Expanded(child: TextField(
                controller: _hptDirController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Mão Dir (s)', border: OutlineInputBorder()),
                onChanged: (v) {
                   final d = double.tryParse(v.replaceAll(',', '.'));
                   if(d != null) setState(() => _data.nineHptDireita = d);
                },
              )),
            ]),
          ),

          _buildComponentCard('3. PASAT-3 - Cálculo Serial', 
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 if (!_pasat3Iniciado)
                   Center(child: ElevatedButton(onPressed: _iniciarPASAT3, child: const Text('Iniciar Teste Interativo')))
                 else ...[
                   Center(child: Text(_pasat3CurrentIndex == 0 ? 'MEMORIZE:' : 'SOME COM ANTERIOR:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                   const SizedBox(height: 4),
                   Center(child: Text('${_pasat3Numeros[_pasat3CurrentIndex]}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold))),
                   if (_pasat3CurrentIndex > 0) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: _pasat3RespostaController,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(hintText: 'Soma', border: OutlineInputBorder()),
                        onSubmitted: (_) => _verificarRespostaPASAT3(),
                      ),
                   ],
                   const SizedBox(height: 12),
                   SizedBox(
                     width: double.infinity,
                     child: ElevatedButton(
                       onPressed: _verificarRespostaPASAT3,
                       child: Text(_pasat3CurrentIndex == 0 ? 'Próximo' : 'Confirmar'),
                     ),
                   ),
                   const SizedBox(height: 8),
                   Text('Progresso: $_pasat3CurrentIndex/60', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                 ]
               ],
             ),
          ),
          
          if (_data.totalScore != null)
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  Text('Z-Score Total: ${_data.totalScore!.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('PASAT-3: ${_data.pasat3Score}/60', style: const TextStyle(color: Colors.white)),
                   const SizedBox(height: 8),
                  Text(_data.interpretation, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarMSFC,
        backgroundColor: Colors.cyan,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildComponentCard(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}