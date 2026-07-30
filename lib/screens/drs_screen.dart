import 'package:flutter/material.dart';
import '../models/drs_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class DRSScreen extends StatefulWidget {
  const DRSScreen({super.key});

  @override
  State<DRSScreen> createState() => _DRSScreenState();
}

class _DRSScreenState extends State<DRSScreen> {
  final DRSData _data = DRSData();

  Future<void> _salvarDRS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Disability Rating Scale (DRS)',
        scoreData: {
          'aberturaOcular': _data.aberturaOcular,
          'respostaVerbal': _data.respostaVerbal,
          'respostaMotora': _data.respostaMotora,
          'alimentacaoComunicacaoHigiene': _data.alimentacaoComunicacaoHigiene,
          'funcionalidade': _data.funcionalidade,
          'empregabilidade': _data.empregabilidade,
        },
        resultado: '${_data.nivelDeficiencia} - ${_data.interpretacao}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala DRS salva com sucesso!'),
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

  Widget _buildSliderItem(String title, int value, int max, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
               Text('$value/$max', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.pink.shade700)),
             ],
           ),
           SliderTheme(
             data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.pink, thumbColor: Colors.pink),
             child: Slider(
               value: value.toDouble(),
               min: 0, max: max.toDouble(), divisions: max,
               onChanged: (val) => onChanged(val.toInt()),
             ),
           ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'DRS - Disability Rating Scale',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Avaliação de Deficiência e Recuperação (0-29)',
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
                  _buildSliderItem('Abertura Ocular (0-3)', _data.aberturaOcular, 3, (val) => setState(() => _data.aberturaOcular = val)),
                  _buildSliderItem('Resposta Verbal (0-4)', _data.respostaVerbal, 4, (val) => setState(() => _data.respostaVerbal = val)),
                  _buildSliderItem('Resposta Motora (0-5)', _data.respostaMotora, 5, (val) => setState(() => _data.respostaMotora = val)),
                  _buildSliderItem('Autocuidado (0-3)', _data.alimentacaoComunicacaoHigiene, 3, (val) => setState(() => _data.alimentacaoComunicacaoHigiene = val)),
                  _buildSliderItem('Funcionalidade (0-5)', _data.funcionalidade, 5, (val) => setState(() => _data.funcionalidade = val)),
                  _buildSliderItem('Empregabilidade (0-3)', _data.empregabilidade, 3, (val) => setState(() => _data.empregabilidade = val)),
                ],
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 5 ? Colors.green : score <= 15 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 5 ? Colors.green : score <= 15 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('DRS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                 const SizedBox(height: 8),
                Text('$score', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 12),
                Text(_data.nivelDeficiencia, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(_data.interpretacao, style: const TextStyle(fontSize: 12, color: Colors.white70), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarDRS,
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
