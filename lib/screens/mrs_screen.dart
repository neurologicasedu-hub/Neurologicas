import 'package:flutter/material.dart';
import '../models/mrs_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modified Rankin Scale (mRS)'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Selecione a descrição que melhor descreve o estado atual do paciente:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildCheckboxItem(
            'Sem sintomas',
            _mrsData.hasNoSymptoms,
            (val) {
              setState(() {
                _mrsData.hasNoSymptoms = val;
                _resetOthers('noSymptoms');
              });
              onDataChanged();
            },
          ),
          _buildCheckboxItem(
            'Tem sintomas, mas sem limitações significativas (mRS 1)',
            _mrsData.hasSymptomsNoLimit,
            (val) {
              setState(() {
                _mrsData.hasSymptomsNoLimit = val;
                _resetOthers('symptomsNoLimit');
              });
              onDataChanged();
            },
          ),
          _buildCheckboxItem(
            'Independente, mas com limitações em atividades prévias (mRS 2)',
            _mrsData.independentButSomeLimit,
            (val) {
              setState(() {
                _mrsData.independentButSomeLimit = val;
                _resetOthers('independent');
              });
              onDataChanged();
            },
          ),
          _buildCheckboxItem(
            'Precisa de alguma ajuda, mas consegue caminhar sozinho (mRS 3)',
            _mrsData.needsSomeHelp,
            (val) {
              setState(() {
                _mrsData.needsSomeHelp = val;
                _resetOthers('needsHelp');
              });
              onDataChanged();
            },
          ),
          _buildCheckboxItem(
            'Necessita de assistência para a maioria das atividades (mRS 4)',
            _mrsData.needsAssistance,
            (val) {
              setState(() {
                _mrsData.needsAssistance = val;
                _resetOthers('needsAssistance');
              });
              onDataChanged();
            },
          ),
          _buildCheckboxItem(
            'Dependência grave/acamado (mRS 5)',
            _mrsData.bedridden,
            (val) {
              setState(() {
                _mrsData.bedridden = val;
                _resetOthers('bedridden');
              });
              onDataChanged();
            },
          ),
          _buildCheckboxItem(
            'Óbito (mRS 6)',
            _mrsData.deceased,
            (val) {
              setState(() {
                _mrsData.deceased = val;
                _resetOthers('deceased');
              });
              onDataChanged();
            },
          ),
          
          const SizedBox(height: 16),
          
          // Resultado
          Card(
            color: _getScoreColor(score),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Pontuação mRS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$score',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    interpretacao,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Observação: mRS é uma escala clínica global. Este formulário é um assistente. A classificação final deve ser feita por um clínico experiente.',
              style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Botões
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarMRS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala mRS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Início'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

  Widget _buildCheckboxItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: RadioListTile<bool>(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        value: true,
        groupValue: value ? true : null,
        onChanged: (val) => onChanged(val ?? false),
        activeColor: Colors.deepPurple,
        dense: true,
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score == 0 || score == 1) return Colors.green;
    if (score == 2) return Colors.lightGreen;
    if (score == 3) return Colors.orange;
    if (score == 4) return Colors.deepOrange;
    if (score == 5) return Colors.red;
    return Colors.black;
  }
}
