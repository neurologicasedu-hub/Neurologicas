import 'package:flutter/material.dart';
import '../models/ais_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class AISScreen extends StatefulWidget {
  const AISScreen({super.key});

  @override
  State<AISScreen> createState() => _AISScreenState();
}

class _AISScreenState extends State<AISScreen> {
  final AISData _data = AISData();

  Future<void> _salvarAIS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Abbreviated Injury Scale (AIS)',
        scoreData: {
          'cabecaPescoco': _data.cabecaPescoco,
          'face': _data.face,
          'torax': _data.torax,
          'abdomen': _data.abdomen,
          'extremidades': _data.extremidades,
          'externo': _data.externo,
        },
        resultado: '${_data.severidadeGeral} - ${_data.interpretacao}',
        totalScore: _data.maxAIS,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala AIS salva com sucesso!'),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(title, style: const TextStyle(fontSize: 14)),
               Text('$value/6', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent)),
             ],
           ),
           SliderTheme(
             data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.redAccent, thumbColor: Colors.redAccent),
             child: Slider(
               value: value.toDouble(),
               min: 1, max: 6, divisions: 5,
               onChanged: (val) => onChanged(val.toInt()),
             ),
           ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxAIS = _data.maxAIS;
    return CalculatorScaffold(
      title: 'AIS - Abbreviated Injury Scale',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Avalie a gravidade da lesão por região (1-6)',
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
                  _buildSliderItem('Cabeça e Pescoço', _data.cabecaPescoco, (val) => setState(() => _data.cabecaPescoco = val)),
                  _buildSliderItem('Face', _data.face, (val) => setState(() => _data.face = val)),
                  _buildSliderItem('Tórax', _data.torax, (val) => setState(() => _data.torax = val)),
                  _buildSliderItem('Abdome', _data.abdomen, (val) => setState(() => _data.abdomen = val)),
                  _buildSliderItem('Extremidades', _data.extremidades, (val) => setState(() => _data.extremidades = val)),
                  _buildSliderItem('Externo', _data.externo, (val) => setState(() => _data.externo = val)),
                ],
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: maxAIS <= 2 ? Colors.green : maxAIS == 3 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (maxAIS <= 2 ? Colors.green : maxAIS == 3 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('MAX AIS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$maxAIS', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 12),
                Text(_data.severidadeGeral, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(_data.interpretacao, style: const TextStyle(fontSize: 12, color: Colors.white70), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarAIS,
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
