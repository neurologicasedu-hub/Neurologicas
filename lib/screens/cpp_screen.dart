import 'package:flutter/material.dart';
import '../models/cpp_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class CPPScreen extends StatefulWidget {
  const CPPScreen({super.key});
  @override
  State<CPPScreen> createState() => _CPPScreenState();
}

class _CPPScreenState extends State<CPPScreen> {
  final CPPData _data = CPPData();
  final TextEditingController _pamController = TextEditingController(text: '80.0');
  final TextEditingController _icpController = TextEditingController(text: '10.0');

  @override
  void dispose() {
    _pamController.dispose();
    _icpController.dispose();
    super.dispose();
  }

  void _updateData() {
    setState(() {
      _data.pressaoArterialMedia = double.tryParse(_pamController.text) ?? 80.0;
      _data.pressaoIntracraniana = double.tryParse(_icpController.text) ?? 10.0;
    });
  }

  Future<void> _salvarCPP() async {
    try {
      final score = CompletedScore(
        scoreName: 'Cerebral Perfusion Pressure (CPP)',
        scoreData: {
          'pressaoArterialMedia': _data.pressaoArterialMedia,
          'pressaoIntracraniana': _data.pressaoIntracraniana,
        },
        resultado: '${_data.interpretacao} - ${_data.conduta}',
        totalScore: _data.cpp.round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala CPP salva com sucesso!'),
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
    final cpp = _data.cpp;
    final interpretacao = _data.interpretacao;
    final conduta = _data.conduta;

    return CalculatorScaffold(
      title: 'CPP Calculator',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Cerebral Perfusion Pressure = PAM - ICP',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildNumberInput('Pressão Arterial Média (PAM)', _pamController, 'mmHg', Icons.speed),
          _buildNumberInput('Pressão Intracraniana (ICP)', _icpController, 'mmHg', Icons.psychology),
          
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getCPPColor(cpp),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getCPPColor(cpp).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('CPP (PPC)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  cpp.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const Text('mmHg', style: TextStyle(fontSize: 16, color: Colors.white70)),
                 const SizedBox(height: 12),
                 Text(
                  interpretacao,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
        onPressed: _salvarCPP,
        backgroundColor: Colors.cyan,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildNumberInput(String label, TextEditingController ctrl, String suffix, IconData icon) {
     return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          icon: Icon(icon, color: Colors.cyan),
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        onChanged: (_) => _updateData(),
      ),
    );
  }

  Color _getCPPColor(double cpp) {
    if (cpp >= 70 && cpp <= 100) return Colors.green;
    if (cpp >= 60 && cpp < 70) return Colors.orange;
    if (cpp < 60) return Colors.red;
    return Colors.orange; // >100 maybe orange/red?
  }
}
