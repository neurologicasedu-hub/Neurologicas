import 'package:flutter/material.dart';
import '../models/qmg_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

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
    
    return CalculatorScaffold(
      title: 'QMG Score',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Quantitative Myasthenia Gravis Score\nScore 0 (Não) a 3 (Grave) para cada item',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildItem('Ptose (Up-gaze 60s)', _data.ptose, (v) => setState(() => _data.ptose = v)),
          _buildItem('Diplopia (Lateral gaze 60s)', _data.diplopia, (v) => setState(() => _data.diplopia = v)),
          _buildItem('Fechamento Ocular (Resistência)', _data.fechamentoOcular, (v) => setState(() => _data.fechamentoOcular = v)),
          _buildItem('Fala (Contar 1-50)', _data.fala, (v) => setState(() => _data.fala = v)),
          _buildItem('Mastigação', _data.mastigacao, (v) => setState(() => _data.mastigacao = v)),
          _buildItem('Deglutição (100ml água)', _data.degluticao, (v) => setState(() => _data.degluticao = v)),
          _buildItem('Força Respiratória (% predito)', _data.forcaRespiratoria, (v) => setState(() => _data.forcaRespiratoria = v)),
          _buildItem('Flexão Pescoço (shentada)', _data.flexaoPescoco, (v) => setState(() => _data.flexaoPescoco = v)),
          _buildItem('Flexão Ombro (Abdução 90°)', _data.flexaoOmbro, (v) => setState(() => _data.flexaoOmbro = v)),
          _buildItem('Extensão Punho', _data.extensaoPunho, (v) => setState(() => _data.extensaoPunho = v)),
          _buildItem('Flexão Quadril', _data.flexaoQuadril, (v) => setState(() => _data.flexaoQuadril = v)),
          _buildItem('Extensão Joelho', _data.extensaoJoelho, (v) => setState(() => _data.extensaoJoelho = v)),
          _buildItem('Dorsiflexão Tornozelo', _data.dorsiflexaoTornozelo, (v) => setState(() => _data.dorsiflexaoTornozelo = v)),

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
                const Text('QMG SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score/39',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 12),
                 Text(
                  _data.interpretacao,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarQMG,
        backgroundColor: Colors.lightBlue.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildItem(String title, int value, ValueChanged<int> onChanged) {
     return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
       color: Colors.white,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade100)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                   decoration: BoxDecoration(color: Colors.lightBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                   child: Text('$value', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue.shade800)),
                 ),
               ],
             ),
             const SizedBox(height: 4),
             SliderTheme(
               data: SliderTheme.of(context).copyWith(
                 activeTrackColor: Colors.lightBlue.shade700,
                 thumbColor: Colors.lightBlue.shade700,
                 overlayColor: Colors.lightBlue.shade700.withOpacity(0.1),
                 inactiveTrackColor: Colors.lightBlue.shade100,
                 trackHeight: 2,
                 thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
               ),
               child: Slider(
                value: value.toDouble(),
                min: 0,
                max: 3,
                divisions: 3,
                label: '$value',
                onChanged: (val) => onChanged(val.toInt()),
              ),
             ),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 8),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                    Text('0: Nenhum', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    Text('3: Grave', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                 ],
               ),
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
