import 'package:flutter/material.dart';
import '../models/edss_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class EDSSScreen extends StatefulWidget {
  const EDSSScreen({super.key});

  @override
  State<EDSSScreen> createState() => _EDSSScreenState();
}

class _EDSSScreenState extends State<EDSSScreen> {
  final EDSSData _data = EDSSData();

  Future<void> _salvarEDSS() async {
    try {
      final score = CompletedScore(
        scoreName: 'EDSS (Expanded Disability Status Scale)',
        scoreData: {'edssScore': _data.edssScore},
        resultado: 'EDSS: ${_data.edssScore} - ${_data.edssDescription} - ${_data.interpretation}',
        totalScore: (_data.edssScore * 10).round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala EDSS salva com sucesso!'),
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
    return CalculatorScaffold(
      title: 'EDSS',
      body: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Escala Expandida do Status de Incapacidade (Kurtzke).',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),

        QuestionCard<double>(
          title: 'Pontuação EDSS',
          subtitle: 'Selecione a descrição que melhor se aplica.',
          value: _data.edssScore,
          onChanged: (v) => setState(() => _data.edssScore = v),
          options: const [
            QuestionOption(label: '0.0 - Exame neurológico normal', value: 0.0),
            QuestionOption(label: '1.0 - Sem incapacidade, sinais mínimos', value: 1.0),
            QuestionOption(label: '1.5 - Sinais mínimos (>1 Sistema Funcional)', value: 1.5),
            QuestionOption(label: '2.0 - Incapacidade mínima (1 SF)', value: 2.0),
            QuestionOption(label: '2.5 - Incapacidade leve (1 SF) ou mínima (2 SFs)', value: 2.5),
            QuestionOption(label: '3.0 - Incapacidade moderada (1 SF) ou leve (3-4 SFs)', value: 3.0),
            QuestionOption(label: '3.5 - Ambulatorial total; moderada (1 SF) + >1 leve', value: 3.5),
            QuestionOption(label: '4.0 - Ambulatorial s/ ajuda 500m', value: 4.0),
            QuestionOption(label: '4.5 - Ambulatorial s/ ajuda 300m; trabalha dia todo', value: 4.5),
            QuestionOption(label: '5.0 - Ambulatorial s/ ajuda 200m; afeta dia a dia', value: 5.0),
            QuestionOption(label: '5.5 - Ambulatorial s/ ajuda 100m; afeta dia a dia', value: 5.5),
            QuestionOption(label: '6.0 - Ajuda unilateral (bengala) para 100m', value: 6.0),
            QuestionOption(label: '6.5 - Ajuda bilateral (andador/muletas) para 20m', value: 6.5),
            QuestionOption(label: '7.0 - Cadeira de rodas; caminha < 5m com ajuda', value: 7.0),
            QuestionOption(label: '7.5 - Restrito cadeira rodas; poucos passos', value: 7.5),
            QuestionOption(label: '8.0 - Restrito cama/cadeira; usa braços', value: 8.0),
            QuestionOption(label: '8.5 - Restrito leito maior parte do dia; algum uso braço', value: 8.5),
            QuestionOption(label: '9.0 - Acamado; comunica/come', value: 9.0),
            QuestionOption(label: '9.5 - Acamado; dep. total', value: 9.5),
            QuestionOption(label: '10.0 - Morte por EM', value: 10.0),
          ],
        ),

        if (_data.edssScore >= 0)
          Container(
             margin: const EdgeInsets.only(top: 16, bottom: 24),
             padding: const EdgeInsets.all(24),
             decoration: BoxDecoration(
               color: Colors.indigo.shade50,
               borderRadius: BorderRadius.circular(24),
               boxShadow: [
                 BoxShadow(color: Colors.indigo.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8)),
               ],
             ),
             child: Column(
               children: [
                 const Text('EDSS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
                 const SizedBox(height: 8),
                 Text(
                   _data.edssScore.toStringAsFixed(1),
                   style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.indigo, height: 1),
                 ),
                 const SizedBox(height: 12),
                 Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                     _data.interpretation,
                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.indigo),
                     textAlign: TextAlign.center,
                   ),
                 ),
               ],
             ),
           ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarEDSS,
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}