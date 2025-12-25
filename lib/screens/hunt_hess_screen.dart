import 'package:flutter/material.dart';
import '../models/hunt_hess_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

class HuntHessScreen extends StatefulWidget {
  const HuntHessScreen({super.key});

  @override
  State<HuntHessScreen> createState() => _HuntHessScreenState();
}

class _HuntHessScreenState extends State<HuntHessScreen> with AutoSaveMixin {
  final HuntHessData _data = HuntHessData();

  @override
  String get scaleName => 'hunt_hess';

  @override
  Map<String, dynamic> getDataToSave() {
    return {'nivel': _data.nivel};
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.nivel = data['nivel'] ?? 1;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarHuntHess() async {
    try {
      final score = CompletedScore(
        scoreName: 'Hunt and Hess Scale',
        scoreData: {
          'nivel': _data.nivel,
        },
        resultado: '${_data.interpretacao} - Mortalidade estimada: ${_data.mortalidadeEstimada}',
        totalScore: _data.nivel,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Hunt and Hess salva com sucesso!'),
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
        title: const Text('Hunt and Hess Scale'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Classificação de Hemorragia Subaracnóidea',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ...List.generate(5, (index) {
            int nivel = index + 1;
            final tempData = HuntHessData(nivel: nivel);
            return _buildRadioItem(
              'Grau $nivel',
              tempData.descricao,
              nivel == _data.nivel,
              () {
                setState(() => _data.nivel = nivel);
                onDataChanged();
              },
            );
          }),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(_data.nivel),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Grau ${_data.nivel}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('Mortalidade estimada: ${_data.mortalidadeEstimada}', style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarHuntHess();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Hunt and Hess'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String title, String description, bool selected, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: selected ? 4 : 1,
      color: selected ? Colors.purple.shade50 : null,
      child: RadioListTile<int>(
        title: Text(title, style: TextStyle(fontSize: 14, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text(description, style: const TextStyle(fontSize: 12)),
        value: 1,
        groupValue: selected ? 1 : null,
        onChanged: (_) => onTap(),
        activeColor: Colors.purple,
      ),
    );
  }

  Color _getScoreColor(int nivel) {
    if (nivel <= 2) return Colors.green;
    if (nivel == 3) return Colors.orange;
    return Colors.red;
  }
}

