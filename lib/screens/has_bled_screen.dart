import 'package:flutter/material.dart';
import '../models/has_bled_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class HASBLEDScreen extends StatefulWidget {
  const HASBLEDScreen({super.key});
  @override
  State<HASBLEDScreen> createState() => _HASBLEDScreenState();
}

class _HASBLEDScreenState extends State<HASBLEDScreen> {
  final HASBLEDData _data = HASBLEDData();

  Future<void> _salvarHASBLED() async {
    try {
      final score = CompletedScore(
        scoreName: 'HAS-BLED Score',
        scoreData: {
          'hipertensao': _data.hipertensao,
          'funcaoRenal': _data.funcaoRenal,
          'funcaoHepatica': _data.funcaoHepatica,
          'acidenteVascular': _data.acidenteVascular,
          'sangramento': _data.sangramento,
          'labilidadeINR': _data.labilidadeINR,
          'idade': _data.idade,
          'drogas': _data.drogas,
          'medicacoes': _data.medicacoes,
        },
        resultado: '${_data.riscoSangramento} - ${_data.conduta}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala HAS-BLED salva com sucesso!'),
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
  final TextEditingController _idadeController = TextEditingController();

  @override
  void dispose() {
    _idadeController.dispose();
    super.dispose();
  }

  void _updateIdade() {
    setState(() {
      final idade = int.tryParse(_idadeController.text) ?? 0;
      _data.idade = idade >= 65 ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    final risco = _data.riscoSangramento;
    final conduta = _data.conduta;

    return Scaffold(
      appBar: AppBar(title: const Text('HAS-BLED Score'), centerTitle: true, backgroundColor: Colors.red.shade800),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('HAS-BLED Score - Risco de Sangramento', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          _buildCheckboxItem('Hipertensão (SBP >160)', _data.hipertensao, (val) => setState(() => _data.hipertensao = val)),
          _buildCheckboxItem('Função Renal/Hepática', _data.funcaoRenal || _data.funcaoHepatica, (val) => setState(() {
            _data.funcaoRenal = val;
            _data.funcaoHepatica = val;
          })),
          _buildCheckboxItem('AVC Prévio', _data.acidenteVascular, (val) => setState(() => _data.acidenteVascular = val)),
          _buildCheckboxItem('Sangramento Maior', _data.sangramento, (val) => setState(() => _data.sangramento = val)),
          _buildCheckboxItem('Labilidade INR', _data.labilidadeINR, (val) => setState(() => _data.labilidadeINR = val)),
          TextField(controller: _idadeController, decoration: const InputDecoration(labelText: 'Idade (anos)', border: OutlineInputBorder()), keyboardType: TextInputType.number, onChanged: (_) => _updateIdade()),
          _buildCheckboxItem('Drogas/Álcool', _data.drogas, (val) => setState(() => _data.drogas = val)),
          _buildCheckboxItem('Medicamentos Antiplaquetários', _data.medicacoes, (val) => setState(() => _data.medicacoes = val)),
          const SizedBox(height: 16),
          Card(color: _getScoreColor(score), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 6, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text('HAS-BLED Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 8), Text('$score', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), Text(risco, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center), const SizedBox(height: 12), Text(conduta, style: const TextStyle(fontSize: 13, color: Colors.white70), textAlign: TextAlign.center)]))),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarHASBLED();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala HAS-BLED'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Voltar'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade800, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12))),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Card(margin: const EdgeInsets.symmetric(vertical: 4), elevation: 1, child: CheckboxListTile(title: Text(title, style: const TextStyle(fontSize: 14)), value: value, onChanged: (val) => onChanged(val ?? false), activeColor: Colors.red.shade800));
  }

  Color _getScoreColor(int score) {
    if (score <= 2) return Colors.green;
    if (score == 3) return Colors.orange;
    return Colors.red;
  }
}

