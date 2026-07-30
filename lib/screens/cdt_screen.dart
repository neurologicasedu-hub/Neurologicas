import 'package:flutter/material.dart';
import '../models/cdt_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class CDTScreen extends StatefulWidget {
  const CDTScreen({super.key});

  @override
  State<CDTScreen> createState() => _CDTScreenState();
}

class _CDTScreenState extends State<CDTScreen> {
  final CDTData _data = CDTData();

  Future<void> _salvarCDT() async {
    try {
      final score = CompletedScore(
        scoreName: 'Clock Drawing Test (CDT)',
        scoreData: {
          'contornoRelogio': _data.contornoRelogio,
          'numerosPresentes': _data.numerosPresentes,
          'numerosCorretos': _data.numerosCorretos,
          'ponteirosPresentes': _data.ponteirosPresentes,
          'horarioCorreto': _data.horarioCorreto,
        },
        resultado: '${_data.totalScore}/10 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala CDT salva com sucesso!'),
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

  Widget _buildSliderItem(String title, String description, int value, int max, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          if (description.isNotEmpty)
             Padding(
               padding: const EdgeInsets.only(top: 4),
               child: Text(description, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
             ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('0', style: TextStyle(fontSize: 11)),
              Text('$value/$max', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text('$max', style: const TextStyle(fontSize: 11)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.blue.shade700, thumbColor: Colors.blue.shade700),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: max.toDouble(),
              divisions: max,
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
      title: 'Clock Drawing Test',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Desenhe um relógio (ex: 11:10) e avalie:',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSliderItem(
                    '1. Contorno do Relógio',
                    '2 pts: circular fechado\n1 pt: disforme\n0 pts: sem contorno',
                    _data.contornoRelogio, 2, (v) => setState(() => _data.contornoRelogio = v),
                  ),
                  _buildSliderItem(
                    '2. Números Presentes',
                    '4 pts: 12 nums\n3 pts: 10-11 nums\n2 pts: 8-9 nums\n1 pt: 5-7 nums\n0 pts: <5',
                    _data.numerosPresentes, 4, (v) => setState(() => _data.numerosPresentes = v),
                  ),
                  _buildSliderItem(
                    '3. Posição dos Números',
                    '4 pts: perfeito\n3 pts: peq. erro\n2 pts: erro mod\n1 pt: erro grave\n0 pts: caos',
                    _data.numerosCorretos, 4, (v) => setState(() => _data.numerosCorretos = v),
                  ),
                  _buildSliderItem(
                    '4. Ponteiros Presentes',
                    '2 pts: 2 distintos\n1 pt: 1 ou indistintos\n0 pts: nenhum',
                    _data.ponteirosPresentes, 2, (v) => setState(() => _data.ponteirosPresentes = v),
                  ),
                  _buildSliderItem(
                    '5. Horário Correto',
                    '3 pts: exato\n2 pts: erro <15min\n1 pt: erro >15min\n0 pts: errado',
                    _data.horarioCorreto, 3, (v) => setState(() => _data.horarioCorreto = v),
                  ),
                ],
              ),
            ),
          ),
          
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score >= 8 ? Colors.green : score >= 5 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score >= 8 ? Colors.green : score >= 5 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('CDT SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$score', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 12),
                Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarCDT,
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
