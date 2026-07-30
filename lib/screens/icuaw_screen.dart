import 'package:flutter/material.dart';
import '../models/icuaw_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class ICUAWScreen extends StatefulWidget {
  const ICUAWScreen({super.key});
  @override
  State<ICUAWScreen> createState() => _ICUAWScreenState();
}

class _ICUAWScreenState extends State<ICUAWScreen> {
  final ICUAWData _data = ICUAWData();

  Future<void> _salvarICUAW() async {
    try {
      final score = CompletedScore(
        scoreName: 'ICUAW Scale',
        scoreData: {
          'mrcSumScore': _data.mrcSumScore,
          'ombroAbducaoDireita': _data.ombroAbducaoDireita,
          'ombroAbducaoEsquerda': _data.ombroAbducaoEsquerda,
          'cotoveloFlexaoDireita': _data.cotoveloFlexaoDireita,
          'cotoveloFlexaoEsquerda': _data.cotoveloFlexaoEsquerda,
          'punhoExtensaoDireita': _data.punhoExtensaoDireita,
          'punhoExtensaoEsquerda': _data.punhoExtensaoEsquerda,
          'quadrilFlexaoDireita': _data.quadrilFlexaoDireita,
          'quadrilFlexaoEsquerda': _data.quadrilFlexaoEsquerda,
          'joelhoExtensaoDireita': _data.joelhoExtensaoDireita,
          'joelhoExtensaoEsquerda': _data.joelhoExtensaoEsquerda,
          'tornozeloDorsiflexaoDireita': _data.tornozeloDorsiflexaoDireita,
          'tornozeloDorsiflexaoEsquerda': _data.tornozeloDorsiflexaoEsquerda,
        },
        resultado: '${_data.diagnostico} - ${_data.interpretacao}',
        totalScore: _data.mrcSumScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ICUAW salva com sucesso!'),
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
    final mrcScore = _data.mrcSumScore;

    return CalculatorScaffold(
      title: 'ICU-AW Scale',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Intensive Care Unit Acquired Weakness\nMRC Sum Score (6 grupos bilaterais)',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildMuscleSection('Ombro (Abdução)', [
            _buildMuscleSlider('Direito', _data.ombroAbducaoDireita, (v) => setState(() => _data.ombroAbducaoDireita = v)),
            _buildMuscleSlider('Esquerdo', _data.ombroAbducaoEsquerda, (v) => setState(() => _data.ombroAbducaoEsquerda = v)),
          ]),
          
          _buildMuscleSection('Cotovelo (Flexão)', [
            _buildMuscleSlider('Direito', _data.cotoveloFlexaoDireita, (v) => setState(() => _data.cotoveloFlexaoDireita = v)),
            _buildMuscleSlider('Esquerdo', _data.cotoveloFlexaoEsquerda, (v) => setState(() => _data.cotoveloFlexaoEsquerda = v)),
          ]),

          _buildMuscleSection('Punho (Extensão)', [
             _buildMuscleSlider('Direito', _data.punhoExtensaoDireita, (v) => setState(() => _data.punhoExtensaoDireita = v)),
             _buildMuscleSlider('Esquerdo', _data.punhoExtensaoEsquerda, (v) => setState(() => _data.punhoExtensaoEsquerda = v)),
          ]),
          
          _buildMuscleSection('Quadril (Flexão)', [
             _buildMuscleSlider('Direito', _data.quadrilFlexaoDireita, (v) => setState(() => _data.quadrilFlexaoDireita = v)),
             _buildMuscleSlider('Esquerdo', _data.quadrilFlexaoEsquerda, (v) => setState(() => _data.quadrilFlexaoEsquerda = v)),
          ]),
          
          _buildMuscleSection('Joelho (Extensão)', [
             _buildMuscleSlider('Direito', _data.joelhoExtensaoDireita, (v) => setState(() => _data.joelhoExtensaoDireita = v)),
             _buildMuscleSlider('Esquerdo', _data.joelhoExtensaoEsquerda, (v) => setState(() => _data.joelhoExtensaoEsquerda = v)),
          ]),
          
          _buildMuscleSection('Tornozelo (Dorsiflexão)', [
             _buildMuscleSlider('Direito', _data.tornozeloDorsiflexaoDireita, (v) => setState(() => _data.tornozeloDorsiflexaoDireita = v)),
             _buildMuscleSlider('Esquerdo', _data.tornozeloDorsiflexaoEsquerda, (v) => setState(() => _data.tornozeloDorsiflexaoEsquerda = v)),
          ]),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(mrcScore),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(mrcScore).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('MRC SUM SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$mrcScore/60',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 12),
                 Text(
                  _data.diagnostico,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                 const SizedBox(height: 4),
                 Text(
                  _data.interpretacao,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarICUAW,
        backgroundColor: Colors.blueGrey,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMuscleSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMuscleSlider(String side, int value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
              Text(side, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('$value/5', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
           ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blueGrey,
             thumbColor: Colors.blueGrey,
             inactiveTrackColor: Colors.blueGrey.withOpacity(0.1),
             trackHeight: 2,
             thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
             overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 5,
            divisions: 5,
            onChanged: (v) => onChanged(v.toInt()),
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 48) return Colors.green;
    if (score >= 36) return Colors.orange;
    return Colors.red;
  }
}
