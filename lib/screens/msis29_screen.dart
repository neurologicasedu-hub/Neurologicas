import 'package:flutter/material.dart';
import '../models/msis29_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class MSIS29Screen extends StatefulWidget {
  const MSIS29Screen({super.key});

  @override
  State<MSIS29Screen> createState() => _MSIS29ScreenState();
}

class _MSIS29ScreenState extends State<MSIS29Screen> {
  final MSIS29Data _data = MSIS29Data();

  static const List<String> _itensFisicos = [
    'Tarefas com esforço físico',
    'Segurar coisas com firmeza',
    'Carregar coisas',
    'Problemas com equilíbrio',
    'Locomoção em ambientes fechados',
    'Atitudes desastradas',
    'Rigidez nas articulações',
    'Braços/pernas pesados',
    'Tremores nos braços/pernas',
    'Espasmos musculares',
    'Corpo não obedece comando',
    'Depender de outros',
    'Limitações vida social/lazer em casa',
    'Ficar em casa mais tempo',
    'Dificuldade usar mãos',
    'Reduzir tempo de trabalho/atividades',
    'Dificuldade transporte',
    'Demorar mais tempo',
    'Dificuldade planejar',
    'Urgência banheiro',
  ];

  static const List<String> _itensPsicologicos = [
    'Desânimo',
    'Problemas para dormir',
    'Cansaço mental',
    'Preocupações com EM',
    'Ansiedade/Tensão',
    'Irritabilidade/Mau humor',
    'Problemas de concentração',
    'Falta de confiança',
    'Depressão',
  ];

  Future<void> _salvarMSIS29() async {
    try {
      final score = CompletedScore(
        scoreName: 'MSIS-29',
        scoreData: {
          'percentualTotal': _data.percentualTotal,
          'percentualFisico': _data.percentualFisico,
          'percentualPsicologico': _data.percentualPsicologico,
        },
        resultado: '${_data.percentualTotal.toStringAsFixed(1)}% - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala MSIS-29 salva com sucesso!'),
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
    final percentual = _data.percentualTotal;
    return CalculatorScaffold(
      title: 'MSIS-29',
      body: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Escala de Impacto da Esclerose Múltipla.\nNas últimas duas semanas, o quanto a EM limitou você?',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),

        _buildSectionHeader('Domínio Físico'),
        ...List.generate(_itensFisicos.length, (i) => _buildQuestionItem((i + 1).toString(), _itensFisicos[i], _data.fisico[i], (v) => setState(() => _data.fisico[i] = v))),

        _buildSectionHeader('Domínio Psicológico'),
        ...List.generate(_itensPsicologicos.length, (i) => _buildQuestionItem((i + 21).toString(), _itensPsicologicos[i], _data.psicologico[i], (v) => setState(() => _data.psicologico[i] = v))),
        
        // Result Card
        Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(percentual),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(percentual).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('MSIS-29 IMPACTO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '${percentual.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const SizedBox(height: 12),
                Text(
                  'Físico: ${_data.percentualFisico.toStringAsFixed(1)}% | Psicológico: ${_data.percentualPsicologico.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                 const SizedBox(height: 12),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                   child: Text(
                    _data.interpretation,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarMSIS29,
        backgroundColor: Colors.cyan,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 20),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.cyan.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildQuestionItem(String number, String question, int value, ValueChanged<int> onChanged) {
    return QuestionCard<int>(
      title: '$number. $question',
      value: value,
      onChanged: onChanged,
      options: const [
        QuestionOption(label: '1 - Nada', value: 1),
        QuestionOption(label: '2 - Um pouco', value: 2),
        QuestionOption(label: '3 - Moderadamente', value: 3),
        QuestionOption(label: '4 - Bastante', value: 4),
        QuestionOption(label: '5 - Extremamente', value: 5),
      ],
    );
  }

  Color _getScoreColor(double percentual) {
    if (percentual <= 25) return Colors.green;
    if (percentual <= 50) return Colors.orange;
    return Colors.red;
  }
}