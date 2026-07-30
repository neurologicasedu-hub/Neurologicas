import 'package:flutter/material.dart';
import '../models/ess_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class ESSScreen extends StatefulWidget {
  const ESSScreen({super.key});

  @override
  State<ESSScreen> createState() => _ESSScreenState();
}

class _ESSScreenState extends State<ESSScreen> {
  final ESSData _data = ESSData();

  final List<String> _situations = [
    'Sentado e lendo',
    'Assistindo TV',
    'Sentado, inativo em um lugar público (ex: teatro)',
    'Como passageiro em um carro por 1h sem intervalo',
    'Deitado para descansar à tarde, quando possível',
    'Sentado e conversando com alguém',
    'Sentado calmamente após o almoço (sem álcool)',
    'Em um carro, enquanto parado no trânsito',
  ];

  Future<void> _salvarESS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Epworth Sleepiness Scale (ESS)',
        scoreData: {
          'sentadoLendo': _data.sentadoLendo,
          'assistindoTV': _data.assistindoTV,
          'lugarPublico': _data.lugarPublico,
          'passageiroCarro': _data.passageiroCarro,
          'descansarTarde': _data.descansarTarde,
          'conversando': _data.conversando,
          'depoisAlmoco': _data.depoisAlmoco,
          'carroTransito': _data.carroTransito,
        },
        resultado: '${_data.totalScore}/24 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ESS salva com sucesso!'),
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
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'Epworth Sleepiness Scale',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Qual a chance de cochilar nessas situações?\n0=Nunca, 3=Alta chance',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

          _buildSituationItem(0, _situations[0], _data.sentadoLendo, (v) => setState(() => _data.sentadoLendo = v)),
          _buildSituationItem(1, _situations[1], _data.assistindoTV, (v) => setState(() => _data.assistindoTV = v)),
          _buildSituationItem(2, _situations[2], _data.lugarPublico, (v) => setState(() => _data.lugarPublico = v)),
          _buildSituationItem(3, _situations[3], _data.passageiroCarro, (v) => setState(() => _data.passageiroCarro = v)),
          _buildSituationItem(4, _situations[4], _data.descansarTarde, (v) => setState(() => _data.descansarTarde = v)),
          _buildSituationItem(5, _situations[5], _data.conversando, (v) => setState(() => _data.conversando = v)),
          _buildSituationItem(6, _situations[6], _data.depoisAlmoco, (v) => setState(() => _data.depoisAlmoco = v)),
          _buildSituationItem(7, _situations[7], _data.carroTransito, (v) => setState(() => _data.carroTransito = v)),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 6 ? Colors.green : score <= 9 ? Colors.lightGreen : score <= 15 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 6 ? Colors.green : score <= 9 ? Colors.lightGreen : score <= 15 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('ESS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score/24',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 12),
                 Text(
                  _data.interpretation,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarESS,
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSituationItem(int index, String title, int value, ValueChanged<int> onChanged) {
    return QuestionCard<int>(
      title: title,
      value: value,
      onChanged: onChanged,
      options: const [
        QuestionOption(label: '0', value: 0),
        QuestionOption(label: '1', value: 1),
        QuestionOption(label: '2', value: 2),
        QuestionOption(label: '3', value: 3),
      ],
    );
  }
}
