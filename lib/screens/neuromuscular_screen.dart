import 'package:flutter/material.dart';
import '../models/neuromuscular_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class NeuromuscularScreen extends StatefulWidget {
  const NeuromuscularScreen({super.key});
  @override
  State<NeuromuscularScreen> createState() => _NeuromuscularScreenState();
}

class _NeuromuscularScreenState extends State<NeuromuscularScreen> {
  final NeuromuscularData _data = NeuromuscularData();

  Future<void> _salvarNeuromuscular() async {
    try {
      final score = CompletedScore(
        scoreName: 'Doenças Neuromusculares / Crise Aguda',
        scoreData: {
          'forcaMuscular': _data.forcaMuscular,
          'reflexos': _data.reflexos,
          'sensibilidade': _data.sensibilidade,
          'insuficienciaRespiratoria': _data.insuficienciaRespiratoria,
          'disfagia': _data.disfagia,
          'ptosePalpebral': _data.ptosePalpebral,
          'diplopia': _data.diplopia,
          'disartria': _data.disartria,
          'fraquezaBulbar': _data.fraquezaBulbar,
        },
        resultado: '${_data.interpretacao} - ${_data.conduta}',
        totalScore: _data.severidade,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Neuromuscular salva com sucesso!'),
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
    final severidade = _data.severidade;
    return CalculatorScaffold(
      title: 'Doenças Neuromusculares',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Avaliação de Crise Neuromuscular Aguda',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildSection('Avaliação Motora e Sensitiva', [
             _buildSliderItem('Força Muscular', _data.forcaMuscular, 5, (val) => setState(() => _data.forcaMuscular = val)),
             _buildSliderItem('Reflexos', _data.reflexos, 2, (val) => setState(() => _data.reflexos = val)),
             _buildSliderItem('Sensibilidade', _data.sensibilidade, 2, (val) => setState(() => _data.sensibilidade = val)),
          ]),

          _buildSection('Sinais de Gravidade', [
            _buildCheckboxItem('Insuficiência Respiratória', _data.insuficienciaRespiratoria, (val) => setState(() => _data.insuficienciaRespiratoria = val)),
            _buildCheckboxItem('Disfagia (Dificuldade de Engolir)', _data.disfagia, (val) => setState(() => _data.disfagia = val)),
            _buildCheckboxItem('Disartria (Dificuldade na Fala)', _data.disartria, (val) => setState(() => _data.disartria = val)),
            _buildCheckboxItem('Fraqueza Bulbar', _data.fraquezaBulbar, (val) => setState(() => _data.fraquezaBulbar = val)),
          ]),

          _buildSection('Sinais Oculares', [
             _buildCheckboxItem('Ptose Palpebral', _data.ptosePalpebral, (val) => setState(() => _data.ptosePalpebral = val)),
             _buildCheckboxItem('Diplopia (Visão Dupla)', _data.diplopia, (val) => setState(() => _data.diplopia = val)),
          ]),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getSeveridadeColor(severidade),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getSeveridadeColor(severidade).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('SEVERIDADE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$severidade', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 12),
                Text(_data.interpretacao, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text(_data.conduta, style: const TextStyle(fontSize: 14, color: Colors.white70), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarNeuromuscular,
        backgroundColor: Colors.red.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
  
  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red.shade900)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSliderItem(String title, int value, int max, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(title, style: const TextStyle(fontSize: 14)),
             Text('$value/$max', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red.shade900)),
           ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.red.shade700, thumbColor: Colors.red.shade700),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: max.toDouble(),
            divisions: max > 0 ? max : 1,
            onChanged: (val) => onChanged(val.toInt()),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxItem(String title, bool value, ValueChanged<bool> onChanged) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: (val) => onChanged(val ?? false),
      activeColor: Colors.red.shade700,
      contentPadding: EdgeInsets.zero,
    );
  }

  Color _getSeveridadeColor(int severidade) {
    if (severidade <= 5) return Colors.green;
    if (severidade <= 10) return Colors.orange;
    return Colors.red;
  }
}
