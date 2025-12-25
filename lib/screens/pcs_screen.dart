import 'package:flutter/material.dart';
import '../models/pcs_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class PainCatastrophizingScreen extends StatefulWidget {
  const PainCatastrophizingScreen({super.key});

  @override
  State<PainCatastrophizingScreen> createState() => _PainCatastrophizingScreenState();
}

class _PainCatastrophizingScreenState extends State<PainCatastrophizingScreen> {
  final PCSData _data = PCSData();

  final List<String> _questions = [
    'Quando estou com dor, fico preocupado(a) que nunca vai melhorar', // Ruminação
    'Quando estou com dor, sinto que não posso deixar de pensar na dor', // Ruminação
    'Quando estou com dor, fico preocupado(a) que vai piorar', // Ruminação
    'Quando estou com dor, penso em outras situações dolorosas', // Ruminação
    'Quando estou com dor, penso que a dor é terrível e que não suporto', // Magnificação
    'Quando estou com dor, penso que algo sério pode estar acontecendo', // Magnificação
    'Quando estou com dor, penso que outros não entendem como a dor é severa', // Magnificação
    'Quando estou com dor, não consigo deixar a dor fora da minha mente', // Desamparo
    'Quando estou com dor, não consigo ir em frente com a dor', // Desamparo
    'Quando estou com dor, não há nada que eu possa fazer para reduzir a intensidade da dor', // Desamparo
    'Quando estou com dor, sinto que não posso lidar com a dor', // Desamparo
    'Quando estou com dor, sinto que minha vida não vale a pena', // Desamparo
    'Quando estou com dor, sinto que não posso continuar assim', // Desamparo
  ];

  final List<String> _options = ['Não de jeito nenhum (0)', 'Levemente (1)', 'Moderadamente (2)', 'Severamente (3)', 'O tempo todo (4)'];

  Future<void> _salvarPCS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Pain Catastrophizing Scale (PCS)',
        scoreData: {'respostas': _data.respostas},
        resultado: '${_data.totalScore}/52 - ${_data.interpretation} (Ruminação: ${_data.scoreRumination}/16, Magnificação: ${_data.scoreMagnification}/12, Desamparo: ${_data.scoreHelplessness}/24)',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala PCS salva com sucesso!'),
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

  Widget _buildQuestionItem(int index, String question, int value, ValueChanged<int> onChanged) {
    String subscale = '';
    if (index < 4) {
      subscale = 'Ruminação';
    } else if (index < 7) subscale = 'Magnificação';
    else subscale = 'Desamparo';
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('${index + 1}. $question', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.deepPurple.shade100, borderRadius: BorderRadius.circular(4)),
                  child: Text(subscale, style: TextStyle(fontSize: 9, color: Colors.deepPurple.shade900)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._options.asMap().entries.map((entry) => RadioListTile<int>(
              title: Text(entry.value, style: const TextStyle(fontSize: 12)),
              value: entry.key,
              groupValue: value,
              onChanged: (val) => onChanged(val ?? 0),
              activeColor: Colors.deepPurple,
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
        title: const Text('Pain Catastrophizing Scale'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'PCS - Pain Catastrophizing Scale\nAvalia pensamentos catastróficos relacionados à dor (13 itens)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ...List.generate(13, (i) => _buildQuestionItem(i, _questions[i], _data.respostas[i], (v) => setState(() => _data.respostas[i] = v))),
          const SizedBox(height: 16),
          Card(
            color: score <= 20 ? Colors.green : score <= 30 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('PCS Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/52', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Ruminação: ${_data.scoreRumination}/16', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  Text('Magnificação: ${_data.scoreMagnification}/12', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  Text('Desamparo: ${_data.scoreHelplessness}/24', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarPCS,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala PCS'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}
