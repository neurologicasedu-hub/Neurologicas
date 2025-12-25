import 'package:flutter/material.dart';
import '../models/mrc_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

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

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(_data.mrcDescription(value), style: const TextStyle(fontSize: 12)),
                ),
                Text('$value/5', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 5,
              divisions: 5,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avgScore = _data.averageScore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MRC Scale - Força Muscular'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Medical Research Council Scale for Muscle Strength',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Avalie a força muscular de 0 (sem contração) a 5 (força normal)',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text('Membros Superiores', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildSliderItem('Ombro Esquerdo (Abdução)', _data.ombroEsquerdo, (val) => setState(() => _data.ombroEsquerdo = val)),
          _buildSliderItem('Ombro Direito (Abdução)', _data.ombroDireito, (val) => setState(() => _data.ombroDireito = val)),
          _buildSliderItem('Cotovelo Esquerdo (Flexão)', _data.cotoveloEsquerdo, (val) => setState(() => _data.cotoveloEsquerdo = val)),
          _buildSliderItem('Cotovelo Direito (Flexão)', _data.cotoveloDireito, (val) => setState(() => _data.cotoveloDireito = val)),
          _buildSliderItem('Punho Esquerdo (Extensão)', _data.punhoEsquerdo, (val) => setState(() => _data.punhoEsquerdo = val)),
          _buildSliderItem('Punho Direito (Extensão)', _data.punhoDireito, (val) => setState(() => _data.punhoDireito = val)),
          const SizedBox(height: 12),
          const Text('Membros Inferiores', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildSliderItem('Quadril Esquerdo (Flexão)', _data.quadrilEsquerdo, (val) => setState(() => _data.quadrilEsquerdo = val)),
          _buildSliderItem('Quadril Direito (Flexão)', _data.quadrilDireito, (val) => setState(() => _data.quadrilDireito = val)),
          _buildSliderItem('Joelho Esquerdo (Extensão)', _data.joelhoEsquerdo, (val) => setState(() => _data.joelhoEsquerdo = val)),
          _buildSliderItem('Joelho Direito (Extensão)', _data.joelhoDireito, (val) => setState(() => _data.joelhoDireito = val)),
          _buildSliderItem('Tornozelo Esquerdo (Dorsiflexão)', _data.tornozeloEsquerdo, (val) => setState(() => _data.tornozeloEsquerdo = val)),
          _buildSliderItem('Tornozelo Direito (Dorsiflexão)', _data.tornozeloDireito, (val) => setState(() => _data.tornozeloDireito = val)),
          const SizedBox(height: 16),
          Card(
            color: avgScore >= 4.5 ? Colors.green : avgScore >= 3.0 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Score Médio MRC', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('${avgScore.toStringAsFixed(2)}/5.0', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarMRC();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala MRC'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
