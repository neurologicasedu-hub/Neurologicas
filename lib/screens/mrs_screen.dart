import 'package:flutter/material.dart';
import '../models/mrs_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class MRSScreen extends StatefulWidget {
  const MRSScreen({super.key});

  @override
  State<MRSScreen> createState() => _MRSScreenState();
}

class _MRSScreenState extends State<MRSScreen> with AutoSaveMixin {
  final MRSData _mrsData = MRSData();

  @override
  String get scaleName => 'mrs';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'hasNoSymptoms': _mrsData.hasNoSymptoms,
      'hasSymptomsNoLimit': _mrsData.hasSymptomsNoLimit,
      'independentButSomeLimit': _mrsData.independentButSomeLimit,
      'needsSomeHelp': _mrsData.needsSomeHelp,
      'needsAssistance': _mrsData.needsAssistance,
      'bedridden': _mrsData.bedridden,
      'deceased': _mrsData.deceased,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _mrsData.hasNoSymptoms = data['hasNoSymptoms'] ?? false;
    _mrsData.hasSymptomsNoLimit = data['hasSymptomsNoLimit'] ?? false;
    _mrsData.independentButSomeLimit = data['independentButSomeLimit'] ?? false;
    _mrsData.needsSomeHelp = data['needsSomeHelp'] ?? false;
    _mrsData.needsAssistance = data['needsAssistance'] ?? false;
    _mrsData.bedridden = data['bedridden'] ?? false;
    _mrsData.deceased = data['deceased'] ?? false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarMRS() async {
    try {
      final score = CompletedScore(
        scoreName: 'Modified Rankin Scale (mRS)',
        scoreData: {
          'hasNoSymptoms': _mrsData.hasNoSymptoms,
          'hasSymptomsNoLimit': _mrsData.hasSymptomsNoLimit,
          'independentButSomeLimit': _mrsData.independentButSomeLimit,
          'needsSomeHelp': _mrsData.needsSomeHelp,
          'needsAssistance': _mrsData.needsAssistance,
          'bedridden': _mrsData.bedridden,
          'deceased': _mrsData.deceased,
        },
        resultado: _mrsData.interpretacao,
        totalScore: _mrsData.score,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala mRS salva com sucesso!'),
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
  Widget build(BuildContext context) {
    final score = _mrsData.score;
    final interpretacao = _mrsData.interpretacao;

    return CalculatorScaffold(
      title: 'Modified Rankin Scale (mRS)',
      body: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.blue[50], 
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue[100]!),
          ),
          child: const Text(
             'Selecione a descrição que melhor descreve o estado atual do paciente:',
             style: TextStyle(
               fontSize: 15,
               fontWeight: FontWeight.w600,
               color: Color(0xFF00509D),
             ),
             textAlign: TextAlign.center,
          ),
        ),
        
        QuestionCard<String>(
          title: "Estado Funcional",
          value: _getSelectedValue(),
          options: const [
            QuestionOption(label: 'Sem sintomas (mRS 0)', value: 'noSymptoms'),
            QuestionOption(label: 'Tem sintomas, mas sem limitações significativas (mRS 1)', value: 'symptomsNoLimit'),
            QuestionOption(label: 'Independente, mas com limitações em atividades prévias (mRS 2)', value: 'independent'),
            QuestionOption(label: 'Precisa de alguma ajuda, mas consegue caminhar sozinho (mRS 3)', value: 'needsHelp'),
            QuestionOption(label: 'Necessita de assistência para a maioria das atividades (mRS 4)', value: 'needsAssistance'),
            QuestionOption(label: 'Dependência grave/acamado (mRS 5)', value: 'bedridden'),
            QuestionOption(label: 'Óbito (mRS 6)', value: 'deceased'),
          ],
          onChanged: (val) {
            setState(() {
              _resetOthers(val);
            });
            onDataChanged();
          },
        ),

        // Result Card
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _getScoreColor(score),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _getScoreColor(score).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Pontuação mRS',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                '$score',
                style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
              ),
              const SizedBox(height: 12),
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                 decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.2),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Text(
                  interpretacao,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarMRS,
        backgroundColor: _getScoreColor(score),
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  String _getSelectedValue() {
    if (_mrsData.hasNoSymptoms) return 'noSymptoms';
    if (_mrsData.hasSymptomsNoLimit) return 'symptomsNoLimit';
    if (_mrsData.independentButSomeLimit) return 'independent';
    if (_mrsData.needsSomeHelp) return 'needsHelp';
    if (_mrsData.needsAssistance) return 'needsAssistance';
    if (_mrsData.bedridden) return 'bedridden';
    if (_mrsData.deceased) return 'deceased';
    return '';
  }

  void _resetOthers(String selected) {
    _mrsData.hasNoSymptoms = false;
    _mrsData.hasSymptomsNoLimit = false;
    _mrsData.independentButSomeLimit = false;
    _mrsData.needsSomeHelp = false;
    _mrsData.needsAssistance = false;
    _mrsData.bedridden = false;
    _mrsData.deceased = false;

    switch (selected) {
      case 'noSymptoms':
        _mrsData.hasNoSymptoms = true;
        break;
      case 'symptomsNoLimit':
        _mrsData.hasSymptomsNoLimit = true;
        break;
      case 'independent':
        _mrsData.independentButSomeLimit = true;
        break;
      case 'needsHelp':
        _mrsData.needsSomeHelp = true;
        break;
      case 'needsAssistance':
        _mrsData.needsAssistance = true;
        break;
      case 'bedridden':
        _mrsData.bedridden = true;
        break;
      case 'deceased':
        _mrsData.deceased = true;
        break;
    }
  }

  Color _getScoreColor(int score) {
    if (score == 0 || score == 1) return Colors.green;
    if (score == 2) return Colors.lightGreen;
    if (score == 3) return Colors.orange;
    if (score == 4) return Colors.deepOrange;
    if (score == 5) return Colors.red;
    return Colors.black; // deceased
  }
}
