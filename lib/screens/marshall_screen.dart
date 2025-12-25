import 'package:flutter/material.dart';
import '../models/marshall_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

class MarshallScreen extends StatefulWidget {
  const MarshallScreen({super.key});

  @override
  State<MarshallScreen> createState() => _MarshallScreenState();
}

class _MarshallScreenState extends State<MarshallScreen> with AutoSaveMixin {
  final MarshallData _data = MarshallData();

  @override
  String get scaleName => 'marshall';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'compressao': _data.compressao,
      'cisternaBasilar': _data.cisternaBasilar,
      'desvio': _data.desvio,
      'lesaoMassa': _data.lesaoMassa,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.compressao = data['compressao'] ?? 0;
    _data.cisternaBasilar = data['cisternaBasilar'] ?? false;
    _data.desvio = data['desvio'] ?? 0;
    _data.lesaoMassa = data['lesaoMassa'] ?? false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarMarshall() async {
    try {
      final score = CompletedScore(
        scoreName: 'Marshall Classification',
        scoreData: {
          'compressao': _data.compressao,
          'cisternaBasilar': _data.cisternaBasilar,
          'desvio': _data.desvio,
          'lesaoMassa': _data.lesaoMassa,
        },
        resultado: 'Classe ${_data.classificacao} - ${_data.interpretacao}',
        totalScore: _data.classificacao,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Marshall salva com sucesso!'),
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
    final classificacao = _data.classificacao;
    final interpretacao = _data.interpretacao;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marshall Classification'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Classificação de Marshall (Baseada em TC)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _buildRadioItem('Compressão do Sistema Ventricular', [
            'Normal (0)',
            'Ausente/Comprimida (1)'
          ], _data.compressao, (val) {
            setState(() => _data.compressao = val);
            onDataChanged();
          }),
          _buildCheckboxItem('Cisterna Basilar Visível/Normal', _data.cisternaBasilar, (val) {
            setState(() => _data.cisternaBasilar = val);
            onDataChanged();
          }),
          _buildRadioItem('Desvio da Linha Média', [
            'Sem desvio (0)',
            '0-5mm (1)',
            '>5mm (2)'
          ], _data.desvio, (val) {
            setState(() => _data.desvio = val);
            onDataChanged();
          }),
          _buildCheckboxItem('Lesão de Massa Não Evacuada >25cc', _data.lesaoMassa, (val) {
            setState(() => _data.lesaoMassa = val);
            onDataChanged();
          }),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(classificacao),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Classe $classificacao', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.descricao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(interpretacao, style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarMarshall();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Marshall'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
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
                activeColor: Colors.brown,
                dense: true,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: CheckboxListTile(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        value: value,
        onChanged: (val) => onChanged(val ?? false),
        activeColor: Colors.brown,
      ),
    );
  }

  Color _getScoreColor(int classificacao) {
    if (classificacao <= 2) return Colors.green;
    if (classificacao == 3) return Colors.orange;
    return Colors.red;
  }
}

