import 'package:flutter/material.dart';
import '../models/icp_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class ICPScreen extends StatefulWidget {
  const ICPScreen({super.key});

  @override
  State<ICPScreen> createState() => _ICPScreenState();
}

class _ICPScreenState extends State<ICPScreen> {
  final ICPData _data = ICPData();
  final TextEditingController _icpController = TextEditingController(text: '10');
  final TextEditingController _pamController = TextEditingController(text: '70');

  @override
  void dispose() {
    _icpController.dispose();
    _pamController.dispose();
    super.dispose();
  }

  void _updateData() {
    setState(() {
      _data.pressaoIntracraniana = double.tryParse(_icpController.text) ?? 10;
      _data.pressaoArterialMedia = double.tryParse(_pamController.text) ?? 70;
    });
  }

  Future<void> _salvarICP() async {
    try {
      final score = CompletedScore(
        scoreName: 'ICP Monitoring',
        scoreData: {
          'pressaoIntracraniana': _data.pressaoIntracraniana,
          'pressaoArterialMedia': _data.pressaoArterialMedia,
          'pressaoPerfusaoCerebral': _data.pressaoPerfusaoCerebralCalculada,
        },
        resultado: 'ICP: ${_data.classificacaoICP} | PPC: ${_data.classificacaoPPC} - ${_data.conduta}',
        totalScore: _data.pressaoIntracraniana.round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ICP salva com sucesso!'),
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
    final ppc = _data.pressaoPerfusaoCerebralCalculada;
    final classificacaoICP = _data.classificacaoICP;
    final classificacaoPPC = _data.classificacaoPPC;
    final conduta = _data.conduta;

    return CalculatorScaffold(
      title: 'ICP Monitoring',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Monitorização de Pressão Intracraniana e Perfusão Cerebral',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildNumberInput('Pressão Intracraniana (ICP)', _icpController, 'mmHg', Icons.speed),
          _buildNumberInput('Pressão Arterial Média (PAM)', _pamController, 'mmHg', Icons.favorite_border),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getICPPCColor(_data.pressaoIntracraniana),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: _getICPPCColor(_data.pressaoIntracraniana).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                const Text('PRESSÃO INTRACRANIANA (ICP)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '${_data.pressaoIntracraniana.toStringAsFixed(1)} mmHg',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                 Text(
                  classificacaoICP,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                   textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getPPCColor(ppc),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                 BoxShadow(color: _getPPCColor(ppc).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                const Text('PRESSÃO DE PERFUSÃO (PPC)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                 const SizedBox(height: 8),
                Text(
                  '${ppc.toStringAsFixed(1)} mmHg',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                 const SizedBox(height: 4),
                 Text(
                  classificacaoPPC,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                   textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
           Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(16),
               border: Border.all(color: Colors.grey.shade200),
             ),
             child: Column(
               children: [
                  Row(children: [
                    Icon(Icons.medical_services_outlined, size: 20, color: Colors.deepOrange),
                    const SizedBox(width: 8),
                    const Text('Conduta Recomendada', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ]),
                 const SizedBox(height: 8),
                 Text(conduta, style: TextStyle(fontSize: 14, color: Colors.grey[800])),
               ],
             ),
           ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarICP,
        backgroundColor: Colors.deepOrange,
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
          icon: Icon(icon, color: Colors.deepOrange),
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        onChanged: (_) => _updateData(),
      ),
    );
  }

  Color _getICPPCColor(double value) {
    if (value < 15) return Colors.green;
    if (value < 20) return Colors.lightGreen;
    if (value < 25) return Colors.orange;
    if (value < 35) return Colors.deepOrange;
    return Colors.red;
  }

  Color _getPPCColor(double value) {
    if (value >= 70) return Colors.green;
    if (value >= 50) return Colors.orange;
    if (value >= 40) return Colors.deepOrange;
    return Colors.red;
  }
}
