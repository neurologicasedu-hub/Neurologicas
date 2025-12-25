import 'package:flutter/material.dart';
import '../models/bims_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class BIMSScreen extends StatefulWidget {
  const BIMSScreen({super.key});

  @override
  State<BIMSScreen> createState() => _BIMSScreenState();
}

class _BIMSScreenState extends State<BIMSScreen> {
  final BIMSData _data = BIMSData();

  Future<void> _salvarBIMS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Brief Interview for Mental Status (BIMS)',
        scoreData: {
          'repetirPalavras': _data.repetirPalavras,
          'ano': _data.ano,
          'mes': _data.mes,
          'recordacao1': _data.recordacao1,
          'recordacao2': _data.recordacao2,
          'recordacao3': _data.recordacao3,
          'diaSemana': _data.diaSemana,
          'nomeDoisObjetos': _data.nomeDoisObjetos,
          'comandos': _data.comandos,
        },
        resultado: '${_data.totalScore}/15 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala BIMS salva com sucesso!'),
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

  Widget _buildCheckboxItem(String title, String instruction, int value, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            if (instruction.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(instruction, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
            ],
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Correto (1 ponto)', style: TextStyle(fontSize: 12)),
              value: value == 1,
              onChanged: (val) => onChanged(val == true ? 1 : 0),
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderItem(String title, String instruction, int value, int max, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            if (instruction.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(instruction, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
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
              activeColor: Colors.blue,
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
        title: const Text('BIMS'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'BIMS - Brief Interview for Mental Status\nAvaliação cognitiva breve para pacientes institucionalizados',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildSliderItem(
            '1. Repetição de Palavras',
            'Peça ao paciente para repetir 3 palavras (ex: "maçã, mesa, moeda"). Pontue cada palavra corretamente repetida.',
            _data.repetirPalavras,
            3,
            (v) => setState(() => _data.repetirPalavras = v),
          ),
          _buildCheckboxItem('2. Ano', 'Pergunte: "Que ano é este?"', _data.ano, (v) => setState(() => _data.ano = v)),
          _buildCheckboxItem('3. Mês', 'Pergunte: "Que mês é este?"', _data.mes, (v) => setState(() => _data.mes = v)),
          _buildCheckboxItem('4. Recordação Palavra 1', 'Pergunte: "Lembra-se da primeira palavra?" (sem dar pistas)', _data.recordacao1, (v) => setState(() => _data.recordacao1 = v)),
          _buildCheckboxItem('5. Recordação Palavra 2', 'Pergunte: "Lembra-se da segunda palavra?"', _data.recordacao2, (v) => setState(() => _data.recordacao2 = v)),
          _buildCheckboxItem('6. Recordação Palavra 3', 'Pergunte: "Lembra-se da terceira palavra?"', _data.recordacao3, (v) => setState(() => _data.recordacao3 = v)),
          _buildCheckboxItem('7. Dia da Semana', 'Pergunte: "Que dia da semana é hoje?"', _data.diaSemana, (v) => setState(() => _data.diaSemana = v)),
          _buildCheckboxItem('8. Nomear Dois Objetos', 'Mostre 2 objetos comuns e peça para nomeá-los', _data.nomeDoisObjetos, (v) => setState(() => _data.nomeDoisObjetos = v)),
          _buildSliderItem(
            '9. Comandos',
            'Diga: "Pegue este papel com a mão direita" e "Dobre o papel ao meio". Pontue cada comando executado corretamente.',
            _data.comandos,
            2,
            (v) => setState(() => _data.comandos = v),
          ),
          const SizedBox(height: 16),
          Card(
            color: score >= 13 ? Colors.green : score >= 8 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('BIMS Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
            onPressed: _salvarBIMS,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala BIMS'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

