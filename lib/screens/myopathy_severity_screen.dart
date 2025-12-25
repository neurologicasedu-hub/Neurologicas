import 'package:flutter/material.dart';
import '../models/myopathy_severity_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class MyopathySeverityScreen extends StatefulWidget {
  const MyopathySeverityScreen({super.key});

  @override
  State<MyopathySeverityScreen> createState() => _MyopathySeverityScreenState();
}

class _MyopathySeverityScreenState extends State<MyopathySeverityScreen> {
  final MyopathySeverityData _data = MyopathySeverityData();

  Future<void> _salvarMyopathy() async {
    try {
      final score = CompletedScore(
        scoreName: 'Myopathy Severity Scale',
        scoreData: {
          'averageMuscularScore': _data.averageMuscularScore,
          'scoreSintomas': _data.scoreSintomas,
        },
        resultado: 'Score médio muscular: ${_data.averageMuscularScore.toStringAsFixed(2)}/5.0 - ${_data.interpretation}',
        totalScore: (_data.averageMuscularScore * 10).round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Myopathy Severity salva com sucesso!'),
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
                const Text('0 - Sem contração', style: TextStyle(fontSize: 10)),
                Text('$value/5', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Text('5 - Normal', style: TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 5,
              divisions: 5,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.red.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomSlider(String title, int value, ValueChanged<int> onChanged) {
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
                const Text('0 - Ausente', style: TextStyle(fontSize: 10)),
                Text('$value/4', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Text('4 - Grave', style: TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.red.shade700,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avgScore = _data.averageMuscularScore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Myopathy Severity Scale'),
        centerTitle: true,
        backgroundColor: Colors.red.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Myopathy Severity Scale - Avaliação de Miopatia',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text('Força Muscular Proximal - Membros Superiores', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('Ombro Esquerdo', _data.ombroEsquerdo, (val) => setState(() => _data.ombroEsquerdo = val)),
          _buildSliderItem('Ombro Direito', _data.ombroDireito, (val) => setState(() => _data.ombroDireito = val)),
          const SizedBox(height: 8),
          const Text('Força Muscular Distal - Membros Superiores', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('Punho Esquerdo', _data.punhoEsquerdo, (val) => setState(() => _data.punhoEsquerdo = val)),
          _buildSliderItem('Punho Direito', _data.punhoDireito, (val) => setState(() => _data.punhoDireito = val)),
          const SizedBox(height: 8),
          const Text('Força Muscular Proximal - Membros Inferiores', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('Quadril Esquerdo', _data.quadrilEsquerdo, (val) => setState(() => _data.quadrilEsquerdo = val)),
          _buildSliderItem('Quadril Direito', _data.quadrilDireito, (val) => setState(() => _data.quadrilDireito = val)),
          const SizedBox(height: 8),
          const Text('Força Muscular Distal - Membros Inferiores', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('Tornozelo Esquerdo', _data.tornozeloEsquerdo, (val) => setState(() => _data.tornozeloEsquerdo = val)),
          _buildSliderItem('Tornozelo Direito', _data.tornozeloDireito, (val) => setState(() => _data.tornozeloDireito = val)),
          const SizedBox(height: 8),
          const Text('Sintomas Adicionais (0-4 cada)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSymptomSlider('Dificuldade Subir Escadas', _data.dificuldadeSubirEscadas, (val) => setState(() => _data.dificuldadeSubirEscadas = val)),
          _buildSymptomSlider('Dificuldade Levantar', _data.dificuldadeLevantar, (val) => setState(() => _data.dificuldadeLevantar = val)),
          _buildSymptomSlider('Dificuldade Elevar Braço', _data.dificuldadeElevarBraco, (val) => setState(() => _data.dificuldadeElevarBraco = val)),
          _buildSymptomSlider('Fadiga', _data.fadiga, (val) => setState(() => _data.fadiga = val)),
          _buildSymptomSlider('Miopatia Cardíaca', _data.miopatiaCardiaca, (val) => setState(() => _data.miopatiaCardiaca = val)),
          _buildSymptomSlider('Disfagia', _data.disfagia, (val) => setState(() => _data.disfagia = val)),
          const SizedBox(height: 16),
          Card(
            color: avgScore >= 4.5 ? Colors.green : avgScore >= 3.0 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Score Médio Muscular: ${avgScore.toStringAsFixed(2)}/5.0', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarMyopathy();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Myopathy Severity'),
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
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
