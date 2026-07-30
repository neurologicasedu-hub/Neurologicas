import 'package:flutter/material.dart';
import '../models/mrc_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class MRCScreen extends StatefulWidget {
  const MRCScreen({super.key});

  @override
  State<MRCScreen> createState() => _MRCScreenState();
}

class _MRCScreenState extends State<MRCScreen> {
  final MRCData _data = MRCData();

  Future<void> _salvarMRC() async {
    try {
      final score = CompletedScore(
        scoreName: 'MRC Scale (Medical Research Council)',
        scoreData: {
          'ombroEsquerdo': _data.ombroEsquerdo,
          'ombroDireito': _data.ombroDireito,
          'cotoveloEsquerdo': _data.cotoveloEsquerdo,
          'cotoveloDireito': _data.cotoveloDireito,
          'punhoEsquerdo': _data.punhoEsquerdo,
          'punhoDireito': _data.punhoDireito,
          'quadrilEsquerdo': _data.quadrilEsquerdo,
          'quadrilDireito': _data.quadrilDireito,
          'joelhoEsquerdo': _data.joelhoEsquerdo,
          'joelhoDireito': _data.joelhoDireito,
          'tornozeloEsquerdo': _data.tornozeloEsquerdo,
          'tornozeloDireito': _data.tornozeloDireito,
        },
        resultado: 'Score médio: ${_data.averageScore.toStringAsFixed(2)}/5.0 - ${_data.interpretation}',
        totalScore: (_data.averageScore * 10).round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala MRC salva com sucesso!'),
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
    final avgScore = _data.averageScore;
    return CalculatorScaffold(
      title: 'Força Muscular (MRC)',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Escala de Força Muscular (0-5) para membros superiores e inferiores.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          _buildSectionHeader('Membros Superiores (Direito)'),
          _buildQuestion('Ombro (Abdução) - D', _data.ombroDireito, (v) => setState(() => _data.ombroDireito = v)),
          _buildQuestion('Cotovelo (Flexão) - D', _data.cotoveloDireito, (v) => setState(() => _data.cotoveloDireito = v)),
          _buildQuestion('Punho (Extensão) - D', _data.punhoDireito, (v) => setState(() => _data.punhoDireito = v)),

          _buildSectionHeader('Membros Superiores (Esquerdo)'),
          _buildQuestion('Ombro (Abdução) - E', _data.ombroEsquerdo, (v) => setState(() => _data.ombroEsquerdo = v)),
          _buildQuestion('Cotovelo (Flexão) - E', _data.cotoveloEsquerdo, (v) => setState(() => _data.cotoveloEsquerdo = v)),
          _buildQuestion('Punho (Extensão) - E', _data.punhoEsquerdo, (v) => setState(() => _data.punhoEsquerdo = v)),

          _buildSectionHeader('Membros Inferiores (Direito)'),
          _buildQuestion('Quadril (Flexão) - D', _data.quadrilDireito, (v) => setState(() => _data.quadrilDireito = v)),
          _buildQuestion('Joelho (Extensão) - D', _data.joelhoDireito, (v) => setState(() => _data.joelhoDireito = v)),
          _buildQuestion('Tornozelo (Dorsiflexão) - D', _data.tornozeloDireito, (v) => setState(() => _data.tornozeloDireito = v)),

          _buildSectionHeader('Membros Inferiores (Esquerdo)'),
          _buildQuestion('Quadril (Flexão) - E', _data.quadrilEsquerdo, (v) => setState(() => _data.quadrilEsquerdo = v)),
          _buildQuestion('Joelho (Extensão) - E', _data.joelhoEsquerdo, (v) => setState(() => _data.joelhoEsquerdo = v)),
          _buildQuestion('Tornozelo (Dorsiflexão) - E', _data.tornozeloEsquerdo, (v) => setState(() => _data.tornozeloEsquerdo = v)),

          // Result Card
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(avgScore),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(avgScore).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('SCORE MÉDIO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  avgScore.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const Text(
                  '/ 5.0',
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
        onPressed: _salvarMRC,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12, top: 16),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.green.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildQuestion(String title, int value, ValueChanged<int> onChanged) {
    return QuestionCard<int>(
      title: title,
      value: value,
      onChanged: onChanged,
      options: const [
        QuestionOption(label: '5 - Normal (100%)', value: 5),
        QuestionOption(label: '4 - Vence resist. (75%)', value: 4),
        QuestionOption(label: '3 - Vence gravidade (50%)', value: 3),
        QuestionOption(label: '2 - Sem gravidade (25%)', value: 2),
        QuestionOption(label: '1 - Traço cont. (10%)', value: 1),
        QuestionOption(label: '0 - Nenhuma (0%)', value: 0),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 4.5) return Colors.green;
    if (score >= 3.0) return Colors.orange;
    return Colors.red;
  }
}
