import 'package:flutter/material.dart';
import '../models/seos_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class SEOSScreen extends StatefulWidget {
  const SEOSScreen({super.key});
  @override
  State<SEOSScreen> createState() => _SEOSScreenState();
}

class _SEOSScreenState extends State<SEOSScreen> {
  final SEOSData _data = SEOSData();

  Future<void> _salvarSEOS() async {
    try {
      final score = CompletedScore(
        scoreName: 'SEOS',
        scoreData: {
          'idade': _data.idade,
          'tipoSE': _data.tipoSE,
          'nivelConsciencia': _data.nivelConsciencia,
          'duracaoSE': _data.duracaoSE,
          'etiologia': _data.etiologia,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala SEOS salva com sucesso!'),
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
      title: 'SEOS',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Status Epilepticus Outcome Score',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildSelectionItem('Idade', ['<65 anos (0)', '≥65 anos (1)'], _data.idade, (val) => setState(() => _data.idade = val)),
          _buildSelectionItem('Tipo de SE', ['Não convulsivo (0)', 'Convulsivo (1)'], _data.tipoSE, (val) => setState(() => _data.tipoSE = val)),
          _buildSelectionItem('Nível de Consciência', ['Alerta/Confuso (0)', 'Estupor/Coma (1)'], _data.nivelConsciencia, (val) => setState(() => _data.nivelConsciencia = val)),
          _buildSelectionItem('Duração do SE', ['<24 horas (0)', '≥24 horas (1)'], _data.duracaoSE, (val) => setState(() => _data.duracaoSE = val)),
          _buildSelectionItem('Etiologia', ['Não estrutural (0)', 'Estrutural (1)'], _data.etiologia, (val) => setState(() => _data.etiologia = val)),

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
                const Text('SEOS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
        onPressed: _salvarSEOS,
        backgroundColor: Colors.indigo,
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
            child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo)),
          ),
          ...List.generate(options.length, (index) {
             final isSelected = selectedIndex == index;
             return InkWell(
               onTap: () => onChanged(index),
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                 color: isSelected ? Colors.indigo.shade50 : null,
                 child: Row(
                   children: [
                     Icon(
                       isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                       color: isSelected ? Colors.indigo : Colors.grey,
                     ),
                     const SizedBox(width: 12),
                     Expanded(child: Text(options[index], style: TextStyle(
                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                       color: isSelected ? Colors.indigo.shade900 : Colors.black87,
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
    if (score <= 3) return Colors.orange;
    return Colors.red;
  }
}
