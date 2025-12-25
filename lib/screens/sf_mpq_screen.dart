import 'package:flutter/material.dart';
import '../models/sf_mpq_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

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

  final List<String> _options = ['Nenhuma (0)', 'Leve (1)', 'Moderada (2)', 'Severa (3)'];

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
        resultado: '${_data.totalScore}/45 - ${_data.interpretation} (Sensorial: ${_data.scoreSensorial}/33, Afetivo: ${_data.scoreAfetivo}/12)',
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

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

  Widget _buildItem(int index, Map<String, dynamic> item, int value, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index + 1}. ${item['title']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('0', style: TextStyle(fontSize: 10)),
                Text('$value/3', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Text('3', style: TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 3,
              divisions: 3,
              label: _options[value],
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.deepOrange,
            ),
            const SizedBox(height: 4),
            const Text('0: Nenhuma | 1: Leve | 2: Moderada | 3: Severa', style: TextStyle(fontSize: 9, color: Colors.grey)),
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
        title: const Text('SF-MPQ'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'SF-MPQ - Short-Form McGill Pain Questionnaire\nAvaliação qualitativa e quantitativa da dor',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.deepOrange.shade50,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Descritores Sensoriais (11 itens)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          ...List.generate(_sensorial.length, (i) => _buildItem(i, _sensorial[i], _getValue(_sensorial[i]['field']), (v) => _setValue(_sensorial[i]['field'], v))),
          const SizedBox(height: 8),
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.deepOrange.shade50,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Descritores Afetivos (4 itens)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          ...List.generate(_afetivo.length, (i) => _buildItem(11 + i, _afetivo[i], _getValue(_afetivo[i]['field']), (v) => _setValue(_afetivo[i]['field'], v))),
          const SizedBox(height: 16),
          Card(
            color: score <= 9 ? Colors.green : score <= 18 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('SF-MPQ Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/45', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Sensorial: ${_data.scoreSensorial}/33', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  Text('Afetivo: ${_data.scoreAfetivo}/12', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarSFMPQ,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala SF-MPQ'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

