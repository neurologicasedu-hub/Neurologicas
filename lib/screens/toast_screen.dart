import 'package:flutter/material.dart';
import '../models/toast_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

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
        totalScore: null, // TOAST não tem score numérico
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classificação TOAST'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Marque achados clínicos e de imagem para chegar à classificação TOAST:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildSwitchItem(
            'Fonte cardioembólica maior (ex: FA, trombo LV, prótese)',
            _toastData.hasMajorCardioembolicSource,
            (val) {
              setState(() {
                _toastData.hasMajorCardioembolicSource = val;
                if (val) {
                  _toastData.ipsilateralCarotidStenosis50 = false;
                  _toastData.lacunarSyndromeClinically = false;
                  _toastData.otherDeterminedCause = false;
                  _toastData.multiplePotentialCauses = false;
                }
              });
              onDataChanged();
            },
          ),
          _buildSwitchItem(
            'Estenose carotídea ipsilateral >= 50%',
            _toastData.ipsilateralCarotidStenosis50,
            (val) {
              setState(() {
                _toastData.ipsilateralCarotidStenosis50 = val;
                if (val) {
                  _toastData.hasMajorCardioembolicSource = false;
                  _toastData.lacunarSyndromeClinically = false;
                }
              });
              onDataChanged();
            },
          ),
          _buildSwitchItem(
            'Síndrome lacunar clinicamente (ex: paresia motora pura)',
            _toastData.lacunarSyndromeClinically,
            (val) {
              setState(() {
                _toastData.lacunarSyndromeClinically = val;
                if (val) {
                  _toastData.hasMajorCardioembolicSource = false;
                  _toastData.ipsilateralCarotidStenosis50 = false;
                }
              });
              onDataChanged();
            },
          ),
          
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _lesionController,
                decoration: const InputDecoration(
                  labelText: 'Diâmetro da lesão (mm)',
                  hintText: 'Deixe 0 se desconhecido',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) {
                  setState(() {
                    _toastData.lesionDiameterMm = double.tryParse(v) ?? 0;
                  });
                  onDataChanged();
                },
              ),
            ),
          ),
          
          _buildSwitchItem(
            'Outra causa determinada (dissecção, vasculite, trombofilia)',
            _toastData.otherDeterminedCause,
            (val) {
              setState(() {
                _toastData.otherDeterminedCause = val;
                if (val) {
                  _toastData.hasMajorCardioembolicSource = false;
                  _toastData.ipsilateralCarotidStenosis50 = false;
                  _toastData.lacunarSyndromeClinically = false;
                }
              });
              onDataChanged();
            },
          ),
          _buildSwitchItem(
            'Achados múltiplos/confundidores (indeterminado por múltiplas causas)',
            _toastData.multiplePotentialCauses,
            (val) {
              setState(() {
                _toastData.multiplePotentialCauses = val;
                if (val) {
                  _toastData.hasMajorCardioembolicSource = false;
                  _toastData.ipsilateralCarotidStenosis50 = false;
                  _toastData.lacunarSyndromeClinically = false;
                  _toastData.otherDeterminedCause = false;
                }
              });
              onDataChanged();
            },
          ),
          
          const SizedBox(height: 16),
          
          // Resultado
          Card(
            color: Colors.orange.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_hospital, size: 28, color: Colors.orange.shade700),
                      const SizedBox(width: 10),
                      const Text(
                        'Classificação TOAST',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    classificacao,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    razao,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
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
              'Observação: TOAST requer interpretação clínica e exames complementares (ECG, ECHO, USG/angiografia). Esta ferramenta automatiza a lógica básica, mas não substitui avaliação médica.',
              style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Botões
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarTOAST();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala TOAST'),
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

  Widget _buildSwitchItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.orange,
        dense: true,
      ),
    );
  }

  @override
  void dispose() {
    _lesionController.dispose();
    super.dispose();
  }
}
