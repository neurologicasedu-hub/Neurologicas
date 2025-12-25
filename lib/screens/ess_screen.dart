import 'package:flutter/material.dart';
import '../models/ess_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

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
    'Sentado, inativo em um lugar público (por exemplo, teatro ou reunião)',
    'Como passageiro em um carro por uma hora sem intervalo',
    'Deitado para descansar à tarde, quando possível',
    'Sentado e conversando com alguém',
    'Sentado calmamente após o almoço sem álcool',
    'Em um carro, enquanto parado por alguns minutos no trânsito',
  ];

  final List<String> _options = ['Nunca cochilaria (0)', 'Pequena chance de cochilar (1)', 'Moderada chance de cochilar (2)', 'Alta chance de cochilar (3)'];

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

  Widget _buildSituationItem(int index, String situation, int value, ValueChanged<int> onChanged) {
    final List<int> values = [0, 1, 2, 3];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index + 1}. $situation', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...values.map((v) => RadioListTile<int>(
              title: Text(_options[v], style: const TextStyle(fontSize: 12)),
              value: v,
              groupValue: value,
              onChanged: (val) => onChanged(val ?? 0),
              activeColor: Colors.indigo,
              dense: true,
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Epworth Sleepiness Scale'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'ESS - Epworth Sleepiness Scale\nUse a escala seguinte para escolher a opção mais apropriada para indicar a sua chance de cochilar ou adormecer nas seguintes situações:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildSituationItem(0, _situations[0], _data.sentadoLendo, (v) => setState(() => _data.sentadoLendo = v)),
          _buildSituationItem(1, _situations[1], _data.assistindoTV, (v) => setState(() => _data.assistindoTV = v)),
          _buildSituationItem(2, _situations[2], _data.lugarPublico, (v) => setState(() => _data.lugarPublico = v)),
          _buildSituationItem(3, _situations[3], _data.passageiroCarro, (v) => setState(() => _data.passageiroCarro = v)),
          _buildSituationItem(4, _situations[4], _data.descansarTarde, (v) => setState(() => _data.descansarTarde = v)),
          _buildSituationItem(5, _situations[5], _data.conversando, (v) => setState(() => _data.conversando = v)),
          _buildSituationItem(6, _situations[6], _data.depoisAlmoco, (v) => setState(() => _data.depoisAlmoco = v)),
          _buildSituationItem(7, _situations[7], _data.carroTransito, (v) => setState(() => _data.carroTransito = v)),
          const SizedBox(height: 16),
          Card(
            color: score <= 6 ? Colors.green : score <= 9 ? Colors.lightGreen : score <= 15 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('ESS Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/24', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarESS,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala ESS'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}
