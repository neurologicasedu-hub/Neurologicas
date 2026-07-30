import 'package:flutter/material.dart';
import '../models/neuroicu_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class NeuroICUScreen extends StatefulWidget {
  const NeuroICUScreen({super.key});

  @override
  State<NeuroICUScreen> createState() => _NeuroICUScreenState();
}

class _NeuroICUScreenState extends State<NeuroICUScreen> {
  final NeuroICUData _data = NeuroICUData();
  
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
              onPressed: () => Navigator.pushReplacementNamed(context, '/report'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      value: value,
      onChanged: (val) {
        onChanged(val);
        _updateData();
      },
      activeColor: Colors.purple,
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onChanged: (_) => _updateData(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Neurointensivismo',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Monitorização e Condutas em UTI Neuro',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text('Parâmetros Clínicos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 16),
                   _buildInput('GCS (Glasgow)', _gcsController),
                   _buildInput('PIC (mmHg)', _icpController),
                   _buildInput('PPC (mmHg)', _ppcController),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                _buildSwitch('Sedação', _data.sedacao, (v) => setState(() => _data.sedacao = v)),
                _buildSwitch('Ventilação Mecânica', _data.ventilacaoMecanica, (v) => setState(() => _data.ventilacaoMecanica = v)),
                _buildSwitch('Monitoramento PIC Invasivo', _data.monitoramentoICP, (v) => setState(() => _data.monitoramentoICP = v)),
                _buildSwitch('Monitoramento PPC', _data.monitoramentoPPC, (v) => setState(() => _data.monitoramentoPPC = v)),
                _buildSwitch('Uso de Manitol', _data.usoManitol, (v) => setState(() => _data.usoManitol = v)),
                _buildSwitch('Salina Hipertônica', _data.usoHipertonico, (v) => setState(() => _data.usoHipertonico = v)),
                _buildSwitch('Barbitúricos (Coma Induzido)', _data.usoBarbituricos, (v) => setState(() => _data.usoBarbituricos = v)),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Column(
              children: [
                const Text('RECOMENDAÇÕES', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
                const SizedBox(height: 12),
                Text(_data.classificacaoGeral, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(_data.recomendacoes, style: TextStyle(fontSize: 13, color: Colors.grey.shade800), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarNeuroICU,
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
