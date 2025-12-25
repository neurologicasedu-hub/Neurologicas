import 'package:flutter/material.dart';
import '../models/qmg_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class QMGScreen extends StatefulWidget {
  const QMGScreen({super.key});
  @override
  State<QMGScreen> createState() => _QMGScreenState();
}

class _QMGScreenState extends State<QMGScreen> {
  final QMGData _data = QMGData();

  Future<void> _salvarQMG() async {
    try {
      final score = CompletedScore(
        scoreName: 'QMG Score',
        scoreData: {
          'ptose': _data.ptose,
          'diplopia': _data.diplopia,
          'fechamentoOcular': _data.fechamentoOcular,
          'fala': _data.fala,
          'mastigacao': _data.mastigacao,
          'degluticao': _data.degluticao,
          'forcaRespiratoria': _data.forcaRespiratoria,
          'flexaoPescoco': _data.flexaoPescoco,
          'flexaoOmbro': _data.flexaoOmbro,
          'extensaoPunho': _data.extensaoPunho,
          'flexaoQuadril': _data.flexaoQuadril,
          'extensaoJoelho': _data.extensaoJoelho,
          'dorsiflexaoTornozelo': _data.dorsiflexaoTornozelo,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala QMG salva com sucesso!'),
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
    final score = _data.totalScore;
    return Scaffold(
      appBar: AppBar(title: const Text('QMG Score'), centerTitle: true, backgroundColor: Colors.lightBlue.shade700),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Quantitative Myasthenia Gravis Score', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
            child: const Text('Legenda:\n0 = Normal/Nenhum\n1 = Leve\n2 = Moderado\n3 = Severo', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(height: 12),
          _buildSliderItem('Ptose', _data.ptose, 3, (val) => setState(() => _data.ptose = val)),
          _buildSliderItem('Diplopia', _data.diplopia, 3, (val) => setState(() => _data.diplopia = val)),
          _buildSliderItem('Fechamento Ocular', _data.fechamentoOcular, 3, (val) => setState(() => _data.fechamentoOcular = val)),
          _buildSliderItem('Fala', _data.fala, 3, (val) => setState(() => _data.fala = val)),
          _buildSliderItem('Mastigação', _data.mastigacao, 3, (val) => setState(() => _data.mastigacao = val)),
          _buildSliderItem('Deglutição', _data.degluticao, 3, (val) => setState(() => _data.degluticao = val)),
          _buildSliderItem('Força Respiratória', _data.forcaRespiratoria, 3, (val) => setState(() => _data.forcaRespiratoria = val)),
          _buildSliderItem('Flexão Pescoço', _data.flexaoPescoco, 3, (val) => setState(() => _data.flexaoPescoco = val)),
          _buildSliderItem('Flexão Ombro', _data.flexaoOmbro, 3, (val) => setState(() => _data.flexaoOmbro = val)),
          _buildSliderItem('Extensão Punho', _data.extensaoPunho, 3, (val) => setState(() => _data.extensaoPunho = val)),
          _buildSliderItem('Flexão Quadril', _data.flexaoQuadril, 3, (val) => setState(() => _data.flexaoQuadril = val)),
          _buildSliderItem('Extensão Joelho', _data.extensaoJoelho, 3, (val) => setState(() => _data.extensaoJoelho = val)),
          _buildSliderItem('Dorsiflexão Tornozelo', _data.dorsiflexaoTornozelo, 3, (val) => setState(() => _data.dorsiflexaoTornozelo = val)),
          const SizedBox(height: 16),
          Card(color: _getScoreColor(score), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 6, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text('QMG Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 8), Text('$score/39', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), Text(_data.interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center)]))),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarQMG();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala QMG'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Voltar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12))),
        ],
      ),
    );
  }

  Widget _buildSliderItem(String title, int value, int max, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontSize: 12))),
                Text('$value/$max', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: max.toDouble(),
              divisions: max,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.lightBlue.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 10) return Colors.green;
    if (score <= 20) return Colors.orange;
    return Colors.red;
  }
}

