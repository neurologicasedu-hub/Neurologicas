import 'package:flutter/material.dart';
import '../models/rts_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';

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

    return CalculatorScaffold(
      title: 'Revised Trauma Score',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Avaliação inicial de trauma baseada em parâmetros fisiológicos.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildNumberInput('Glasgow Coma Scale (3-15)', _gcsController, '', Icons.visibility),
          _buildNumberInput('Pressão Arterial Sistólica', _pasController, 'mmHg', Icons.speed),
          _buildNumberInput('Frequência Respiratória', _frController, 'rpm', Icons.air),
          
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(rts),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(rts).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('RTS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  rts.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const SizedBox(height: 12),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                   child: Text(
                      interpretacao,
                      style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                 ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarRTS,
        backgroundColor: Colors.orange,
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
          icon: Icon(icon, color: Colors.orange),
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        onChanged: (_) {
           _updateData();
           onDataChanged();
        }
      ),
    );
  }

  Color _getScoreColor(double rts) {
    if (rts >= 10) return Colors.green;
    if (rts >= 7) return Colors.lightGreen;
    if (rts >= 4) return Colors.orange;
    return Colors.red;
  }
}
