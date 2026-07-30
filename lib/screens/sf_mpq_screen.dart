import 'package:flutter/material.dart';
import '../models/sf_mpq_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class SFMPQScreen extends StatefulWidget {
  const SFMPQScreen({super.key});

  @override
  State<SFMPQScreen> createState() => _SFMPQScreenState();
}

class _SFMPQScreenState extends State<SFMPQScreen> {
  final SFMPQData _data = SFMPQData();

  final List<Map<String, dynamic>> _sensorial = [
    {'title': 'Latejante', 'field': 'latejante'},
    {'title': 'Lancinante', 'field': 'lancinante'},
    {'title': 'Pontada', 'field': 'pontada'},
    {'title': 'Aguda', 'field': 'aguda'},
    {'title': 'Cãibra', 'field': 'caimbra'},
    {'title': 'Queimação', 'field': 'queimacao'},
    {'title': 'Dor Crua', 'field': 'dorCrua'},
    {'title': 'Doloroso', 'field': 'doloroso'},
    {'title': 'Pesado', 'field': 'pesado'},
    {'title': 'Ternura', 'field': 'ternura'},
    {'title': 'Dividindo', 'field': 'dividindo'},
  ];

  final List<Map<String, dynamic>> _afetivo = [
    {'title': 'Cansativo', 'field': 'cansativo'},
    {'title': 'Doente', 'field': 'doente'},
    {'title': 'Medo', 'field': 'medo'},
    {'title': 'Castigador', 'field': 'castigador'},
  ];

  final List<String> _options = ['Nenhuma', 'Leve', 'Moderada', 'Severa'];

  Future<void> _salvarSFMPQ() async {
    try {
      final score = CompletedScore(
        scoreName: 'Short-Form McGill Pain Questionnaire (SF-MPQ)',
        scoreData: {
          'latejante': _data.latejante,
          'lancinante': _data.lancinante,
          'pontada': _data.pontada,
          'aguda': _data.aguda,
          'caimbra': _data.caimbra,
          'queimacao': _data.queimacao,
          'dorCrua': _data.dorCrua,
          'doloroso': _data.doloroso,
          'pesado': _data.pesado,
          'ternura': _data.ternura,
          'dividindo': _data.dividindo,
          'cansativo': _data.cansativo,
          'doente': _data.doente,
          'medo': _data.medo,
          'castigador': _data.castigador,
        },
        resultado: '${_data.totalScore}/45 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala SF-MPQ salva com sucesso!'),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
      }
    }
  }

  // --- Helpers ---
  int _getValue(String field) {
    switch (field) {
      case 'latejante': return _data.latejante;
      case 'lancinante': return _data.lancinante;
      case 'pontada': return _data.pontada;
      case 'aguda': return _data.aguda;
      case 'caimbra': return _data.caimbra;
      case 'queimacao': return _data.queimacao;
      case 'dorCrua': return _data.dorCrua;
      case 'doloroso': return _data.doloroso;
      case 'pesado': return _data.pesado;
      case 'ternura': return _data.ternura;
      case 'dividindo': return _data.dividindo;
      case 'cansativo': return _data.cansativo;
      case 'doente': return _data.doente;
      case 'medo': return _data.medo;
      case 'castigador': return _data.castigador;
      default: return 0;
    }
  }

  void _setValue(String field, int value) {
    switch (field) {
      case 'latejante': setState(() => _data.latejante = value); break;
      case 'lancinante': setState(() => _data.lancinante = value); break;
      case 'pontada': setState(() => _data.pontada = value); break;
      case 'aguda': setState(() => _data.aguda = value); break;
      case 'caimbra': setState(() => _data.caimbra = value); break;
      case 'queimacao': setState(() => _data.queimacao = value); break;
      case 'dorCrua': setState(() => _data.dorCrua = value); break;
      case 'doloroso': setState(() => _data.doloroso = value); break;
      case 'pesado': setState(() => _data.pesado = value); break;
      case 'ternura': setState(() => _data.ternura = value); break;
      case 'dividindo': setState(() => _data.dividindo = value); break;
      case 'cansativo': setState(() => _data.cansativo = value); break;
      case 'doente': setState(() => _data.doente = value); break;
      case 'medo': setState(() => _data.medo = value); break;
      case 'castigador': setState(() => _data.castigador = value); break;
    }
  }

  Widget _buildItem(String title, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 14)),
                Text(_options[value], style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.deepOrange.shade900)),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.deepOrange, thumbColor: Colors.deepOrange),
              child: Slider(
                value: value.toDouble(),
                min: 0, max: 3, divisions: 3,
                onChanged: (val) => onChanged(val.toInt()),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'SF-MPQ',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Short-Form McGill Pain Questionnaire',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Sensorial', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange.shade800)),
                   const Divider(),
                   ..._sensorial.map((s) => _buildItem(s['title'], _getValue(s['field']), (v) => _setValue(s['field'], v))),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Afetivo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange.shade800)),
                   const Divider(),
                   ..._afetivo.map((s) => _buildItem(s['title'], _getValue(s['field']), (v) => _setValue(s['field'], v))),
                ],
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 15 ? Colors.green : score <= 30 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 15 ? Colors.green : score <= 30 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('SF-MPQ SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$score', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 8),
                Text('Sensorial: ${_data.scoreSensorial}  Afetivo: ${_data.scoreAfetivo}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 12),
                Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarSFMPQ,
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
