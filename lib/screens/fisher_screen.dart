import 'package:flutter/material.dart';
import '../models/fisher_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

class FisherScreen extends StatefulWidget {
  const FisherScreen({super.key});

  @override
  State<FisherScreen> createState() => _FisherScreenState();
}

class _FisherScreenState extends State<FisherScreen> with AutoSaveMixin {
  final FisherData _data = FisherData();

  @override
  String get scaleName => 'fisher';

  @override
  Map<String, dynamic> getDataToSave() {
    return {'grau': _data.grau};
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.grau = data['grau'] ?? 1;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarFisher() async {
    try {
      final score = CompletedScore(
        scoreName: 'Fisher Scale',
        scoreData: {
          'grau': _data.grau,
        },
        resultado: '${_data.interpretacao} - Risco de Vasoespasmo: ${_data.riscoVasoespasmo}',
        totalScore: _data.grau,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Fisher salva com sucesso!'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fisher Scale'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Classificação de Hemorragia Subaracnóidea em TC',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ...List.generate(4, (index) {
            int grau = index + 1;
            final tempData = FisherData(grau: grau);
            return _buildRadioItem(
              'Grau $grau',
              tempData.descricao,
              grau == _data.grau,
              () {
                setState(() => _data.grau = grau);
                onDataChanged();
              },
            );
          }),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(_data.grau),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Grau ${_data.grau}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('Risco de Vasoespasmo: ${_data.riscoVasoespasmo}', style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarFisher();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Fisher'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String title, String description, bool selected, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: selected ? 4 : 1,
      color: selected ? Colors.amber.shade50 : null,
      child: RadioListTile<int>(
        title: Text(title, style: TextStyle(fontSize: 14, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text(description, style: const TextStyle(fontSize: 12)),
        value: 1,
        groupValue: selected ? 1 : null,
        onChanged: (_) => onTap(),
        activeColor: Colors.amber.shade700,
      ),
    );
  }

  Color _getScoreColor(int grau) {
    if (grau <= 2) return Colors.green;
    return Colors.orange;
  }
}

