import 'package:flutter/material.dart';
import '../models/ich_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

class ICHScreen extends StatefulWidget {
  const ICHScreen({super.key});

  @override
  State<ICHScreen> createState() => _ICHScreenState();
}

class _ICHScreenState extends State<ICHScreen> with AutoSaveMixin {
  final ICHData _data = ICHData();
  final TextEditingController _volumeController = TextEditingController();

  @override
  String get scaleName => 'ich';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'idade': _data.idade,
      'volumeICH': _data.volumeICH,
      'localizacaoICH': _data.localizacaoICH,
      'nivelConsciencia': _data.nivelConsciencia,
      'origemICH': _data.origemICH,
      'volumeText': _volumeController.text,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.idade = data['idade'] ?? 0;
    _data.volumeICH = data['volumeICH'] ?? 0;
    _data.localizacaoICH = data['localizacaoICH'] ?? 0;
    _data.nivelConsciencia = data['nivelConsciencia'] ?? 0;
    _data.origemICH = data['origemICH'] ?? 0;
    if (data.containsKey('volumeText')) {
      _volumeController.text = data['volumeText'] ?? '';
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarICH() async {
    try {
      final score = CompletedScore(
        scoreName: 'ICH Score',
        scoreData: {
          'idade': _data.idade,
          'volumeICH': _data.volumeICH,
          'localizacaoICH': _data.localizacaoICH,
          'nivelConsciencia': _data.nivelConsciencia,
          'origemICH': _data.origemICH,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ICH salva com sucesso!'),
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
  void dispose() {
    _volumeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    final interpretacao = _data.interpretacao;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ICH Score'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Intracerebral Hemorrhage Score',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildRadioItem('Idade', ['< 80 anos (0)', '80-89 anos (1)', '≥ 90 anos (2)'], _data.idade, (val) {
            setState(() => _data.idade = val);
            onDataChanged();
          }),
          const SizedBox(height: 8),
          TextField(
            controller: _volumeController,
            decoration: const InputDecoration(
              labelText: 'Volume ICH (ml)',
              hintText: 'Ex: 25',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              final volume = double.tryParse(val) ?? 0;
              if (volume < 30) {
                setState(() => _data.volumeICH = 0);
              } else if (volume <= 60) {
                setState(() => _data.volumeICH = 1);
              } else {
                setState(() => _data.volumeICH = 2);
              }
              onDataChanged();
            },
          ),
          const SizedBox(height: 12),
          _buildRadioItem('Localização ICH', ['Profunda/Lobar (0)', 'Infratentorial (1)'], _data.localizacaoICH, (val) {
            setState(() => _data.localizacaoICH = val);
            onDataChanged();
          }),
          _buildRadioItem('Nível de Consciência (GCS)', ['13-15 (0)', '5-12 (1)', '3-4 (2)'], _data.nivelConsciencia, (val) {
            setState(() => _data.nivelConsciencia = val);
            onDataChanged();
          }),
          _buildRadioItem('Origem ICH', ['Não traumática/Hipertensiva (0)', 'Traumática/Outras causas (1)'], _data.origemICH, (val) {
            setState(() => _data.origemICH = val);
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
                  const Text('ICH Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarICH();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala ICH'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
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
                activeColor: Colors.deepPurpleAccent,
                dense: true,
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 2) return Colors.green;
    if (score == 3) return Colors.orange;
    return Colors.red;
  }
}

