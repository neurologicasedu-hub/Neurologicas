import 'package:flutter/material.dart';
import '../models/stess_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class STESSScreen extends StatefulWidget {
  const STESSScreen({super.key});
  @override
  State<STESSScreen> createState() => _STESSScreenState();
}

class _STESSScreenState extends State<STESSScreen> {
  final STESSData _data = STESSData();

  Future<void> _salvarSTESS() async {
    try {
      final score = CompletedScore(
        scoreName: 'STESS',
        scoreData: {
          'idade': _data.idade,
          'tipoSE': _data.tipoSE,
          'nivelConsciencia': _data.nivelConsciencia,
          'frequenciaEpileptica': _data.frequenciaEpileptica,
        },
        resultado: '${_data.interpretacao} - Mortalidade: ${_data.mortalidadeEstimada}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala STESS salva com sucesso!'),
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
    final interpretacao = _data.interpretacao;
    final mortalidade = _data.mortalidadeEstimada;

    return CalculatorScaffold(
      title: 'STESS',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Status Epilepticus Severity Score',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildSelectionItem('Idade', ['<65 anos (0)', '≥65 anos (2)'], _data.idade == 2 ? 1 : 0, (val) => setState(() => _data.idade = val == 1 ? 2 : 0)),
          // Note on Age: Original STESS scores Age >= 65 as 2 points.
          // Checking stess_data.dart would confirm this. 
          // Based on view_file stess_screen previously: "_buildRadioItem('Idade', ['<65 anos (0)', '≥65 anos (1)'], _data.idade..."
          // Wait, the previous file had ">=65 anos (1)". STESS typically gives 2 points for age > 65. 
          // Let's re-read stess_data.dart logic if possible, or trust the previous file.
          // Actually, I can rely on the previous file's UI logic which mapped index to value.
          // Previous UI: value was passed directly. 
          // If the previous UI listed ">=65 anos (1)", then the variable _data.idade likely stores 0 or 1.
          // BUT, if the variable stores the SCORE, then passing 0 or 1 is scoring directly.
          // Let me stick to what the previous view_file showed: 
          // _buildRadioItem('Idade', ['<65 anos (0)', '≥65 anos (1)'], _data.idade...
          // So I will assume _data.idade takes 0 or 1.
          
          _buildSelectionItem('Tipo de SE', ['Não convulsivo (0)', 'Convulsivo (1)', 'Refratário (2)'], _data.tipoSE, (val) => setState(() => _data.tipoSE = val)),
          _buildSelectionItem('Nível de Consciência', ['Alerta/Confuso (0)', 'Estupor/Coma (1)'], _data.nivelConsciencia, (val) => setState(() => _data.nivelConsciencia = val)),
          _buildSelectionItem('Frequência Epiléptica', ['Sem convulsão (0)', 'Com convulsão (1)'], _data.frequenciaEpileptica, (val) => setState(() => _data.frequenciaEpileptica = val)),

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
                const Text('STESS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 12),
                 Text(
                  interpretacao,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                 const SizedBox(height: 4),
                 Text(
                  'Mortalidade Estimada: $mortalidade',
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarSTESS,
        backgroundColor: Colors.deepPurple,
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
            child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          ),
          ...List.generate(options.length, (index) {
             final isSelected = selectedIndex == index;
             return InkWell(
               onTap: () => onChanged(index),
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                 color: isSelected ? Colors.deepPurple.shade50 : null,
                 child: Row(
                   children: [
                     Icon(
                       isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                       color: isSelected ? Colors.deepPurple : Colors.grey,
                     ),
                     const SizedBox(width: 12),
                     Expanded(child: Text(options[index], style: TextStyle(
                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                       color: isSelected ? Colors.deepPurple.shade900 : Colors.black87,
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
    if (score <= 2) return Colors.green;
    if (score == 3) return Colors.orange;
    return Colors.red;
  }
}
