import 'package:flutter/material.dart';
import '../models/midas_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class MIDASScreen extends StatefulWidget {
  const MIDASScreen({super.key});

  @override
  State<MIDASScreen> createState() => _MIDASScreenState();
}

class _MIDASScreenState extends State<MIDASScreen> {
  final MIDASData _data = MIDASData();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  final List<String> _questions = [
    'Quantos dias nas últimas 3 meses você teve capacidade reduzida para trabalhar ou estudar por causa da enxaqueca?',
    'Quantos dias nas últimas 3 meses você teve capacidade reduzida para realizar atividades domésticas por causa da enxaqueca?',
    'Quantos dias nas últimas 3 meses você ficou completamente impossibilitado(a) de participar de atividades familiares, sociais ou de lazer por causa da enxaqueca?',
    'Quantos dias nas últimas 3 meses você ficou completamente incapacitado(a) por causa da enxaqueca?',
  ];

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  Future<void> _salvarMIDAS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Migraine Disability Assessment (MIDAS)',
        scoreData: {
          'diasEscolaTrabalho': _data.diasEscolaTrabalho,
          'diasAtividadesDomesticas': _data.diasAtividadesDomesticas,
          'diasAtividadesFamiliares': _data.diasAtividadesFamiliares,
          'diasCompletamenteIncapacitado': _data.diasCompletamenteIncapacitado,
        },
        resultado: '${_data.totalScore} pontos - ${_data.interpretation} (${_data.classificacaoMIDAS})',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala MIDAS salva com sucesso!'),
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
      title: 'MIDAS',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Nas últimas 3 meses, quantos dias você teve problemas por causa da enxaqueca?',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          _buildQuestionItem(0, _questions[0], _controller1, (v) => setState(() => _data.diasEscolaTrabalho = v)),
          _buildQuestionItem(1, _questions[1], _controller2, (v) => setState(() => _data.diasAtividadesDomesticas = v)),
          _buildQuestionItem(2, _questions[2], _controller3, (v) => setState(() => _data.diasAtividadesFamiliares = v)),
          _buildQuestionItem(3, _questions[3], _controller4, (v) => setState(() => _data.diasCompletamenteIncapacitado = v)),

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
                const Text('MIDAS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const Text(
                  'dias',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                   child: Text(
                    '${_data.classificacaoMIDAS}\n${_data.interpretation}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarMIDAS,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildQuestionItem(int index, String question, TextEditingController controller, ValueChanged<int> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. $question',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Número de dias (0-90)',
                hintText: 'Ex: 5',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              onChanged: (value) {
                final dias = int.tryParse(value) ?? 0;
                if (dias >= 0 && dias <= 90) {
                  onChanged(dias);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 5) return Colors.green;
    if (score <= 10) return Colors.lightGreen;
    if (score <= 20) return Colors.orange;
    return Colors.red;
  }
}
