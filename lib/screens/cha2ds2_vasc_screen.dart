import 'package:flutter/material.dart';
import '../models/cha2ds2_vasc_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

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

    return CalculatorScaffold(
      title: 'CHA₂DS₂-VASc',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Risco de AVC em Fibrilação Atrial.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildYesNoQuestion('Insuficiência Cardíaca Congestiva', _data.insuficienciaCardiaca, (val) => setState(() => _data.insuficienciaCardiaca = val)),
          _buildYesNoQuestion('Hipertensão Arterial Sistêmica', _data.hipertensao, (val) => setState(() => _data.hipertensao = val)),
          
          // Age Question custom
           Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Idade', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
                const SizedBox(height: 12),
                TextField(
                  controller: _idadeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Idade (anos)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (_) => _updateIdade(),
                ),
                 const SizedBox(height: 8),
                 Text('Pontos: ${_data.idade}', style: const TextStyle(fontSize: 14, color: Colors.indigo, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          _buildYesNoQuestion('Diabetes Mellitus', _data.diabetes, (val) => setState(() => _data.diabetes = val)),
          _buildYesNoQuestion('AVC / AIT / Tromboembolismo prévio', _data.acidenteVascular, (val) => setState(() => _data.acidenteVascular = val)),
          _buildYesNoQuestion('Doença Vascular (IM prévio, DAP, placa aórtica)', _data.doencaVascular, (val) => setState(() => _data.doencaVascular = val)),
          
           QuestionCard<int>(
            title: 'Sexo',
            value: _data.sexo,
            onChanged: (v) => setState(() => _data.sexo = v),
            options: const [
              QuestionOption(label: 'Masculino (0)', value: 0),
              QuestionOption(label: 'Feminino (1)', value: 1),
            ],
          ),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(score),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(score).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text(' CHA₂DS₂-VASc', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const SizedBox(height: 12),
                Text(
                  risco,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                   textAlign: TextAlign.center,
                ),
                 const SizedBox(height: 4),
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
        onPressed: _salvarCHA2DS2VASc,
        backgroundColor: Colors.blue.shade900,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildYesNoQuestion(String title, bool value, ValueChanged<bool> onChanged) {
    return QuestionCard<bool>(
      title: title,
      value: value,
      onChanged: onChanged,
      options: const [
        QuestionOption(label: 'Não', value: false),
        QuestionOption(label: 'Sim', value: true),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 1) return Colors.green;
    if (score <= 3) return Colors.orange;
    return Colors.red;
  }
}
