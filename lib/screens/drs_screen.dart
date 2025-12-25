import 'package:flutter/material.dart';
import '../models/drs_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class DRSScreen extends StatefulWidget {
  const DRSScreen({super.key});

  @override
  State<DRSScreen> createState() => _DRSScreenState();
}

class _DRSScreenState extends State<DRSScreen> {
  final DRSData _data = DRSData();

  Future<void> _salvarDRS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Disability Rating Scale (DRS)',
        scoreData: {
          'aberturaOcular': _data.aberturaOcular,
          'respostaVerbal': _data.respostaVerbal,
          'respostaMotora': _data.respostaMotora,
          'alimentacaoComunicacaoHigiene': _data.alimentacaoComunicacaoHigiene,
          'funcionalidade': _data.funcionalidade,
          'empregabilidade': _data.empregabilidade,
        },
        resultado: '${_data.nivelDeficiencia} - ${_data.interpretacao}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala DRS salva com sucesso!'),
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
    final nivel = _data.nivelDeficiencia;
    final interpretacao = _data.interpretacao;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disability Rating Scale (DRS)'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Avaliação de Deficiência (0-29 pontos)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSliderItem('Abertura Ocular (0-3)', _data.aberturaOcular, 3, (val) => setState(() => _data.aberturaOcular = val)),
          _buildSliderItem('Resposta Verbal (0-4)', _data.respostaVerbal, 4, (val) => setState(() => _data.respostaVerbal = val)),
          _buildSliderItem('Resposta Motora (0-5)', _data.respostaMotora, 5, (val) => setState(() => _data.respostaMotora = val)),
          _buildSliderItem('Alimentação/Comunicação/Higiene (0-3)', _data.alimentacaoComunicacaoHigiene, 3, (val) => setState(() => _data.alimentacaoComunicacaoHigiene = val)),
          _buildSliderItem('Funcionalidade (0-5)', _data.funcionalidade, 5, (val) => setState(() => _data.funcionalidade = val)),
          _buildSliderItem('Empregabilidade (0-3)', _data.empregabilidade, 3, (val) => setState(() => _data.empregabilidade = val)),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(score),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Pontuação Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/29', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(nivel, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(interpretacao, style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarDRS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala DRS'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
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
              activeColor: Colors.pink,
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 5) return Colors.green;
    if (score <= 15) return Colors.orange;
    return Colors.red;
  }
}

