import 'package:flutter/material.dart';
import '../models/lundberg_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class LundbergScreen extends StatefulWidget {
  const LundbergScreen({super.key});

  @override
  State<LundbergScreen> createState() => _LundbergScreenState();
}

class _LundbergScreenState extends State<LundbergScreen> {
  final LundbergData _data = LundbergData();

  Future<void> _salvarLundberg() async {
    try {
      final score = CompletedScore(
        scoreName: 'Lundberg Waves (ICP)',
        scoreData: {
          'tipoOnda': _data.tipoOnda,
          'amplitude': _data.amplitude,
          'frequencia': _data.frequencia,
          'duracao': _data.duracao,
        },
        resultado: '${_data.interpretacao} - ${_data.condutaRecomendada}',
        totalScore: null,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Lundberg salva com sucesso!'),
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
    final descricao = _data.descricaoOnda;
    final interpretacao = _data.interpretacao;
    final conduta = _data.condutaRecomendada;

    return CalculatorScaffold(
      title: 'Lundberg Waves',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Padrões de ondas de Pressão Intracraniana (ICP).',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          
          QuestionCard<String>(
            title: 'Tipo de Onda Identificado',
            value: _data.tipoOnda, // This needs to match the value types in options
            onChanged: (v) {
              setState(() => _data.tipoOnda = v);
              // LundbergData handles updates internally or just getters?
              // The original code reset data fields based on setters or just used type to get description.
              // Assuming setters work or getters are computed from typeOnda.
            },
            options: const [
              QuestionOption(label: 'Normal', value: 'normal'),
              QuestionOption(label: 'Ondas C (Variações Traube-Hering)', value: 'C'),
              QuestionOption(label: 'Ondas B (Oscilações rítmicas)', value: 'B'),
              QuestionOption(label: 'Ondas A (Plateau Waves)', value: 'A'),
            ],
          ),

          // Display info about the wave
          Container(
             margin: const EdgeInsets.symmetric(vertical: 16),
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(16),
               border: Border.all(color: Colors.grey.shade200),
               boxShadow: [
                 BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
               ],
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('Descrição: $descricao', style: const TextStyle(fontSize: 14, color: Colors.black87)),
                 const SizedBox(height: 8),
                 Text('Interpretação: $interpretacao', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _getScoreColor(_data.tipoOnda))),
               ],
             ),
           ),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(_data.tipoOnda),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(_data.tipoOnda).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('CONDUTA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                   child: Text(
                      conduta,
                      style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                 ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarLundberg,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getScoreColor(String tipo) {
    switch (tipo) {
      case 'A':
        return Colors.red;
      case 'B':
        return Colors.orange;
      case 'C':
      case 'normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
