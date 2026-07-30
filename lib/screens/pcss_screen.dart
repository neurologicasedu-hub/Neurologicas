import 'package:flutter/material.dart';
import '../models/pcss_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class PCSSScreen extends StatefulWidget {
  const PCSSScreen({super.key});

  @override
  State<PCSSScreen> createState() => _PCSSScreenState();
}

class _PCSSScreenState extends State<PCSSScreen> {
  final PCSSData _data = PCSSData();

  final List<Map<String, dynamic>> _sintomas = [
    {'nome': 'Cefaleia', 'campo': 'cefaleia'},
    {'nome': 'Náusea', 'campo': 'nausea'},
    {'nome': 'Vômito', 'campo': 'vomito'},
    {'nome': 'Problemas de Equilíbrio', 'campo': 'problemasEquilibrio'},
    {'nome': 'Tontura', 'campo': 'tontura'},
    {'nome': 'Fadiga', 'campo': 'fadiga'},
    {'nome': 'Dificuldade para Adormecer', 'campo': 'dificuldadeAdormecer'},
    {'nome': 'Dormir Mais que o Usual', 'campo': 'dormirMaisQueOUsual'},
    {'nome': 'Dormir Menos que o Usual', 'campo': 'dormirMenosQueOUsual'},
    {'nome': 'Sonolência', 'campo': 'sonolencia'},
    {'nome': 'Sensibilidade à Luz', 'campo': 'sensibilidadeLuz'},
    {'nome': 'Sensibilidade ao Som', 'campo': 'sensibilidadeSom'},
    {'nome': 'Irritabilidade', 'campo': 'irritabilidade'},
    {'nome': 'Tristeza', 'campo': 'tristeza'},
    {'nome': 'Nervosismo', 'campo': 'nervosismo'},
    {'nome': 'Sentimento Emocional', 'campo': 'sentimentoEmocional'},
    {'nome': 'Sentimento Entorpecido', 'campo': 'sentimentoEntorpecido'},
    {'nome': 'Sentimento Lento', 'campo': 'sentimentoLento'},
    {'nome': 'Concentração', 'campo': 'dificuldadeConcentrar'},
    {'nome': 'Memória', 'campo': 'dificuldadeLembrar'},
    {'nome': 'Visão Turva', 'campo': 'visaoTurva'},
    {'nome': 'Confusão', 'campo': 'confusao'},
  ];

  int _getValue(String campo) {
    switch (campo) {
      case 'cefaleia': return _data.cefaleia;
      case 'nausea': return _data.nausea;
      case 'vomito': return _data.vomito;
      case 'problemasEquilibrio': return _data.problemasEquilibrio;
      case 'tontura': return _data.tontura;
      case 'fadiga': return _data.fadiga;
      case 'dificuldadeAdormecer': return _data.dificuldadeAdormecer;
      case 'dormirMaisQueOUsual': return _data.dormirMaisQueOUsual;
      case 'dormirMenosQueOUsual': return _data.dormirMenosQueOUsual;
      case 'sonolencia': return _data.sonolencia;
      case 'sensibilidadeLuz': return _data.sensibilidadeLuz;
      case 'sensibilidadeSom': return _data.sensibilidadeSom;
      case 'irritabilidade': return _data.irritabilidade;
      case 'tristeza': return _data.tristeza;
      case 'nervosismo': return _data.nervosismo;
      case 'sentimentoEmocional': return _data.sentimentoEmocional;
      case 'sentimentoEntorpecido': return _data.sentimentoEntorpecido;
      case 'sentimentoLento': return _data.sentimentoLento;
      case 'dificuldadeConcentrar': return _data.dificuldadeConcentrar;
      case 'dificuldadeLembrar': return _data.dificuldadeLembrar;
      case 'visaoTurva': return _data.visaoTurva;
      case 'confusao': return _data.confusao;
      default: return 0;
    }
  }

