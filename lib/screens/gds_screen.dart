import 'package:flutter/material.dart';
import '../models/gds_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class GDSScreen extends StatefulWidget {
  const GDSScreen({super.key});

  @override
  State<GDSScreen> createState() => _GDSScreenState();
}

class _GDSScreenState extends State<GDSScreen> {
  final GDSData _data = GDSData();

  final List<String> _questions = [
    'Você está satisfeito(a) com sua vida?', // Item 1 - Normal (Sim=0, Não=1)
    'Você abandonou muitas de suas atividades e interesses?', // Item 2 - Normal (Sim=1, Não=0)
    'Você sente que sua vida está vazia?', // Item 3 - Normal (Sim=1, Não=0)
    'Você se sente entediado(a) frequentemente?', // Item 4 - Normal (Sim=1, Não=0)
    'Você se sente bem a maior parte do tempo?', // Item 5 - INVERTIDO (Sim=0, Não=1)
    'Você tem medo de que algo ruim vá acontecer a você?', // Item 6 - Normal (Sim=1, Não=0)
    'Você se sente feliz a maior parte do tempo?', // Item 7 - INVERTIDO (Sim=0, Não=1)
    'Você frequentemente se sente desamparado(a)?', // Item 8 - Normal (Sim=1, Não=0)
    'Você prefere ficar em casa ao invés de sair e fazer coisas novas?', // Item 9 - Normal (Sim=1, Não=0)
    'Você acha que tem mais problemas com memória do que a maioria?', // Item 10 - Normal (Sim=1, Não=0)
    'Você acha que é maravilhoso estar vivo?', // Item 11 - INVERTIDO (Sim=0, Não=1)
    'Você se sente sem valor da forma que está?', // Item 12 - Normal (Sim=1, Não=0)
    'Você se sente cheio(a) de energia?', // Item 13 - INVERTIDO (Sim=0, Não=1)
    'Você sente que sua situação é sem esperança?', // Item 14 - Normal (Sim=1, Não=0)
    'Você acha que a maioria das pessoas está melhor que você?', // Item 15 - Normal (Sim=1, Não=0)
  ];

  Future<void> _salvarGDS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Geriatric Depression Scale (GDS-15)',
        scoreData: {'respostas': _data.respostas},
        resultado: '${_data.totalScore}/15 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala GDS salva com sucesso!'),
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
    final itensInvertidos = [4, 6, 10, 12]; // Itens 5, 7, 11, 13 (base 0)
    final isInvertido = itensInvertidos.contains(index);
    
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
                if (isInvertido)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(4)),
                    child: Text('Invertido', style: TextStyle(fontSize: 9, color: Colors.orange.shade900)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            RadioListTile<int>(
              title: const Text('Sim', style: TextStyle(fontSize: 12)),
              value: 1,
              groupValue: value,
              onChanged: (val) => onChanged(val ?? 0),
              activeColor: Colors.teal,
              dense: true,
            ),
            RadioListTile<int>(
              title: const Text('Não', style: TextStyle(fontSize: 12)),
              value: 0,
              groupValue: value,
              onChanged: (val) => onChanged(val ?? 0),
              activeColor: Colors.teal,
              dense: true,
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
        title: const Text('GDS-15'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Instruções', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Responda SIM ou NÃO para cada pergunta baseado em como você se sentiu na última semana.', style: TextStyle(fontSize: 11)),
                  const SizedBox(height: 4),
                  Text('Nota: Alguns itens são invertidos na pontuação (marcados com etiqueta "Invertido").', style: TextStyle(fontSize: 10, color: Colors.teal.shade800, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          ...List.generate(15, (i) => _buildQuestionItem(i, _questions[i], _data.respostas[i], (v) => setState(() => _data.respostas[i] = v))),
          const SizedBox(height: 16),
          Card(
            color: score <= 5 ? Colors.green : score <= 10 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('GDS Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/15', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarGDS,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala GDS'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

