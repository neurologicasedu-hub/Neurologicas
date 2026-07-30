import 'package:flutter/material.dart';
import '../models/tremor_rating_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class TremorRatingScreen extends StatefulWidget {
  const TremorRatingScreen({super.key});

  @override
  State<TremorRatingScreen> createState() => _TremorRatingScreenState();
}

class _TremorRatingScreenState extends State<TremorRatingScreen> {
  final TremorRatingData _data = TremorRatingData();

  Future<void> _salvarTremor() async {
    try {
      final score = CompletedScore(
        scoreName: 'Tremor Rating Scale',
        scoreData: {
          'restingTremorScore': _data.restingTremorScore,
          'posturalTremorScore': _data.posturalTremorScore,
          'kineticTremorScore': _data.kineticTremorScore,
        },
        resultado: 'Total: ${_data.totalScore} - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Tremor Rating salva com sucesso!'),
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

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
             Text('$value/4', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.brown.shade700)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.brown, thumbColor: Colors.brown),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 4,
            divisions: 4,
            label: '$value',
            onChanged: (val) => onChanged(val.toInt()),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'Tremor Rating Scale',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Avaliação de Tremor (Fahn-Tolosa-Marin)\n0=Nenhum, 4=Severo',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

          _buildSectionCard('Tremor de Repouso', [
            _buildSliderItem('Face', _data.restingFace, (val) => setState(() => _data.restingFace = val)),
            _buildSliderItem('Mandíbula', _data.restingJaw, (val) => setState(() => _data.restingJaw = val)),
            _buildSliderItem('Língua', _data.restingTongue, (val) => setState(() => _data.restingTongue = val)),
            _buildSliderItem('Braço Esq.', _data.restingLeftArm, (val) => setState(() => _data.restingLeftArm = val)),
            _buildSliderItem('Braço Dir.', _data.restingRightArm, (val) => setState(() => _data.restingRightArm = val)),
            _buildSliderItem('Perna Esq.', _data.restingLeftLeg, (val) => setState(() => _data.restingLeftLeg = val)),
            _buildSliderItem('Perna Dir.', _data.restingRightLeg, (val) => setState(() => _data.restingRightLeg = val)),
          ]),

          _buildSectionCard('Tremor Postural', [
            _buildSliderItem('Braço Esq.', _data.posturalLeftArm, (val) => setState(() => _data.posturalLeftArm = val)),
            _buildSliderItem('Braço Dir.', _data.posturalRightArm, (val) => setState(() => _data.posturalRightArm = val)),
          ]),

          _buildSectionCard('Tremor Cinético', [
            _buildSliderItem('Braço Esq.', _data.kineticLeftArm, (val) => setState(() => _data.kineticLeftArm = val)),
             _buildSliderItem('Braço Dir.', _data.kineticRightArm, (val) => setState(() => _data.kineticRightArm = val)),
          ]),
          
          _buildSectionCard('Funcional', [
             _buildSliderItem('Escrita', _data.handwriting, (val) => setState(() => _data.handwriting = val)),
             _buildSliderItem('Atividades Diárias', _data.atividadesVidaDiaria, (val) => setState(() => _data.atividadesVidaDiaria = val)),
          ]),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 10 ? Colors.green : score <= 25 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 10 ? Colors.green : score <= 25 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('TREMOR SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 Text(
                   'Repouso: ${_data.restingTremorScore} | Postural: ${_data.posturalTremorScore} | Cinético: ${_data.kineticTremorScore}',
                   style: const TextStyle(color: Colors.white70, fontSize: 12),
                 ),
                 const SizedBox(height: 12),
                 Text(
                  _data.interpretation,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarTremor,
        backgroundColor: Colors.brown,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.brown.shade800)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}
