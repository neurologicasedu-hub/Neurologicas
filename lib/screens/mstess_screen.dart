import 'package:flutter/material.dart';
import '../models/mstess_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class MSTESSScreen extends StatefulWidget {
  const MSTESSScreen({super.key});
  @override
  State<MSTESSScreen> createState() => _MSTESSScreenState();
}

class _MSTESSScreenState extends State<MSTESSScreen> {
  final MSTESSData _data = MSTESSData();

  Future<void> _salvarMSTESS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Modified STESS (mSTESS)',
        scoreData: {
          'idade': _data.idade,
          'historiaEpilepsia': _data.historiaEpilepsia,
          'tipoSE': _data.tipoSE,
          'nivelConsciencia': _data.nivelConsciencia,
          'horaInicio': _data.horaInicio,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala mSTESS salva com sucesso!'),
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
    final score = _data.totalScore;

    return CalculatorScaffold(
      title: 'mSTESS',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Modified Status Epilepticus Severity Score',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildSelectionItem('Idade', ['<40 anos (0)', '40-59 anos (1)', '≥60 anos (2)'], _data.idade, (val) => setState(() => _data.idade = val)),
          _buildSelectionItem('História de Epilepsia', ['Não (0)', 'Sim (1)'], _data.historiaEpilepsia, (val) => setState(() => _data.historiaEpilepsia = val)),
          _buildSelectionItem('Tipo de SE', ['Focal Simpl/Compl (0)', 'Generalizado (1)', 'Convulsivo (2)', 'Refratário (3)'], _data.tipoSE, (val) => setState(() => _data.tipoSE = val)),
          _buildSelectionItem('Nível de Consciência', ['Alerta/Confuso (0)', 'Estupor/Coma (1)'], _data.nivelConsciencia, (val) => setState(() => _data.nivelConsciencia = val)),
          _buildSelectionItem('Tempo de Início', ['≤1 hora (0)', '>1 hora (1)'], _data.horaInicio, (val) => setState(() => _data.horaInicio = val)),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(score),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(score).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('mSTESS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 12),
                 Text(
                  _data.interpretacao,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarMSTESS,
        backgroundColor: Colors.purpleAccent.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSelectionItem(String title, List<String> options, int selectedIndex, ValueChanged<int> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.purpleAccent.shade700)),
          ),
          ...List.generate(options.length, (index) {
             final isSelected = selectedIndex == index;
             return InkWell(
               onTap: () => onChanged(index),
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                 color: isSelected ? Colors.purple.shade50 : null,
                 child: Row(
                   children: [
                     Icon(
                       isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                       color: isSelected ? Colors.purpleAccent.shade700 : Colors.grey,
                     ),
                     const SizedBox(width: 12),
                     Expanded(child: Text(options[index], style: TextStyle(
                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                       color: isSelected ? Colors.purple.shade900 : Colors.black87,
                     ))),
                   ],
                 ),
               ),
             );
          }),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 3) return Colors.green;
    if (score <= 5) return Colors.orange;
    return Colors.red;
  }
}
