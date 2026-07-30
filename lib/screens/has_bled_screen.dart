import 'package:flutter/material.dart';
import '../models/has_bled_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class HASBLEDScreen extends StatefulWidget {
  const HASBLEDScreen({super.key});
  @override
  State<HASBLEDScreen> createState() => _HASBLEDScreenState();
}

class _HASBLEDScreenState extends State<HASBLEDScreen> {
  final HASBLEDData _data = HASBLEDData();
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

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    final risco = _data.riscoSangramento;
    final conduta = _data.conduta;

    return CalculatorScaffold(
      title: 'HAS-BLED',
      body: [
         Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Risco de sangramento em pacientes com FA.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          _buildYesNoQuestion('Hipertensão (SBP >160)', _data.hipertensao, (val) => setState(() => _data.hipertensao = val)),
          _buildYesNoQuestion('Função Renal Anormal', _data.funcaoRenal, (val) => setState(() => _data.funcaoRenal = val)),
          _buildYesNoQuestion('Função Hepática Anormal', _data.funcaoHepatica, (val) => setState(() => _data.funcaoHepatica = val)),
          _buildYesNoQuestion('AVC Prévio', _data.acidenteVascular, (val) => setState(() => _data.acidenteVascular = val)),
          _buildYesNoQuestion('Sangramento Maior Prévio/Predisposição', _data.sangramento, (val) => setState(() => _data.sangramento = val)),
          _buildYesNoQuestion('Labilidade INR', _data.labilidadeINR, (val) => setState(() => _data.labilidadeINR = val)),
          
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
                 Text('Pontos: ${_data.idade}', style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          _buildYesNoQuestion('Uso de Drogas ou Álcool', _data.drogas, (val) => setState(() => _data.drogas = val)),
          _buildYesNoQuestion('Medicamentos que predispõem sangramento', _data.medicacoes, (val) => setState(() => _data.medicacoes = val)),

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
                const Text('HAS-BLED SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const SizedBox(height: 12),
                 Text(
                  risco,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
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
        onPressed: _salvarHASBLED,
        backgroundColor: Colors.red.shade800,
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
    if (score <= 2) return Colors.green;
    if (score == 3) return Colors.orange;
    return Colors.red;
  }
}
