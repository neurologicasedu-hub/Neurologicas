import 'package:flutter/material.dart';
import '../models/alsfrs_r_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class ALSFRSRScreen extends StatefulWidget {
  const ALSFRSRScreen({super.key});

  @override
  State<ALSFRSRScreen> createState() => _ALSFRSRScreenState();
}

class _ALSFRSRScreenState extends State<ALSFRSRScreen> {
  final ALSFRSRData _data = ALSFRSRData();

  Future<void> _salvarALSFRSR() async {
    try {
      final score = CompletedScore(
        scoreName: 'ALSFRS-R (Amyotrophic Lateral Sclerosis Functional Rating Scale)',
        scoreData: {
          'fala': _data.fala,
          'salivacao': _data.salivacao,
          'degluticao': _data.degluticao,
          'escrita': _data.escrita,
          'cortarComUtensilios': _data.cortarComUtensilios,
          'vestirEHigiene': _data.vestirEHigiene,
          'virarNaCamaEAjustarRoupas': _data.virarNaCamaEAjustarRoupas,
          'caminhar': _data.caminhar,
          'subirEscadas': _data.subirEscadas,
          'dispneia': _data.dispneia,
          'ortopneia': _data.ortopneia,
          'insuficienciaRespiratoria': _data.insuficienciaRespiratoria,
        },
        resultado: 'Total: ${_data.totalScore}/48 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ALSFRS-R salva com sucesso!'),
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

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            Text(description, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('0 - Perda completa', style: TextStyle(fontSize: 10)),
                Text('$value/4', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Text('4 - Normal', style: TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.red,
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
        title: const Text('ALSFRS-R'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'ALSFRS-R - Escala Funcional de ELA',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Avalie cada item de 0 (perda completa) a 4 (normal)',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text('Função Bulbar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('1. Fala', _data.fala, (val) => setState(() => _data.fala = val), 'Fala normal / Fala anormal / Fala difícil / Fala muito difícil / Sem fala'),
          _buildSliderItem('2. Salivação', _data.salivacao, (val) => setState(() => _data.salivacao = val), 'Normal / Ligeiramente espessa / Moderadamente espessa / Muito espessa / Excesso'),
          _buildSliderItem('3. Deglutição', _data.degluticao, (val) => setState(() => _data.degluticao = val), 'Normal / Problemas precoces / Dieta líquida / Via enteral parcial / Via enteral total'),
          const SizedBox(height: 8),
          const Text('Função Motora Fina', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('4. Escrita', _data.escrita, (val) => setState(() => _data.escrita = val), 'Normal / Lenta / Incapaz'),
          _buildSliderItem('5. Cortar com Utensílios', _data.cortarComUtensilios, (val) => setState(() => _data.cortarComUtensilios = val), 'Normal / Lento / Precisa ajuda / Incapaz'),
          const SizedBox(height: 8),
          const Text('Função Motora Grossa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('6. Vestir-se e Higiene', _data.vestirEHigiene, (val) => setState(() => _data.vestirEHigiene = val), 'Normal / Lento / Precisa ajuda / Incapaz'),
          _buildSliderItem('7. Virar na Cama e Ajustar Roupas', _data.virarNaCamaEAjustarRoupas, (val) => setState(() => _data.virarNaCamaEAjustarRoupas = val), 'Normal / Lento / Precisa ajuda / Incapaz'),
          _buildSliderItem('8. Caminhar', _data.caminhar, (val) => setState(() => _data.caminhar = val), 'Normal / Precoce / Moderada / Severa / Incapaz'),
          _buildSliderItem('9. Subir Escadas', _data.subirEscadas, (val) => setState(() => _data.subirEscadas = val), 'Normal / Lento / Precisa ajuda / Incapaz'),
          const SizedBox(height: 8),
          const Text('Função Respiratória', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildSliderItem('10. Dispneia', _data.dispneia, (val) => setState(() => _data.dispneia = val), 'Nenhuma / Com esforço / Com atividades mínimas / Em repouso'),
          _buildSliderItem('11. Ortopneia', _data.ortopneia, (val) => setState(() => _data.ortopneia = val), 'Nenhuma / Alguma / Moderada / Severa'),
          _buildSliderItem('12. Insuficiência Respiratória', _data.insuficienciaRespiratoria, (val) => setState(() => _data.insuficienciaRespiratoria = val), 'Nenhuma / Noturna intermitente / Noturna contínua / Diurna'),
          const SizedBox(height: 16),
          Card(
            color: score >= 40 ? Colors.green : score >= 30 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('ALSFRS-R Total: $score/48', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Bulbar: ${_data.scoreBulbar}/12 | Motor Fino: ${_data.scoreMotorFino}/8 | Motor Grosso: ${_data.scoreMotorGrosso}/16 | Resp: ${_data.scoreRespiratorio}/12', style: const TextStyle(fontSize: 12, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarALSFRSR();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala ALSFRS-R'),
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
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
