import 'package:flutter/material.dart';
import '../models/rts_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

class RTSScreen extends StatefulWidget {
  const RTSScreen({super.key});

  @override
  State<RTSScreen> createState() => _RTSScreenState();
}

class _RTSScreenState extends State<RTSScreen> with AutoSaveMixin {
  final RTSData _data = RTSData();
  final TextEditingController _gcsController = TextEditingController(text: '15');
  final TextEditingController _pasController = TextEditingController(text: '120');
  final TextEditingController _frController = TextEditingController(text: '20');

  @override
  String get scaleName => 'rts';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'glasgowComaScale': _data.glasgowComaScale,
      'pressaoSistolica': _data.pressaoSistolica,
      'frequenciaRespiratoria': _data.frequenciaRespiratoria,
      'gcsText': _gcsController.text,
      'pasText': _pasController.text,
      'frText': _frController.text,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.glasgowComaScale = data['glasgowComaScale'] ?? 15;
    _data.pressaoSistolica = data['pressaoSistolica'] ?? 120;
    _data.frequenciaRespiratoria = data['frequenciaRespiratoria'] ?? 20;
    if (data.containsKey('gcsText')) _gcsController.text = data['gcsText'] ?? '15';
    if (data.containsKey('pasText')) _pasController.text = data['pasText'] ?? '120';
    if (data.containsKey('frText')) _frController.text = data['frText'] ?? '20';
    _updateData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarRTS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Revised Trauma Score (RTS)',
        scoreData: {
          'glasgowComaScale': _data.glasgowComaScale,
          'pressaoSistolica': _data.pressaoSistolica,
          'frequenciaRespiratoria': _data.frequenciaRespiratoria,
        },
        resultado: _data.interpretacao,
        totalScore: _data.rts.round(),
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala RTS salva com sucesso!'),
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
    _gcsController.dispose();
    _pasController.dispose();
    _frController.dispose();
    super.dispose();
  }

  void _updateData() {
    setState(() {
      _data.glasgowComaScale = int.tryParse(_gcsController.text) ?? 15;
      _data.pressaoSistolica = int.tryParse(_pasController.text) ?? 120;
      _data.frequenciaRespiratoria = int.tryParse(_frController.text) ?? 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rts = _data.rts;
    final interpretacao = _data.interpretacao;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revised Trauma Score (RTS)'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Revised Trauma Score',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _gcsController,
            decoration: const InputDecoration(
              labelText: 'Glasgow Coma Scale (3-15)',
              hintText: 'Ex: 15',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) {
              _updateData();
              onDataChanged();
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pasController,
            decoration: const InputDecoration(
              labelText: 'Pressão Arterial Sistólica (mmHg)',
              hintText: 'Ex: 120',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) {
              _updateData();
              onDataChanged();
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _frController,
            decoration: const InputDecoration(
              labelText: 'Frequência Respiratória (resp/min)',
              hintText: 'Ex: 20',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) {
              _updateData();
              onDataChanged();
            },
          ),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(rts),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('RTS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(rts.toStringAsFixed(2), style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarRTS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala RTS'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double rts) {
    if (rts >= 10.79) return Colors.green;
    if (rts >= 7.84) return Colors.lightGreen;
    if (rts >= 4.09) return Colors.orange;
    return Colors.red;
  }
}

