import 'package:flutter/material.dart';
import '../models/lawton_iadl_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class LawtonIADLScreen extends StatefulWidget {
  const LawtonIADLScreen({super.key});

  @override
  State<LawtonIADLScreen> createState() => _LawtonIADLScreenState();
}

class _LawtonIADLScreenState extends State<LawtonIADLScreen> {
  final LawtonIADLData _data = LawtonIADLData();

  // Mapping item name to data property setters/getters would be cleaner with a map or similar, 
  // but explicitly writing them ensures type safety and clarity given the model structure.

  Future<void> _salvarLawtonIADL() async {
    try {
      final score = CompletedScore(
        scoreName: 'Lawton IADL Scale',
        scoreData: {
          'telefone': _data.telefone,
          'compras': _data.compras,
          'prepararComida': _data.prepararComida,
          'cuidadosCasa': _data.cuidadosCasa,
          'lavarRoupa': _data.lavarRoupa,
          'transporte': _data.transporte,
          'medicamentos': _data.medicamentos,
          'financas': _data.financas,
        },
        resultado: '${_data.totalScore}/8 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Lawton IADL salva com sucesso!'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Lawton IADL',
      body: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Escala de Atividades Instrumentais da Vida Diária.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),

        _buildQuestion('1. Usar o telefone', _data.telefone, (v) => setState(() => _data.telefone = v)),
        _buildQuestion('2. Fazer compras', _data.compras, (v) => setState(() => _data.compras = v)),
        _buildQuestion('3. Preparar comida', _data.prepararComida, (v) => setState(() => _data.prepararComida = v)),
        _buildQuestion('4. Cuidar da casa', _data.cuidadosCasa, (v) => setState(() => _data.cuidadosCasa = v)),
        _buildQuestion('5. Lavar roupa', _data.lavarRoupa, (v) => setState(() => _data.lavarRoupa = v)),
        _buildQuestion('6. Usar transporte', _data.transporte, (v) => setState(() => _data.transporte = v)),
        _buildQuestion('7. Tomar medicamentos', _data.medicamentos, (v) => setState(() => _data.medicamentos = v)),
        _buildQuestion('8. Administrar finanças', _data.financas, (v) => setState(() => _data.financas = v)),

        // Result Card
        Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(_data.totalScore),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(_data.totalScore).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('PONTUAÇÃO TOTAL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '${_data.totalScore}',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const Text(
                  '/ 8',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                   child: Text(
                    _data.interpretation,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarLawtonIADL,
        backgroundColor: _getScoreColor(_data.totalScore),
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildQuestion(String title, int value, ValueChanged<int> onChanged) {
    return QuestionCard<int>(
      title: title,
      value: value,
      onChanged: onChanged,
      options: const [
        QuestionOption(label: 'Independente (1)', value: 1),
        QuestionOption(label: 'Dependente (0)', value: 0),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score == 8) return Colors.green;
    if (score >= 5) return Colors.orange;
    return Colors.red;
  }
}
