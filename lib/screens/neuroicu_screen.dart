import 'package:flutter/material.dart';
import '../models/neuroicu_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class NeuroICUScreen extends StatefulWidget {
  const NeuroICUScreen({super.key});

  @override
  State<NeuroICUScreen> createState() => _NeuroICUScreenState();
}

class _NeuroICUScreenState extends State<NeuroICUScreen> {
  final NeuroICUData _data = NeuroICUData();

  Future<void> _salvarNeuroICU() async {
    try {
      final score = CompletedScore(
        scoreName: 'Neurointensivismo / UTI',
        scoreData: {
          'glasgowComaScale': _data.glasgowComaScale,
          'pressaoIntracraniana': _data.pressaoIntracraniana,
          'pressaoPerfusaoCerebral': _data.pressaoPerfusaoCerebral,
          'sedacao': _data.sedacao,
          'ventilacaoMecanica': _data.ventilacaoMecanica,
          'monitoramentoICP': _data.monitoramentoICP,
          'monitoramentoPPC': _data.monitoramentoPPC,
          'usoManitol': _data.usoManitol,
          'usoHipertonico': _data.usoHipertonico,
          'usoBarbituricos': _data.usoBarbituricos,
        },
        resultado: '${_data.classificacaoGeral} - ${_data.recomendacoes}',
        totalScore: null,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Neurointensivismo salva com sucesso!'),
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
  final TextEditingController _gcsController = TextEditingController(text: '15');
  final TextEditingController _icpController = TextEditingController(text: '10');
  final TextEditingController _ppcController = TextEditingController(text: '70');

  @override
  void dispose() {
    _gcsController.dispose();
    _icpController.dispose();
    _ppcController.dispose();
    super.dispose();
  }

  void _updateData() {
    setState(() {
      _data.glasgowComaScale = int.tryParse(_gcsController.text) ?? 15;
      _data.pressaoIntracraniana = double.tryParse(_icpController.text) ?? 10;
      _data.pressaoPerfusaoCerebral = double.tryParse(_ppcController.text) ?? 70;
    });
  }

  @override
  Widget build(BuildContext context) {
    final classificacao = _data.classificacaoGeral;
    final recomendacoes = _data.recomendacoes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Neurointensivismo / UTI'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Monitorização e Condutas em UTI Neuro',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _gcsController,
            decoration: const InputDecoration(
              labelText: 'Glasgow Coma Scale',
              hintText: 'Ex: 15',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => _updateData(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _icpController,
            decoration: const InputDecoration(
              labelText: 'Pressão Intracraniana (ICP) - mmHg',
              hintText: 'Ex: 15',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _updateData(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ppcController,
            decoration: const InputDecoration(
              labelText: 'Pressão de Perfusão Cerebral (PPC) - mmHg',
              hintText: 'Ex: 70',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _updateData(),
          ),
          const SizedBox(height: 12),
          _buildCheckboxItem('Sedação', _data.sedacao, (val) => setState(() => _data.sedacao = val)),
          _buildCheckboxItem('Ventilação Mecânica', _data.ventilacaoMecanica, (val) => setState(() => _data.ventilacaoMecanica = val)),
          _buildCheckboxItem('Monitoramento ICP', _data.monitoramentoICP, (val) => setState(() => _data.monitoramentoICP = val)),
          _buildCheckboxItem('Monitoramento PPC', _data.monitoramentoPPC, (val) => setState(() => _data.monitoramentoPPC = val)),
          _buildCheckboxItem('Uso de Manitol', _data.usoManitol, (val) => setState(() => _data.usoManitol = val)),
          _buildCheckboxItem('Uso de Solução Hipertônica', _data.usoHipertonico, (val) => setState(() => _data.usoHipertonico = val)),
          _buildCheckboxItem('Uso de Barbitúricos', _data.usoBarbituricos, (val) => setState(() => _data.usoBarbituricos = val)),
          const SizedBox(height: 16),
          Card(
            color: _getClassificacaoColor(classificacao),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Classificação', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(classificacao, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.blueGrey.shade700,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recomendações', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(recomendacoes, style: const TextStyle(fontSize: 13, color: Colors.white), textAlign: TextAlign.left),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarNeuroICU();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Neurointensivismo'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
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
        activeColor: Colors.blue,
      ),
    );
  }

  Color _getClassificacaoColor(String classificacao) {
    if (classificacao.contains('estável')) return Colors.green;
    if (classificacao.contains('crítico')) return Colors.red;
    return Colors.orange;
  }
}

