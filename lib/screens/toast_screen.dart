import 'package:flutter/material.dart';
import '../models/toast_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class ToastScreen extends StatefulWidget {
  const ToastScreen({super.key});

  @override
  State<ToastScreen> createState() => _ToastScreenState();
}

class _ToastScreenState extends State<ToastScreen> with AutoSaveMixin {
  final ToastData _toastData = ToastData();
  final TextEditingController _lesionController = TextEditingController();

  @override
  String get scaleName => 'toast';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'hasMajorCardioembolicSource': _toastData.hasMajorCardioembolicSource,
      'ipsilateralCarotidStenosis50': _toastData.ipsilateralCarotidStenosis50,
      'lacunarSyndromeClinically': _toastData.lacunarSyndromeClinically,
      'lesionDiameterMm': _toastData.lesionDiameterMm,
      'otherDeterminedCause': _toastData.otherDeterminedCause,
      'multiplePotentialCauses': _toastData.multiplePotentialCauses,
      'lesionText': _lesionController.text,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _toastData.hasMajorCardioembolicSource = data['hasMajorCardioembolicSource'] ?? false;
    _toastData.ipsilateralCarotidStenosis50 = data['ipsilateralCarotidStenosis50'] ?? false;
    _toastData.lacunarSyndromeClinically = data['lacunarSyndromeClinically'] ?? false;
    _toastData.lesionDiameterMm = data['lesionDiameterMm']?.toDouble() ?? 0.0;
    _toastData.otherDeterminedCause = data['otherDeterminedCause'] ?? false;
    _toastData.multiplePotentialCauses = data['multiplePotentialCauses'] ?? false;
    if (data.containsKey('lesionText')) {
      _lesionController.text = data['lesionText'] ?? '';
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarTOAST() async {
    try {
      final score = CompletedScore(
        scoreName: 'TOAST Classification',
        scoreData: {
          'hasMajorCardioembolicSource': _toastData.hasMajorCardioembolicSource,
          'ipsilateralCarotidStenosis50': _toastData.ipsilateralCarotidStenosis50,
          'lacunarSyndromeClinically': _toastData.lacunarSyndromeClinically,
          'lesionDiameterMm': _toastData.lesionDiameterMm,
          'otherDeterminedCause': _toastData.otherDeterminedCause,
          'multiplePotentialCauses': _toastData.multiplePotentialCauses,
        },
        resultado: '${_toastData.classificacao} - ${_toastData.razao}',
        totalScore: null,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala TOAST salva com sucesso!'),
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
    final classificacao = _toastData.classificacao;
    final razao = _toastData.razao;

    return CalculatorScaffold(
      title: 'Classificação TOAST',
      body: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.orange[50], 
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange[100]!),
          ),
          child: const Text(
            'Marque achados clínicos e de imagem para determinar a etiologia:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.deepOrange,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        QuestionCard<bool>(
          title: "Achados Cardioembólicos",
          value: _toastData.hasMajorCardioembolicSource,
          options: const [QuestionOption(label: 'Fonte cardioembólica maior (ex: FA, trombo LV, prótese)', value: true)],
          onChanged: (val) {
            setState(() {
              _toastData.hasMajorCardioembolicSource = ! _toastData.hasMajorCardioembolicSource; // Toggle behavior
               if (_toastData.hasMajorCardioembolicSource) {
                  _toastData.ipsilateralCarotidStenosis50 = false;
                  _toastData.lacunarSyndromeClinically = false;
                  _toastData.otherDeterminedCause = false;
                  _toastData.multiplePotentialCauses = false;
                }
            });
            onDataChanged();
          },
        ),

        QuestionCard<bool>(
          title: "Aterosclerose de Grandes Vasos",
          value: _toastData.ipsilateralCarotidStenosis50,
          options: const [QuestionOption(label: 'Estenose carotídea ipsilateral >= 50%', value: true)],
          onChanged: (val) {
             setState(() {
              _toastData.ipsilateralCarotidStenosis50 = !_toastData.ipsilateralCarotidStenosis50;
               if (_toastData.ipsilateralCarotidStenosis50) {
                  _toastData.hasMajorCardioembolicSource = false;
                  _toastData.lacunarSyndromeClinically = false;
                }
            });
            onDataChanged();
          },
        ),

         QuestionCard<bool>(
          title: "Oclusão de Pequenos Vasos",
          value: _toastData.lacunarSyndromeClinically,
          content: TextField(
                controller: _lesionController,
                decoration: InputDecoration(
                  labelText: 'Diâmetro da lesão (mm)',
                  hintText: 'Deixe 0 se desconhecido',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) {
                  setState(() {
                    _toastData.lesionDiameterMm = double.tryParse(v) ?? 0;
                  });
                  onDataChanged();
                },
              ),
          options: const [QuestionOption(label: 'Síndrome lacunar clínica (ex: paresia motora pura)', value: true)],
           onChanged: (val) {
             setState(() {
              _toastData.lacunarSyndromeClinically = !_toastData.lacunarSyndromeClinically;
              if (_toastData.lacunarSyndromeClinically) {
                  _toastData.hasMajorCardioembolicSource = false;
                  _toastData.ipsilateralCarotidStenosis50 = false;
                }
            });
            onDataChanged();
          },
        ),

        QuestionCard<bool>(
          title: "Outras Etiologias",
          value: _toastData.otherDeterminedCause,
          options: const [QuestionOption(label: 'Outra causa determinada (dissecção, vasculite, trombofilia)', value: true)],
          onChanged: (val) {
             setState(() {
              _toastData.otherDeterminedCause = !_toastData.otherDeterminedCause;
              if (_toastData.otherDeterminedCause) {
                  _toastData.hasMajorCardioembolicSource = false;
                  _toastData.ipsilateralCarotidStenosis50 = false;
                  _toastData.lacunarSyndromeClinically = false;
                }
            });
            onDataChanged();
          },
        ),

        QuestionCard<bool>(
          title: "Indeterminado",
          value: _toastData.multiplePotentialCauses,
          options: const [QuestionOption(label: 'Achados múltiplos ou conflitantes', value: true)],
          onChanged: (val) {
             setState(() {
              _toastData.multiplePotentialCauses = !_toastData.multiplePotentialCauses;
              if (_toastData.multiplePotentialCauses) {
                  _toastData.hasMajorCardioembolicSource = false;
                  _toastData.ipsilateralCarotidStenosis50 = false;
                  _toastData.lacunarSyndromeClinically = false;
                  _toastData.otherDeterminedCause = false;
                }
            });
            onDataChanged();
          },
        ),
        
        // Result Card
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.orange.shade600,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.shade300,
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Classificação TOAST',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                classificacao,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
                textAlign: TextAlign.center,
              ),
               const SizedBox(height: 12),
               Container(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                 decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.2),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Text(
                  razao,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarTOAST,
        backgroundColor: Colors.orange.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  void dispose() {
    _lesionController.dispose();
    super.dispose();
  }
}
