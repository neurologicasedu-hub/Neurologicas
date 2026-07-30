import 'package:flutter/material.dart';
import '../models/myopathy_severity_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

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
        resultado: 'Média: ${_data.averageMuscularScore.toStringAsFixed(2)}/5.0 - ${_data.interpretation}',
        totalScore: (_data.averageMuscularScore * 10).round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Myopathy salva com sucesso!'),
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
               Text('$value/5', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            ],
          ),
          SliderTheme(
             data: SliderTheme.of(context).copyWith(
               activeTrackColor: Colors.redAccent,
               thumbColor: Colors.redAccent,
               overlayColor: Colors.redAccent.withOpacity(0.1),
               inactiveTrackColor: Colors.redAccent.withOpacity(0.1),
             ),
             child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 5,
              divisions: 5,
              onChanged: (val) => onChanged(val.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomSlider(String title, int value, ValueChanged<int> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
               Text('$value/4', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
           SliderTheme(
             data: SliderTheme.of(context).copyWith(
               activeTrackColor: Colors.orange,
               thumbColor: Colors.orange,
               overlayColor: Colors.orange.withOpacity(0.1),
               inactiveTrackColor: Colors.orange.withOpacity(0.1),
             ),
             child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (val) => onChanged(val.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avgScore = _data.averageMuscularScore;
    
    // Grouping by categories for better UI
    return CalculatorScaffold(
      title: 'Myopathy Severity',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Avaliação de força muscular e carga sintomática',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

          _buildSectionHeader('Membros Superiores (Proximal)'),
          _buildSliderItem('Ombro Esquerdo', _data.ombroEsquerdo, (val) => setState(() => _data.ombroEsquerdo = val)),
          _buildSliderItem('Ombro Direito', _data.ombroDireito, (val) => setState(() => _data.ombroDireito = val)),
          
          _buildSectionHeader('Membros Superiores (Distal)'),
          _buildSliderItem('Punho Esquerdo', _data.punhoEsquerdo, (val) => setState(() => _data.punhoEsquerdo = val)),
          _buildSliderItem('Punho Direito', _data.punhoDireito, (val) => setState(() => _data.punhoDireito = val)),

          _buildSectionHeader('Membros Inferiores (Proximal)'),
          _buildSliderItem('Quadril Esquerdo', _data.quadrilEsquerdo, (val) => setState(() => _data.quadrilEsquerdo = val)),
          _buildSliderItem('Quadril Direito', _data.quadrilDireito, (val) => setState(() => _data.quadrilDireito = val)),

          _buildSectionHeader('Membros Inferiores (Distal)'),
          _buildSliderItem('Tornozelo Esquerdo', _data.tornozeloEsquerdo, (val) => setState(() => _data.tornozeloEsquerdo = val)),
          _buildSliderItem('Tornozelo Direito', _data.tornozeloDireito, (val) => setState(() => _data.tornozeloDireito = val)),
          
          _buildSectionHeader('Sintomas Funcionais (0=Ausente, 4=Grave)'),
          _buildSymptomSlider('Subir Escadas', _data.dificuldadeSubirEscadas, (val) => setState(() => _data.dificuldadeSubirEscadas = val)),
          _buildSymptomSlider('Levantar da Cadeira', _data.dificuldadeLevantar, (val) => setState(() => _data.dificuldadeLevantar = val)),
          _buildSymptomSlider('Elevar Braços', _data.dificuldadeElevarBraco, (val) => setState(() => _data.dificuldadeElevarBraco = val)),
          _buildSymptomSlider('Fadiga', _data.fadiga, (val) => setState(() => _data.fadiga = val)),
          _buildSymptomSlider('Sintomas Cardíacos', _data.miopatiaCardiaca, (val) => setState(() => _data.miopatiaCardiaca = val)),
          _buildSymptomSlider('Disfagia (Engolir)', _data.disfagia, (val) => setState(() => _data.disfagia = val)),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: avgScore >= 4.5 ? Colors.green : avgScore >= 3.0 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (avgScore >= 4.5 ? Colors.green : avgScore >= 3.0 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('SCORE MÉDIO MUSCULAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '${avgScore.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const Text('/ 5.0', style: TextStyle(color: Colors.white70)),
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
        onPressed: _salvarMyopathy,
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent)),
    );
  }
}
