import 'package:flutter/material.dart';
import '../models/gds_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class GDSScreen extends StatefulWidget {
  const GDSScreen({super.key});

  @override
  State<GDSScreen> createState() => _GDSScreenState();
}

class _GDSScreenState extends State<GDSScreen> {
  final GDSData _data = GDSData();

  final List<String> _questions = [
    'Você está satisfeito(a) com sua vida?', // Item 1 - Normal (Sim=0, Não=1)
    'Você abandonou muitas de suas atividades e interesses?', // Item 2 - Normal (Sim=1, Não=0)
    'Você sente que sua vida está vazia?', // Item 3 - Normal (Sim=1, Não=0)
    'Você se sente entediado(a) frequentemente?', // Item 4 - Normal (Sim=1, Não=0)
    'Você se sente bem a maior parte do tempo?', // Item 5 - INVERTIDO (Sim=0, Não=1)
    'Você tem medo de que algo ruim vá acontecer a você?', // Item 6 - Normal (Sim=1, Não=0)
    'Você se sente feliz a maior parte do tempo?', // Item 7 - INVERTIDO (Sim=0, Não=1)
    'Você frequentemente se sente desamparado(a)?', // Item 8 - Normal (Sim=1, Não=0)
    'Você prefere ficar em casa ao invés de sair e fazer coisas novas?', // Item 9 - Normal (Sim=1, Não=0)
    'Você acha que tem mais problemas com memória do que a maioria?', // Item 10 - Normal (Sim=1, Não=0)
    'Você acha que é maravilhoso estar vivo?', // Item 11 - INVERTIDO (Sim=0, Não=1)
    'Você se sente sem valor da forma que está?', // Item 12 - Normal (Sim=1, Não=0)
    'Você se sente cheio(a) de energia?', // Item 13 - INVERTIDO (Sim=0, Não=1)
    'Você sente que sua situação é sem esperança?', // Item 14 - Normal (Sim=1, Não=0)
    'Você acha que a maioria das pessoas está melhor que você?', // Item 15 - Normal (Sim=1, Não=0)
  ];

  Future<void> _salvarGDS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Geriatric Depression Scale (GDS-15)',
        scoreData: {'respostas': _data.respostas},
        resultado: '${_data.totalScore}/15 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala GDS salva com sucesso!'),
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

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'GDS-15',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Escala de Depressão Geriátrica (15 itens). Responda com base na última semana.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          ...List.generate(15, (i) => _buildQuestionItem(i, _questions[i], _data.respostas[i], (v) => setState(() => _data.respostas[i] = v))),
          
          // Result Card
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
                const Text('GDS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const Text(
                  '/ 15',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
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
        onPressed: _salvarGDS,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildQuestionItem(int index, String question, int value, ValueChanged<int> onChanged) {
    // Logic for inverted items (Index 0-based): 4, 6, 10, 12.
    // Standard items: Yes=1 (Depressed), No=0 (Normal) ? 
    // Wait, let's verify GDS scoring.
    // Item 1: "Are you satisfied?" Yes(0), No(1). (Normal is Yes)
    // Item 2: "Dropped activities?" Yes(1), No(0). (Depressed is Yes)
    // So "Yes=1" is standard for depressed symptoms. "Yes=0" for positive items.
    
    // GDSData model usually expects 0 or 1 score, OR raw answer?
    // Let's check `gds_data.dart` logic implicitly via `_data.respostas`.
    // The previous implementation passed `value` directly to `_data.respostas`.
    // Previous implementation RadioListTile values:
    // Sim = 1, Não = 0.
    // BUT `gds_data` calculates score. Does it handle inversion?
    // If `gds_data` expects 1=Sim, 0=Nao, and calculates score internally based on index, then I should send 1/0.
    // If `gds_data` simply sums the array, then I must send the SCORE (1 or 0) directly from the UI logic.
    // Let's check previous file `gds_screen.dart` logic:
    // `RadioListTile ... value: 1 ... title: Sim`
    // `RadioListTile ... value: 0 ... title: Não`
    // It seems it just stores 1 for Sim and 0 for No. The scoring logic must be in `GDSData`.
    // I will preserve this behavior: Send 1 for Sim, 0 for No.
    // Visuals: I should show "Sim" and "Não".
    
    return QuestionCard<int>(
      title: '${index + 1}. $question',
      value: value,
      onChanged: onChanged,
      options: const [
        QuestionOption(label: 'Sim', value: 1),
        QuestionOption(label: 'Não', value: 0),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 5) return Colors.green;
    if (score <= 10) return Colors.orange;
    return Colors.red;
  }
}
