import 'package:flutter/material.dart';
import '../models/bims_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

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
    return Column(
      children: [
        CheckboxListTile(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: instruction.isNotEmpty ? Text(instruction, style: const TextStyle(fontSize: 11, color: Colors.grey)) : null,
          value: value == 1,
          onChanged: (val) => onChanged(val == true ? 1 : 0),
          activeColor: Colors.blue,
          controlAffinity: ListTileControlAffinity.trailing,
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildSliderItem(String title, String instruction, int value, int max, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          if (instruction.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(instruction, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('0', style: TextStyle(fontSize: 11)),
              Text('$value/$max', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text('$max', style: const TextStyle(fontSize: 11)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.blue, thumbColor: Colors.blue),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: max.toDouble(),
              divisions: max,
              onChanged: (val) => onChanged(val.toInt()),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'BIMS',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Avaliação cognitiva breve para pacientes institucionalizados',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                _buildSliderItem(
                  '1. Repetição de Palavras',
                  'Repetir 3 palavras. Pontue cada correta.',
                  _data.repetirPalavras, 3, (v) => setState(() => _data.repetirPalavras = v),
                ),
                _buildCheckboxItem('2. Ano', 'Que ano é este?', _data.ano, (v) => setState(() => _data.ano = v)),
                _buildCheckboxItem('3. Mês', 'Que mês é este?', _data.mes, (v) => setState(() => _data.mes = v)),
                _buildCheckboxItem('4. Recordação Palavra 1', 'Lembra da 1ª palavra?', _data.recordacao1, (v) => setState(() => _data.recordacao1 = v)),
                _buildCheckboxItem('5. Recordação Palavra 2', 'Lembra da 2ª palavra?', _data.recordacao2, (v) => setState(() => _data.recordacao2 = v)),
                _buildCheckboxItem('6. Recordação Palavra 3', 'Lembra da 3ª palavra?', _data.recordacao3, (v) => setState(() => _data.recordacao3 = v)),
                _buildCheckboxItem('7. Dia da Semana', 'Que dia é hoje?', _data.diaSemana, (v) => setState(() => _data.diaSemana = v)),
                _buildCheckboxItem('8. Nomear Dois Objetos', 'Nomear 2 objetos mostrados', _data.nomeDoisObjetos, (v) => setState(() => _data.nomeDoisObjetos = v)),
                _buildSliderItem(
                  '9. Comandos',
                  'Pegar papel mão direita + Dobrar ao meio.',
                  _data.comandos, 2, (v) => setState(() => _data.comandos = v),
                ),
              ],
            ),
          ),
          
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score >= 13 ? Colors.green : score >= 8 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score >= 13 ? Colors.green : score >= 8 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('BIMS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$score', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 12),
                Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarBIMS,
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
