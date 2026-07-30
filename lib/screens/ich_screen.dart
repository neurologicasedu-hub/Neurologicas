import 'package:flutter/material.dart';
import '../models/ich_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class ICHScreen extends StatefulWidget {
  const ICHScreen({super.key});

  @override
  State<ICHScreen> createState() => _ICHScreenState();
}

class _ICHScreenState extends State<ICHScreen> with AutoSaveMixin {
  final ICHData _data = ICHData();
  final TextEditingController _volumeController = TextEditingController();

  @override
  String get scaleName => 'ich';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'idade': _data.idade,
      'volumeICH': _data.volumeICH,
      'localizacaoICH': _data.localizacaoICH,
      'nivelConsciencia': _data.nivelConsciencia,
      'origemICH': _data.origemICH,
      'volumeText': _volumeController.text,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.idade = data['idade'] ?? 0;
    _data.volumeICH = data['volumeICH'] ?? 0;
    _data.localizacaoICH = data['localizacaoICH'] ?? 0;
    _data.nivelConsciencia = data['nivelConsciencia'] ?? 0;
    _data.origemICH = data['origemICH'] ?? 0;
    if (data.containsKey('volumeText')) {
      _volumeController.text = data['volumeText'] ?? '';
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarICH() async {
    try {
      final score = CompletedScore(
        scoreName: 'ICH Score',
        scoreData: {
          'idade': _data.idade,
          'volumeICH': _data.volumeICH,
          'localizacaoICH': _data.localizacaoICH,
          'nivelConsciencia': _data.nivelConsciencia,
          'origemICH': _data.origemICH,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ICH salva com sucesso!'),
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

  @override
  void dispose() {
    _volumeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    final interpretacao = _data.interpretacao;

    return CalculatorScaffold(
      title: 'ICH Score',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Intracerebral Hemorrhage Score.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          QuestionCard<int>(
            title: 'Idade',
            value: _data.idade,
            onChanged: (val) {
              setState(() => _data.idade = val);
              onDataChanged();
            },
            options: const [
              QuestionOption(label: '< 80 anos', value: 0),
              QuestionOption(label: '≥ 80 anos', value: 1),
            ],
          ),

           Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Volume do Hematoma (ABC/2)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
                const SizedBox(height: 12),
                TextField(
                  controller: _volumeController,
                   keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Volume (ml)',
                    hintText: 'Ex: 25',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (val) {
                    final volume = double.tryParse(val) ?? 0;
                    if (volume < 30) {
                      setState(() => _data.volumeICH = 0);
                    } else if (volume <= 60) {
                      setState(() => _data.volumeICH = 1);
                    } else {
                      setState(() => _data.volumeICH = 2);
                    }
                    onDataChanged();
                  },
                ),
                 const SizedBox(height: 8),
                 Text('Pontos: ${_data.volumeICH}', style: const TextStyle(fontSize: 14, color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),


          QuestionCard<int>(
            title: 'Localização',
            value: _data.localizacaoICH,
            onChanged: (val) {
              setState(() => _data.localizacaoICH = val);
              onDataChanged();
            },
            options: const [
              QuestionOption(label: 'Supratentorial (Lobar/Profunda)', value: 0),
              QuestionOption(label: 'Infratentorial', value: 1),
            ],
          ),

          QuestionCard<int>(
            title: 'Nível de Consciência (GCS)',
            value: _data.nivelConsciencia,
            onChanged: (val) {
              setState(() => _data.nivelConsciencia = val);
              onDataChanged();
            },
            options: const [
              QuestionOption(label: '13 - 15', value: 0),
              QuestionOption(label: '5 - 12', value: 1),
              QuestionOption(label: '3 - 4', value: 2),
            ],
          ),

          QuestionCard<int>(
            title: 'Origem/Hemorragia',
            value: _data.origemICH,
            onChanged: (val) {
              setState(() => _data.origemICH = val);
              onDataChanged();
            },
            options: const [
              QuestionOption(label: 'Não traumática / Hipertensiva', value: 0),
              QuestionOption(label: 'Traumática / Outras causas', value: 1),
            ],
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
                const Text('ICH SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const SizedBox(height: 12),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                   child: Text(
                    interpretacao,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarICH,
        backgroundColor: Colors.deepPurpleAccent,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 2) return Colors.green;
    if (score == 3) return Colors.orange;
    return Colors.red;
  }
}
