import 'package:flutter/material.dart';
import '../models/cmtns_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

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
        scoreName: 'CMTNS (Charcot-Marie-Tooth Neuropathy Score)',
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
                const Text('0', style: TextStyle(fontSize: 10)),
                Text('$value/4', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Text('4', style: TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('CMTNS - Charcot-Marie-Tooth Neuropathy Score'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'CMTNS - Escala de Neuropatia de Charcot-Marie-Tooth',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Sintomas Sensitivos (${_data.scoreSintomasSensitivos}/36)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildSliderItem('Sintomas Sensitivos - Pernas', _data.sintomasSensitivosPernas, (val) => setState(() => _data.sintomasSensitivosPernas = val)),
                _buildSliderItem('Sintomas Sensitivos - Mãos', _data.sintomasSensitivosMaos, (val) => setState(() => _data.sintomasSensitivosMaos = val)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Sintomas Motores (${_data.scoreSintomasMotores}/28)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildSliderItem('Sintomas Motores - Pernas', _data.sintomasMotoresPernas, (val) => setState(() => _data.sintomasMotoresPernas = val)),
                _buildSliderItem('Sintomas Motores - Mãos', _data.sintomasMotoresMaos, (val) => setState(() => _data.sintomasMotoresMaos = val)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Exame Motor (${_data.scoreExameMotor}/76)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildSliderItem('Força Quadril Esquerdo', _data.forcaQuadrilEsquerdo, (val) => setState(() => _data.forcaQuadrilEsquerdo = val)),
                _buildSliderItem('Força Quadril Direito', _data.forcaQuadrilDireito, (val) => setState(() => _data.forcaQuadrilDireito = val)),
                _buildSliderItem('Força Joelho Esquerdo', _data.forcaJoelhoEsquerdo, (val) => setState(() => _data.forcaJoelhoEsquerdo = val)),
                _buildSliderItem('Força Joelho Direito', _data.forcaJoelhoDireito, (val) => setState(() => _data.forcaJoelhoDireito = val)),
                _buildSliderItem('Força Tornozelo Esquerdo', _data.forcaTornozeloEsquerdo, (val) => setState(() => _data.forcaTornozeloEsquerdo = val)),
                _buildSliderItem('Força Tornozelo Direito', _data.forcaTornozeloDireito, (val) => setState(() => _data.forcaTornozeloDireito = val)),
                _buildSliderItem('Força Ombro Esquerdo', _data.forcaOmbroEsquerdo, (val) => setState(() => _data.forcaOmbroEsquerdo = val)),
                _buildSliderItem('Força Ombro Direito', _data.forcaOmbroDireito, (val) => setState(() => _data.forcaOmbroDireito = val)),
                _buildSliderItem('Força Cotovelo Esquerdo', _data.forcaCotoveloEsquerdo, (val) => setState(() => _data.forcaCotoveloEsquerdo = val)),
                _buildSliderItem('Força Cotovelo Direito', _data.forcaCotoveloDireito, (val) => setState(() => _data.forcaCotoveloDireito = val)),
                _buildSliderItem('Força Punho Esquerdo', _data.forcaPunhoEsquerdo, (val) => setState(() => _data.forcaPunhoEsquerdo = val)),
                _buildSliderItem('Força Punho Direito', _data.forcaPunhoDireito, (val) => setState(() => _data.forcaPunhoDireito = val)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Exame Sensitivo (${_data.scoreExameSensitivo}/20)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildSliderItem('Toque - Pernas', _data.sensibilidadeToquePernas, (val) => setState(() => _data.sensibilidadeToquePernas = val)),
                _buildSliderItem('Toque - Mãos', _data.sensibilidadeToqueMaos, (val) => setState(() => _data.sensibilidadeToqueMaos = val)),
                _buildSliderItem('Dor - Pernas', _data.sensibilidadeDorPernas, (val) => setState(() => _data.sensibilidadeDorPernas = val)),
                _buildSliderItem('Dor - Mãos', _data.sensibilidadeDorMaos, (val) => setState(() => _data.sensibilidadeDorMaos = val)),
                _buildSliderItem('Vibração - Pernas', _data.sensibilidadeVibracaoPernas, (val) => setState(() => _data.sensibilidadeVibracaoPernas = val)),
                _buildSliderItem('Vibração - Mãos', _data.sensibilidadeVibracaoMaos, (val) => setState(() => _data.sensibilidadeVibracaoMaos = val)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Reflexos (${_data.scoreReflexos}/8)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildSliderItem('Reflexo Patelar Esquerdo', _data.reflexoPatelarEsquerdo, (val) => setState(() => _data.reflexoPatelarEsquerdo = val)),
                _buildSliderItem('Reflexo Patelar Direito', _data.reflexoPatelarDireito, (val) => setState(() => _data.reflexoPatelarDireito = val)),
                _buildSliderItem('Reflexo Aquileu Esquerdo', _data.reflexoAquileuEsquerdo, (val) => setState(() => _data.reflexoAquileuEsquerdo = val)),
                _buildSliderItem('Reflexo Aquileu Direito', _data.reflexoAquileuDireito, (val) => setState(() => _data.reflexoAquileuDireito = val)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: score <= 10 ? Colors.green : score <= 20 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('CMTNS Total: $score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Sensitivos: ${_data.scoreSintomasSensitivos} | Motores: ${_data.scoreSintomasMotores}\nExame Motor: ${_data.scoreExameMotor} | Exame Sensitivo: ${_data.scoreExameSensitivo} | Reflexos: ${_data.scoreReflexos}', style: const TextStyle(fontSize: 11, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarCMTNS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala CMTNS'),
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
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
