import 'package:flutter/material.dart';
import '../models/adas_cog_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class ADASCogScreen extends StatefulWidget {
  const ADASCogScreen({super.key});

  @override
  State<ADASCogScreen> createState() => _ADASCogScreenState();
}

class _ADASCogScreenState extends State<ADASCogScreen> {
  final ADASCogData _data = ADASCogData();

  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Recordação de Palavras', 'max': 10, 'instruction': '10 palavras: paciente não recorda = 1 ponto cada (0-10 pontos)'},
    {'title': 'Comandos', 'max': 5, 'instruction': 'Pontuação por erros nos comandos (0-5 pontos)'},
    {'title': 'Nomear Objetos', 'max': 5, 'instruction': 'Pontuação por erros na nomeação (0-5 pontos)'},
    {'title': 'Construção de Figuras', 'max': 5, 'instruction': 'Pontuação por erros na construção (0-5 pontos)'},
    {'title': 'Ideação', 'max': 5, 'instruction': 'Pontuação por dificuldades em ideação (0-5 pontos)'},
    {'title': 'Orientação', 'max': 8, 'instruction': 'Pontuação por erros de orientação (0-8 pontos)'},
    {'title': 'Reconhecimento de Palavras', 'max': 12, 'instruction': 'Pontuação por palavras não reconhecidas (0-12 pontos)'},
    {'title': 'Linguagem', 'max': 5, 'instruction': 'Pontuação por dificuldades linguísticas (0-5 pontos)'},
    {'title': 'Compreensão de Linguagem', 'max': 5, 'instruction': 'Pontuação por erros de compreensão (0-5 pontos)'},
    {'title': 'Encontrar Palavras', 'max': 5, 'instruction': 'Pontuação por dificuldades em encontrar palavras (0-5 pontos)'},
    {'title': 'Tarefas de Praxia', 'max': 5, 'instruction': 'Pontuação por erros em tarefas práticas (0-5 pontos)'},
  ];

  Future<void> _salvarADASCog() async {
    try {
      final score = CompletedScore(
        scoreName: 'ADAS-Cog',
        scoreData: {
          'recordacaoPalavras': _data.recordacaoPalavras,
          'comandos': _data.comandos,
          'nomearObjetos': _data.nomearObjetos,
          'construcaoFigura': _data.construcaoFigura,
          'ideacao': _data.ideacao,
          'orientacao': _data.orientacao,
          'reconhecimentoPalavras': _data.reconhecimentoPalavras,
          'linguagem': _data.linguagem,
          'compreensaoLinguagem': _data.compreensaoLinguagem,
          'encontrarPalavras': _data.encontrarPalavras,
          'tarefasPraxia': _data.tarefasPraxia,
        },
        resultado: '${_data.totalScore}/70 - ${_data.interpretation} (Nota: Quanto maior, pior)',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ADAS-Cog salva com sucesso!'),
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

  Widget _buildTaskItem(int index, Map<String, dynamic> task, int value, ValueChanged<int> onChanged) {
    final items = [
      _data.recordacaoPalavras, _data.comandos, _data.nomearObjetos, _data.construcaoFigura,
      _data.ideacao, _data.orientacao, _data.reconhecimentoPalavras, _data.linguagem,
      _data.compreensaoLinguagem, _data.encontrarPalavras, _data.tarefasPraxia,
    ];
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index + 1}. ${task['title']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            if (task['instruction'] != null) ...[
              const SizedBox(height: 4),
              Text(task['instruction'], style: TextStyle(fontSize: 9, color: Colors.grey.shade700)),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('0 (sem erros)', style: TextStyle(fontSize: 10)),
                Text('${items[index]}/${task['max']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('${task['max']} (máx)', style: const TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: items[index].toDouble(),
              min: 0,
              max: task['max'].toDouble(),
              divisions: task['max'],
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.red.shade700,
            ),
            const SizedBox(height: 4),
            Text('⚠️ ADAS-Cog: Quanto maior a pontuação, pior o desempenho', style: TextStyle(fontSize: 9, color: Colors.red.shade700, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADAS-Cog'),
        centerTitle: true,
        backgroundColor: Colors.red.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.red.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Importante', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(
                    'ADAS-Cog avalia erros e dificuldades. QUANTO MAIOR a pontuação, PIOR o desempenho cognitivo.\n'
                    'Pontuação máxima: 70 (máximo de comprometimento)',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          ...List.generate(11, (i) {
            final items = [
              _data.recordacaoPalavras, _data.comandos, _data.nomearObjetos, _data.construcaoFigura,
              _data.ideacao, _data.orientacao, _data.reconhecimentoPalavras, _data.linguagem,
              _data.compreensaoLinguagem, _data.encontrarPalavras, _data.tarefasPraxia,
            ];
            final setters = [
              (v) => setState(() => _data.recordacaoPalavras = v),
              (v) => setState(() => _data.comandos = v),
              (v) => setState(() => _data.nomearObjetos = v),
              (v) => setState(() => _data.construcaoFigura = v),
              (v) => setState(() => _data.ideacao = v),
              (v) => setState(() => _data.orientacao = v),
              (v) => setState(() => _data.reconhecimentoPalavras = v),
              (v) => setState(() => _data.linguagem = v),
              (v) => setState(() => _data.compreensaoLinguagem = v),
              (v) => setState(() => _data.encontrarPalavras = v),
              (v) => setState(() => _data.tarefasPraxia = v),
            ];
            return _buildTaskItem(i, _tasks[i], items[i], setters[i]);
          }),
          const SizedBox(height: 16),
          Card(
            color: score <= 9 ? Colors.green : score <= 18 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('ADAS-Cog Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/70', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('⚠️ Quanto maior, pior', style: TextStyle(fontSize: 12, color: Colors.white70, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarADASCog,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala ADAS-Cog'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