  void _setValue(String campo, int value) {
    setState(() {
      switch (campo) {
        case 'cefaleia': _data.cefaleia = value; break;
        case 'nausea': _data.nausea = value; break;
        case 'vomito': _data.vomito = value; break;
        case 'problemasEquilibrio': _data.problemasEquilibrio = value; break;
        case 'tontura': _data.tontura = value; break;
        case 'fadiga': _data.fadiga = value; break;
        case 'dificuldadeAdormecer': _data.dificuldadeAdormecer = value; break;
        case 'dormirMaisQueOUsual': _data.dormirMaisQueOUsual = value; break;
        case 'dormirMenosQueOUsual': _data.dormirMenosQueOUsual = value; break;
        case 'sonolencia': _data.sonolencia = value; break;
        case 'sensibilidadeLuz': _data.sensibilidadeLuz = value; break;
        case 'sensibilidadeSom': _data.sensibilidadeSom = value; break;
        case 'irritabilidade': _data.irritabilidade = value; break;
        case 'tristeza': _data.tristeza = value; break;
        case 'nervosismo': _data.nervosismo = value; break;
        case 'sentimentoEmocional': _data.sentimentoEmocional = value; break;
        case 'sentimentoEntorpecido': _data.sentimentoEntorpecido = value; break;
        case 'sentimentoLento': _data.sentimentoLento = value; break;
        case 'dificuldadeConcentrar': _data.dificuldadeConcentrar = value; break;
        case 'dificuldadeLembrar': _data.dificuldadeLembrar = value; break;
        case 'visaoTurva': _data.visaoTurva = value; break;
        case 'confusao': _data.confusao = value; break;
      }
    });
  }

  Future<void> _salvarPCSS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Post-Concussion Symptom Scale (PCSS)',
        scoreData: {
          'cefaleia': _data.cefaleia,
          'nausea': _data.nausea,
          'vomito': _data.vomito,
          'problemasEquilibrio': _data.problemasEquilibrio,
          'tontura': _data.tontura,
          'fadiga': _data.fadiga,
          'dificuldadeAdormecer': _data.dificuldadeAdormecer,
          'dormirMaisQueOUsual': _data.dormirMaisQueOUsual,
          'dormirMenosQueOUsual': _data.dormirMenosQueOUsual,
          'sonolencia': _data.sonolencia,
          'sensibilidadeLuz': _data.sensibilidadeLuz,
          'sensibilidadeSom': _data.sensibilidadeSom,
          'irritabilidade': _data.irritabilidade,
          'tristeza': _data.tristeza,
          'nervosismo': _data.nervosismo,
          'sentimentoEmocional': _data.sentimentoEmocional,
          'sentimentoEntorpecido': _data.sentimentoEntorpecido,
          'sentimentoLento': _data.sentimentoLento,
          'dificuldadeConcentrar': _data.dificuldadeConcentrar,
          'dificuldadeLembrar': _data.dificuldadeLembrar,
          'visaoTurva': _data.visaoTurva,
          'confusao': _data.confusao,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala PCSS salva com sucesso!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ver Relatório',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/report');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSliderItem(String title, String campo, int value) {
     final color = value == 0 ? Colors.green : value <= 2 ? Colors.lightGreen : value <= 4 ? Colors.orange : Colors.red;
     return Padding(
       padding: const EdgeInsets.only(bottom: 12),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 14)),
                Text('$value/6', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(activeTrackColor: color, thumbColor: color),
              child: Slider(
                value: value.toDouble(),
                min: 0, max: 6, divisions: 6,
                onChanged: (val) => _setValue(campo, val.toInt()),
              ),
            ),
         ],
       ),
     );
  }

  Color _getScoreColor(int score) {
    if (score == 0) return Colors.green;
    if (score <= 20) return Colors.lightGreen;
    if (score <= 40) return Colors.orange;
    if (score <= 80) return Colors.deepOrange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'PCSS - Post-Concussion',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Escala de Sintomas Pós-Concussão (0-6 por sintoma)',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _sintomas.map((s) => _buildSliderItem(s['nome'] as String, s['campo'] as String, _getValue(s['campo'] as String))).toList(),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(score),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(score).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('TOTAL SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$score', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 12),
                Text(_data.interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarPCSS,
        backgroundColor: Colors.tealAccent.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
