import 'package:flutter/material.dart';
import '../models/midas_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class MIDASScreen extends StatefulWidget {
  const MIDASScreen({super.key});

  @override
  State<MIDASScreen> createState() => _MIDASScreenState();
}

class _MIDASScreenState extends State<MIDASScreen> {
  final MIDASData _data = MIDASData();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  final List<String> _questions = [
    'Quantos dias nas últimas 3 meses você teve capacidade reduzida para trabalhar ou estudar por causa da enxaqueca?',
    'Quantos dias nas últimas 3 meses você teve capacidade reduzida para realizar atividades domésticas por causa da enxaqueca?',
    'Quantos dias nas últimas 3 meses você ficou completamente impossibilitado(a) de participar de atividades familiares, sociais ou de lazer por causa da enxaqueca?',
    'Quantos dias nas últimas 3 meses você ficou completamente incapacitado(a) por causa da enxaqueca?',
  ];

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  Future<void> _salvarMIDAS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Migraine Disability Assessment (MIDAS)',
        scoreData: {
          'diasEscolaTrabalho': _data.diasEscolaTrabalho,
          'diasAtividadesDomesticas': _data.diasAtividadesDomesticas,
          'diasAtividadesFamiliares': _data.diasAtividadesFamiliares,
          'diasCompletamenteIncapacitado': _data.diasCompletamenteIncapacitado,
        },
        resultado: '${_data.totalScore} pontos - ${_data.interpretation} (${_data.classificacaoMIDAS})',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala MIDAS salva com sucesso!'),
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

  Widget _buildQuestionItem(int index, String question, TextEditingController controller, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index + 1}. $question', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de dias (0-90)',
                hintText: 'Ex: 5',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                final dias = int.tryParse(value) ?? 0;
                if (dias >= 0 && dias <= 90) {
                  onChanged(dias);
                }
              },
            ),
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
        title: const Text('MIDAS'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'MIDAS - Migraine Disability Assessment\nNas últimas 3 meses, quantos dias você teve problemas por causa da enxaqueca?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildQuestionItem(0, _questions[0], _controller1, (v) => setState(() => _data.diasEscolaTrabalho = v)),
          _buildQuestionItem(1, _questions[1], _controller2, (v) => setState(() => _data.diasAtividadesDomesticas = v)),
          _buildQuestionItem(2, _questions[2], _controller3, (v) => setState(() => _data.diasAtividadesFamiliares = v)),
          _buildQuestionItem(3, _questions[3], _controller4, (v) => setState(() => _data.diasCompletamenteIncapacitado = v)),
          const SizedBox(height: 16),
          Card(
            color: score <= 5 ? Colors.green : score <= 10 ? Colors.lightGreen : score <= 20 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('MIDAS Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score pontos', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(_data.classificacaoMIDAS, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarMIDAS,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala MIDAS'),
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

