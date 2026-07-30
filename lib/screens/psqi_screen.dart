import 'package:flutter/material.dart';
import '../models/psqi_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class PSQIScreen extends StatefulWidget {
  const PSQIScreen({super.key});

  @override
  State<PSQIScreen> createState() => _PSQIScreenState();
}

class _PSQIScreenState extends State<PSQIScreen> {
  final PSQIData _data = PSQIData();
  final TextEditingController _tempoAdormecerController = TextEditingController();
  final TextEditingController _horasSonoController = TextEditingController();
  final TextEditingController _horasCamaController = TextEditingController();

  @override
  void dispose() {
    _tempoAdormecerController.dispose();
    _horasSonoController.dispose();
    _horasCamaController.dispose();
    super.dispose();
  }

  Future<void> _salvarPSQI() async {
    try {
      _data.calcularComponentes();
      final score = CompletedScore(
        scoreName: 'Pittsburgh Sleep Quality Index (PSQI)',
        scoreData: {
          'qualidadeSono': _data.qualidadeSono,
          'tempoAdormecer': _data.tempoAdormecer,
          'horasSono': _data.horasSono,
          'horasCama': _data.horasCama,
          'acordarNoite': _data.acordarNoite,
          'irBanheiro': _data.irBanheiro,
          'dificuldadeRespirar': _data.dificuldadeRespirar,
          'tosseRonco': _data.tosseRonco,
          'muitoFrio': _data.muitoFrio,
          'muitoQuente': _data.muitoQuente,
          'dor': _data.dor,
          'outros': _data.outros,
          'medicacaoSono': _data.medicacaoSono,
          'dificuldadeManterVigil': _data.dificuldadeManterVigil,
          'entusiasmo': _data.entusiasmo,
        },
        resultado: '${_data.totalScore}/21 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala PSQI salva com sucesso!'),
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

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged, {String? subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          if (subtitle != null) ...[
             const SizedBox(height: 4),
             Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nunca (0)', style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade300)),
              Text('≥3x/sem (3)', style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade300)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.blueGrey,
              thumbColor: Colors.blueGrey,
              overlayColor: Colors.blueGrey.withOpacity(0.1),
              inactiveTrackColor: Colors.blueGrey.withOpacity(0.1),
              trackHeight: 4,
            ),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 3,
              divisions: 3,
              label: '$value',
              onChanged: (val) => onChanged(val.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericInput(String title, TextEditingController controller, ValueChanged<String> onChanged, {String? hint}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _data.calcularComponentes(); // Recalculate just in case
    final score = _data.totalScore;
    
    return CalculatorScaffold(
      title: 'PSQI',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Pittsburgh Sleep Quality Index\nConsidere seu padrão de sono no último mês.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

          _buildSectionTitle('C1: Qualidade Subjetiva'),
          _buildSliderItem('Como você avaliaria a qualidade do seu sono?', _data.qualidadeSono, (v) => setState(() => _data.qualidadeSono = v), subtitle: '0=Muito boa, 3=Muito ruim'),

          _buildSectionTitle('C2: Latência do Sono'),
          _buildNumericInput('Minutos para adormecer:', _tempoAdormecerController, (v) {
             final min = int.tryParse(v) ?? 0;
             setState(() => _data.tempoAdormecer = min);
          }, hint: 'Ex: 30'),

          _buildSectionTitle('C3: Duração do Sono'),
           _buildNumericInput('Horas de sono por noite:', _horasSonoController, (v) {
             final horas = double.tryParse(v.replaceAll(',', '.')) ?? 0;
             setState(() => _data.horasSono = horas.round());
          }, hint: 'Ex: 7.5'),

          _buildSectionTitle('C4: Eficiência do Sono'),
           _buildNumericInput('Horas na cama:', _horasCamaController, (v) {
             final horas = double.tryParse(v.replaceAll(',', '.')) ?? 0;
             setState(() => _data.horasCama = horas.round());
          }, hint: 'Ex: 8'),

          _buildSectionTitle('C5: Distúrbios do Sono'),
          _buildSliderItem('Acordar no meio da noite / madrugada', _data.acordarNoite, (v) => setState(() => _data.acordarNoite = v)),
          _buildSliderItem('Levantar para ir ao banheiro', _data.irBanheiro, (v) => setState(() => _data.irBanheiro = v)),
          _buildSliderItem('Dificuldade para respirar', _data.dificuldadeRespirar, (v) => setState(() => _data.dificuldadeRespirar = v)),
          _buildSliderItem('Tosse ou ronco alto', _data.tosseRonco, (v) => setState(() => _data.tosseRonco = v)),
          _buildSliderItem('Sentir muito frio', _data.muitoFrio, (v) => setState(() => _data.muitoFrio = v)),
          _buildSliderItem('Sentir muito calor', _data.muitoQuente, (v) => setState(() => _data.muitoQuente = v)),
          _buildSliderItem('Ter dores', _data.dor, (v) => setState(() => _data.dor = v)),
          _buildSliderItem('Outras razões', _data.outros, (v) => setState(() => _data.outros = v)),

          _buildSectionTitle('C6: Medicação'),
          _buildSliderItem('Uso de remédio para dormir', _data.medicacaoSono, (v) => setState(() => _data.medicacaoSono = v)),

          _buildSectionTitle('C7: Disfunção Diurna'),
          _buildSliderItem('Dificuldade em manter-se acordado', _data.dificuldadeManterVigil, (v) => setState(() => _data.dificuldadeManterVigil = v)),
          _buildSliderItem('Dificuldade em ter entusiasmo', _data.entusiasmo, (v) => setState(() => _data.entusiasmo = v)),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 5 ? Colors.green : score <= 10 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 5 ? Colors.green : score <= 10 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('PSQI GLOBAL SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const Text('/ 21', style: TextStyle(color: Colors.white70)),
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
        onPressed: _salvarPSQI,
        backgroundColor: Colors.blueGrey,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
    );
  }
}
