import 'package:flutter/material.dart';
import '../models/cha2ds2_vasc_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class CHA2DS2VAScScreen extends StatefulWidget {
  const CHA2DS2VAScScreen({super.key});
  @override
  State<CHA2DS2VAScScreen> createState() => _CHA2DS2VAScScreenState();
}

class _CHA2DS2VAScScreenState extends State<CHA2DS2VAScScreen> {
  final CHA2DS2VAScData _data = CHA2DS2VAScData();
  final TextEditingController _idadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    final patient = await PatientService.loadPatientData();
    if (patient != null && patient.idade != null) {
      _idadeController.text = patient.idade!.toString();
      _updateIdade();
    }
    if (patient != null && patient.sexo != null) {
      setState(() {
        _data.sexo = patient.sexo == 'F' ? 1 : 0;
      });
    }
  }

  @override
  void dispose() {
    _idadeController.dispose();
    super.dispose();
  }

  void _updateIdade() {
    setState(() {
      final idade = int.tryParse(_idadeController.text) ?? 0;
      if (idade < 65) {
        _data.idade = 0;
      } else if (idade < 75) _data.idade = 1;
      else _data.idade = 2;
    });
  }

  Future<void> _salvarCHA2DS2VASc() async {
    try {
      final score = CompletedScore(
        scoreName: 'CHA₂DS₂-VASc Score',
        scoreData: {
          'insuficienciaCardiaca': _data.insuficienciaCardiaca,
          'hipertensao': _data.hipertensao,
          'idade': _data.idade,
          'diabetes': _data.diabetes,
          'acidenteVascular': _data.acidenteVascular,
          'doencaVascular': _data.doencaVascular,
          'sexo': _data.sexo,
        },
        resultado: '${_data.riscoEmbolico} - ${_data.conduta}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala CHA₂DS₂-VASc salva com sucesso!'),
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
    final risco = _data.riscoEmbolico;
    final conduta = _data.conduta;

    return Scaffold(
      appBar: AppBar(title: const Text('CHA₂DS₂-VASc Score'), centerTitle: true, backgroundColor: Colors.blue.shade900),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('CHA₂DS₂-VASc Score para Fibrilação Atrial', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          _buildCheckboxItem('Insuficiência Cardíaca Congestiva', _data.insuficienciaCardiaca, (val) => setState(() => _data.insuficienciaCardiaca = val)),
          _buildCheckboxItem('Hipertensão Arterial', _data.hipertensao, (val) => setState(() => _data.hipertensao = val)),
          TextField(controller: _idadeController, decoration: const InputDecoration(labelText: 'Idade (anos)', border: OutlineInputBorder()), keyboardType: TextInputType.number, onChanged: (_) => _updateIdade()),
          _buildCheckboxItem('Diabetes Mellitus', _data.diabetes, (val) => setState(() => _data.diabetes = val)),
          _buildCheckboxItem('AVC/TIA Prévio', _data.acidenteVascular, (val) => setState(() => _data.acidenteVascular = val)),
          _buildCheckboxItem('Doença Vascular', _data.doencaVascular, (val) => setState(() => _data.doencaVascular = val)),
          _buildRadioItem('Sexo', ['Masculino (0)', 'Feminino (1)'], _data.sexo, (val) => setState(() => _data.sexo = val)),
          const SizedBox(height: 16),
          Card(color: _getScoreColor(score), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 6, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text('CHA₂DS₂-VASc Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 8), Text('$score', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), Text(risco, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center), const SizedBox(height: 12), Text(conduta, style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center)]))),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarCHA2DS2VASc();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala CHA₂DS₂-VASc'),
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
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Card(margin: const EdgeInsets.symmetric(vertical: 4), elevation: 1, child: CheckboxListTile(title: Text(title, style: const TextStyle(fontSize: 14)), value: value, onChanged: (val) => onChanged(val ?? false), activeColor: Colors.blue.shade900));
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
              return RadioListTile<int>(
                title: Text(entry.value, style: const TextStyle(fontSize: 13)),
                value: entry.key,
                groupValue: value,
                onChanged: (val) => onChanged(val ?? 0),
                activeColor: Colors.blue.shade900,
                dense: true,
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 1) return Colors.green;
    if (score <= 3) return Colors.orange;
    return Colors.red;
  }
}

