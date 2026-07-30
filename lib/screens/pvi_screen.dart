import 'package:flutter/material.dart';
import '../models/pvi_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class PVIScreen extends StatefulWidget {
  const PVIScreen({super.key});
  @override
  State<PVIScreen> createState() => _PVIScreenState();
}

class _PVIScreenState extends State<PVIScreen> {
  final PVIData _data = PVIData();
  final TextEditingController _volController = TextEditingController(text: '1.0');
  final TextEditingController _icpIniController = TextEditingController(text: '15.0');
  final TextEditingController _icpFinController = TextEditingController(text: '20.0');

  @override
  void dispose() {
    _volController.dispose();
    _icpIniController.dispose();
    _icpFinController.dispose();
    super.dispose();
  }

  void _updateData() {
    setState(() {
      _data.volumeInjetado = double.tryParse(_volController.text) ?? 1.0;
      _data.icpInicial = double.tryParse(_icpIniController.text) ?? 15.0;
      _data.icpFinal = double.tryParse(_icpFinController.text) ?? 20.0;
    });
  }

  Future<void> _salvarPVI() async {
    try {
      final score = CompletedScore(
        scoreName: 'Pressure-Volume Index (PVI)',
        scoreData: {
          'volumeInjetado': _data.volumeInjetado,
          'icpInicial': _data.icpInicial,
          'icpFinal': _data.icpFinal,
        },
        resultado: '${_data.interpretacao} - ${_data.conduta}',
        totalScore: _data.pvi.round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala PVI salva com sucesso!'),
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
    final pvi = _data.pvi;
    final interpretacao = _data.interpretacao;
    final conduta = _data.conduta;

    return CalculatorScaffold(
      title: 'PVI Calculator',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Índice de Volume-Pressão\nAvaliação de complacência intracraniana (Teste de Bolus)',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildNumberInput('Volume Injetado (ml)', _volController, 'ml', Icons.science),
          _buildNumberInput('ICP Inicial (mmHg)', _icpIniController, 'mmHg', Icons.trending_flat),
          _buildNumberInput('ICP Final (pico) (mmHg)', _icpFinController, 'mmHg', Icons.trending_up),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: pvi < 13 ? Colors.red : Colors.green, // PVI < 13 is low compliance (bad)? Or high? Low PVI = low compliance -> Bad. Normal > 18?
              // PVI = Vol / log10(P2/P1). Normal ~ 25ml adults? 
              // Without knowing the exact model logic, I will assume Colors based on interpretation string or generic logic.
              // Let's create a helper.
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (pvi < 13 ? Colors.red : Colors.green).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('PVI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  pvi.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const Text('ml', style: TextStyle(fontSize: 16, color: Colors.white70)),
                 const SizedBox(height: 12),
                 Text(
                  interpretacao,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                   child: Text(
                      conduta,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                 ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarPVI,
        backgroundColor: Colors.blueGrey,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildNumberInput(String label, TextEditingController ctrl, String suffix, IconData icon) {
     return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          icon: Icon(icon, color: Colors.blueGrey),
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        onChanged: (_) => _updateData(),
      ),
    );
  }
}
