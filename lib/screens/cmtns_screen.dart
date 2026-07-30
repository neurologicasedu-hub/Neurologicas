import 'package:flutter/material.dart';
import '../models/cmtns_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class CMTNSScreen extends StatefulWidget {
  const CMTNSScreen({super.key});

  @override
  State<CMTNSScreen> createState() => _CMTNSScreenState();
}

class _CMTNSScreenState extends State<CMTNSScreen> {
  final CMTNSData _data = CMTNSData();

  Future<void> _salvarCMTNS() async {
    try {
      final score = CompletedScore(
        scoreName: 'CMTNS (Charcot-Marie-Tooth)',
        scoreData: {
          'scoreSintomasSensitivos': _data.scoreSintomasSensitivos,
          'scoreSintomasMotores': _data.scoreSintomasMotores,
          'scoreExameMotor': _data.scoreExameMotor,
          'scoreExameSensitivo': _data.scoreExameSensitivo,
          'scoreReflexos': _data.scoreReflexos,
        },
        resultado: 'Total: ${_data.totalScore} - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala CMTNS salva com sucesso!'),
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

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
               Container(
                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                 decoration: BoxDecoration(
                   color: Colors.deepOrange.withOpacity(0.1),
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: Text('$value/4', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
               ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.deepOrange,
              inactiveTrackColor: Colors.deepOrange.withOpacity(0.1),
              thumbColor: Colors.deepOrange,
              overlayColor: Colors.deepOrange.withOpacity(0.1),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (val) => onChanged(val.toInt()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('Normal', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                 Text('Grave', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    
    return CalculatorScaffold(
      title: 'CMTNS Score',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Charcot-Marie-Tooth Neuropathy Score',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          _buildCategoryCard('Sintomas Sensitivos', '${_data.scoreSintomasSensitivos}/36', [
             _buildSliderItem('Pernas', _data.sintomasSensitivosPernas, (val) => setState(() => _data.sintomasSensitivosPernas = val)),
             _buildSliderItem('Mãos', _data.sintomasSensitivosMaos, (val) => setState(() => _data.sintomasSensitivosMaos = val)),
          ]),

          _buildCategoryCard('Sintomas Motores', '${_data.scoreSintomasMotores}/28', [
             _buildSliderItem('Pernas', _data.sintomasMotoresPernas, (val) => setState(() => _data.sintomasMotoresPernas = val)),
             _buildSliderItem('Mãos', _data.sintomasMotoresMaos, (val) => setState(() => _data.sintomasMotoresMaos = val)),
          ]),

          _buildCategoryCard('Exame Motor (Força)', '${_data.scoreExameMotor}/76', [
                _buildSliderItem('Quadril Esq.', _data.forcaQuadrilEsquerdo, (val) => setState(() => _data.forcaQuadrilEsquerdo = val)),
                _buildSliderItem('Quadril Dir.', _data.forcaQuadrilDireito, (val) => setState(() => _data.forcaQuadrilDireito = val)),
                _buildSliderItem('Joelho Esq.', _data.forcaJoelhoEsquerdo, (val) => setState(() => _data.forcaJoelhoEsquerdo = val)),
                _buildSliderItem('Joelho Dir.', _data.forcaJoelhoDireito, (val) => setState(() => _data.forcaJoelhoDireito = val)),
                _buildSliderItem('Tornozelo Esq.', _data.forcaTornozeloEsquerdo, (val) => setState(() => _data.forcaTornozeloEsquerdo = val)),
                _buildSliderItem('Tornozelo Dir.', _data.forcaTornozeloDireito, (val) => setState(() => _data.forcaTornozeloDireito = val)),
                _buildSliderItem('Ombro Esq.', _data.forcaOmbroEsquerdo, (val) => setState(() => _data.forcaOmbroEsquerdo = val)),
                _buildSliderItem('Ombro Dir.', _data.forcaOmbroDireito, (val) => setState(() => _data.forcaOmbroDireito = val)),
                _buildSliderItem('Cotovelo Esq.', _data.forcaCotoveloEsquerdo, (val) => setState(() => _data.forcaCotoveloEsquerdo = val)),
                _buildSliderItem('Cotovelo Dir.', _data.forcaCotoveloDireito, (val) => setState(() => _data.forcaCotoveloDireito = val)),
                _buildSliderItem('Punho Esq.', _data.forcaPunhoEsquerdo, (val) => setState(() => _data.forcaPunhoEsquerdo = val)),
                _buildSliderItem('Punho Dir.', _data.forcaPunhoDireito, (val) => setState(() => _data.forcaPunhoDireito = val)),
          ]),

          _buildCategoryCard('Exame Sensitivo', '${_data.scoreExameSensitivo}/20', [
             _buildSliderItem('Toque - Pernas', _data.sensibilidadeToquePernas, (val) => setState(() => _data.sensibilidadeToquePernas = val)),
             _buildSliderItem('Toque - Mãos', _data.sensibilidadeToqueMaos, (val) => setState(() => _data.sensibilidadeToqueMaos = val)),
             _buildSliderItem('Dor - Pernas', _data.sensibilidadeDorPernas, (val) => setState(() => _data.sensibilidadeDorPernas = val)),
             _buildSliderItem('Dor - Mãos', _data.sensibilidadeDorMaos, (val) => setState(() => _data.sensibilidadeDorMaos = val)),
             _buildSliderItem('Vibração - Pernas', _data.sensibilidadeVibracaoPernas, (val) => setState(() => _data.sensibilidadeVibracaoPernas = val)),
             _buildSliderItem('Vibração - Mãos', _data.sensibilidadeVibracaoMaos, (val) => setState(() => _data.sensibilidadeVibracaoMaos = val)),
          ]),

          _buildCategoryCard('Reflexos', '${_data.scoreReflexos}/8', [
             _buildSliderItem('Patelar Esq.', _data.reflexoPatelarEsquerdo, (val) => setState(() => _data.reflexoPatelarEsquerdo = val)),
             _buildSliderItem('Patelar Dir.', _data.reflexoPatelarDireito, (val) => setState(() => _data.reflexoPatelarDireito = val)),
             _buildSliderItem('Aquileu Esq.', _data.reflexoAquileuEsquerdo, (val) => setState(() => _data.reflexoAquileuEsquerdo = val)),
             _buildSliderItem('Aquileu Dir.', _data.reflexoAquileuDireito, (val) => setState(() => _data.reflexoAquileuDireito = val)),
          ]),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 10 ? Colors.green : score <= 20 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 10 ? Colors.green : score <= 20 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('CMTNS TOTAL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 4),
                 Text(
                  _data.interpretation,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarCMTNS,
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String score, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text('Pontuação parcial: $score', style: TextStyle(color: Colors.deepOrange.shade700, fontWeight: FontWeight.w600)),
        childrenPadding: const EdgeInsets.all(12),
        children: children,
      ),
    );
  }
}
