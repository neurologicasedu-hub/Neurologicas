import 'package:flutter/material.dart';
import '../models/cdt_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class CDTScreen extends StatefulWidget {
  const CDTScreen({super.key});

  @override
  State<CDTScreen> createState() => _CDTScreenState();
}

class _CDTScreenState extends State<CDTScreen> {
  final CDTData _data = CDTData();

  Future<void> _salvarCDT() async {
    try {
      final score = CompletedScore(
        scoreName: 'Clock Drawing Test (CDT)',
        scoreData: {
          'contornoRelogio': _data.contornoRelogio,
          'numerosPresentes': _data.numerosPresentes,
          'numerosCorretos': _data.numerosCorretos,
          'ponteirosPresentes': _data.ponteirosPresentes,
          'horarioCorreto': _data.horarioCorreto,
        },
        resultado: '${_data.totalScore}/10 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala CDT salva com sucesso!'),
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

  Widget _buildSliderItem(String title, String description, int value, int max, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(description, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('0', style: TextStyle(fontSize: 10)),
                Text('$value/$max', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('$max', style: const TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: max.toDouble(),
              divisions: max,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.blue.shade700,
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
        title: const Text('Clock Drawing Test'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.blue.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Instruções', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('Peça ao paciente para desenhar um relógio mostrando "11:10" (ou outro horário específico). Avalie cada componente:', style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ),
          _buildSliderItem(
            '1. Contorno do Relógio',
            '2 pontos: círculo fechado e razoavelmente circular\n1 ponto: círculo mas não completamente fechado ou não muito circular\n0 pontos: não há círculo ou figura não reconhecível',
            _data.contornoRelogio,
            2,
            (v) => setState(() => _data.contornoRelogio = v),
          ),
          _buildSliderItem(
            '2. Números Presentes',
            '4 pontos: todos os 12 números presentes\n3 pontos: 10-11 números\n2 pontos: 8-9 números\n1 ponto: 5-7 números\n0 pontos: menos de 5 números',
            _data.numerosPresentes,
            4,
            (v) => setState(() => _data.numerosPresentes = v),
          ),
          _buildSliderItem(
            '3. Posição dos Números',
            '4 pontos: números bem posicionados no círculo\n3 pontos: pequenos erros na posição\n2 pontos: erros moderados na posição\n1 ponto: erros graves na posição\n0 pontos: números não posicionados adequadamente',
            _data.numerosCorretos,
            4,
            (v) => setState(() => _data.numerosCorretos = v),
          ),
          _buildSliderItem(
            '4. Ponteiros Presentes',
            '2 pontos: dois ponteiros claramente distintos (hora e minuto)\n1 ponto: um ponteiro ou dois ponteiros mas não claramente distintos\n0 pontos: nenhum ponteiro ou ponteiros não reconhecíveis',
            _data.ponteirosPresentes,
            2,
            (v) => setState(() => _data.ponteirosPresentes = v),
          ),
          _buildSliderItem(
            '5. Horário Correto',
            '3 pontos: horário exatamente correto\n2 pontos: horário próximo (dentro de 15 minutos)\n1 ponto: horário razoável mas com erro maior\n0 pontos: horário incorreto ou sem relação com o solicitado',
            _data.horarioCorreto,
            3,
            (v) => setState(() => _data.horarioCorreto = v),
          ),
          const SizedBox(height: 16),
          Card(
            color: score >= 8 ? Colors.green : score >= 5 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('CDT Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/10', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarCDT,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala CDT'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

