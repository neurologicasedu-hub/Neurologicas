import 'package:flutter/material.dart';
import '../models/adas_cog_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${index + 1}. ${task['title']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          if (task['instruction'] != null)
             Padding(
               padding: const EdgeInsets.only(top: 4),
               child: Text(task['instruction'], style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
             ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('0 (sem erros)', style: TextStyle(fontSize: 11)),
              Text('$value/${task['max']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text('${task['max']} (máx)', style: const TextStyle(fontSize: 11)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.red.shade700, thumbColor: Colors.red.shade700),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: task['max'].toDouble(),
              divisions: task['max'],
              onChanged: (val) => onChanged(val.toInt()),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'ADAS-Cog',
      body: [
          const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'ADAS-Cog avalia erros e dificuldades.\n⚠️ Quanto MAIOR a pontuação, PIOR o desempenho.',
                style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
          ),
          
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(11, (i) {
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
              ),
            ),
          ),
          
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 9 ? Colors.green : score <= 18 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 9 ? Colors.green : score <= 18 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('ADAS-Cog SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$score', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 12),
                Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarADASCog,
        backgroundColor: Colors.red.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
