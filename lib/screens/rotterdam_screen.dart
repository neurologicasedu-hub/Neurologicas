import 'package:flutter/material.dart';
import '../models/rotterdam_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

class RotterdamScreen extends StatefulWidget {
  const RotterdamScreen({super.key});

  @override
  State<RotterdamScreen> createState() => _RotterdamScreenState();
}

class _RotterdamScreenState extends State<RotterdamScreen> with AutoSaveMixin {
  final RotterdamData _data = RotterdamData();

  @override
  String get scaleName => 'rotterdam';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'cisternaBasilar': _data.cisternaBasilar,
      'desvioLinhaMedia': _data.desvioLinhaMedia,
      'hemorragia': _data.hemorragia,
      'lesaoMassa': _data.lesaoMassa,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.cisternaBasilar = data['cisternaBasilar'] ?? 0;
    _data.desvioLinhaMedia = data['desvioLinhaMedia'] ?? 0;
    _data.hemorragia = data['hemorragia'] ?? 0;
    _data.lesaoMassa = data['lesaoMassa'] ?? 0;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarRotterdam() async {
    try {
      final score = CompletedScore(
        scoreName: 'Rotterdam CT Score',
        scoreData: {
          'cisternaBasilar': _data.cisternaBasilar,
          'desvioLinhaMedia': _data.desvioLinhaMedia,
          'hemorragia': _data.hemorragia,
          'lesaoMassa': _data.lesaoMassa,
        },
        resultado: '${_data.prognostico} - ${_data.interpretacao}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Rotterdam salva com sucesso!'),
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
    final interpretacao = _data.interpretacao;
    final prognostico = _data.prognostico;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotterdam CT Score'),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Rotterdam CT Score para Hemorragia Subaracnóidea',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _buildRadioItem('Cisterna Basilar', [
            'Normal (0)',
            'Comprimida (1)',
            'Ausente (2)'
          ], _data.cisternaBasilar, (val) {
            setState(() => _data.cisternaBasilar = val);
            onDataChanged();
          }),
          _buildRadioItem('Desvio da Linha Média', [
            'Nenhum (0)',
            '0-5mm (1)',
            '>5mm (2)'
          ], _data.desvioLinhaMedia, (val) {
            setState(() => _data.desvioLinhaMedia = val);
            onDataChanged();
          }),
          _buildRadioItem('Hemorragia Intraventricular ou Subaracnóidea', [
            'Nenhuma (0)',
            'Presente (1)'
          ], _data.hemorragia, (val) {
            setState(() => _data.hemorragia = val);
            onDataChanged();
          }),
          _buildRadioItem('Lesão de Massa', [
            'Nenhuma (0)',
            'Presente (1)'
          ], _data.lesaoMassa, (val) {
            setState(() => _data.lesaoMassa = val);
            onDataChanged();
          }),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(score),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Rotterdam Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(prognostico, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(interpretacao, style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarRotterdam();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Rotterdam'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String title, List<String> options, int value, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              return RadioListTile<int>(
                title: Text(option, style: const TextStyle(fontSize: 13)),
                value: index,
                groupValue: value,
                onChanged: (val) => onChanged(val ?? 0),
                activeColor: Colors.indigoAccent,
                dense: true,
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 3) return Colors.green;
    if (score == 4) return Colors.orange;
    return Colors.red;
  }
}

