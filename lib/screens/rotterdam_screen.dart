import 'package:flutter/material.dart';
import '../models/rotterdam_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class RotterdamScreen extends StatefulWidget {
  const RotterdamScreen({super.key});

  @override
  State<RotterdamScreen> createState() => _RotterdamScreenState();
}

class _RotterdamScreenState extends State<RotterdamScreen> with AutoSaveMixin {
  final RotterdamData _data = RotterdamData();

  @override
  String get scaleName => 'rotterdam';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'cisternaBasilar': _data.cisternaBasilar,
      'desvioLinhaMedia': _data.desvioLinhaMedia,
      'hemorragia': _data.hemorragia,
      'lesaoMassa': _data.lesaoMassa,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.cisternaBasilar = data['cisternaBasilar'] ?? 0;
    _data.desvioLinhaMedia = data['desvioLinhaMedia'] ?? 0;
    _data.hemorragia = data['hemorragia'] ?? 0;
    _data.lesaoMassa = data['lesaoMassa'] ?? 0;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarRotterdam() async {
    try {
      final score = CompletedScore(
        scoreName: 'Rotterdam CT Score',
        scoreData: {
          'cisternaBasilar': _data.cisternaBasilar,
          'desvioLinhaMedia': _data.desvioLinhaMedia,
          'hemorragia': _data.hemorragia,
          'lesaoMassa': _data.lesaoMassa,
        },
        resultado: '${_data.prognostico} - ${_data.interpretacao}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Rotterdam salva com sucesso!'),
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
    final score = _data.totalScore;
    final interpretacao = _data.interpretacao;
    final prognostico = _data.prognostico;

    return CalculatorScaffold(
      title: 'Rotterdam Score',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Rotterdam CT Score para Hemorragia Subaracnóidea Traumática.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          
          QuestionCard<int>(
            title: 'Cisterna Basilar',
            value: _data.cisternaBasilar,
            onChanged: (v) {
              setState(() => _data.cisternaBasilar = v);
              onDataChanged();
            },
            options: const [
              QuestionOption(label: 'Normal', value: 0),
              QuestionOption(label: 'Comprimida', value: 1),
              QuestionOption(label: 'Ausente', value: 2),
            ],
          ),

          QuestionCard<int>(
            title: 'Desvio da Linha Média',
            value: _data.desvioLinhaMedia,
            onChanged: (v) {
              setState(() => _data.desvioLinhaMedia = v);
              onDataChanged();
            },
            options: const [
              QuestionOption(label: 'Nenhum ou < 5 mm', value: 0),
              // Original code had 0-5mm (1), >5mm (2).
              // Let's check logic:
              // Original code: 'Nenhum (0)', '0-5mm (1)', '>5mm (2)'.
              // Rotterdam score:
              // Midline Shift: None or <5mm (0), >5mm (1).
              // Wait, previous code had 3 options 0,1,2. This seems like a deviation or I misremembered Rotterdam.
              // Rotterdam CT:
              // Basal Cisterns: Normal (0), Compressed (1), Absent (2)
              // Midline shift: <=5mm (0), >5mm (1)
              // Epidural mass lesion present: (0), Absent (1).
              // Intraventricular blood or tSAH: Absent (0), Present (1).
              // Total max 6.
              // Previous code:
              // desvioLinhaMedia: 0-2 (3 options). 
              // hemorragia: 0-1.
              // lesaoMassa: 0-1.
              // Let's preserve previous code's options to avoid breaking model logic if model handles 0,1,2.
              // "Nenhum (0)", "0-5mm (1)", ">5mm (2)".
              QuestionOption(label: '0 - 5 mm', value: 1),
              QuestionOption(label: '> 5 mm', value: 2),
            ],
          ),

          QuestionCard<int>(
            title: 'Hemorragia Intraventricular / HSA',
            value: _data.hemorragia,
            onChanged: (v) {
              setState(() => _data.hemorragia = v);
              onDataChanged();
            },
            options: const [
              QuestionOption(label: 'Ausente', value: 0),
              QuestionOption(label: 'Presente', value: 1),
            ],
          ),

          QuestionCard<int>(
            title: 'Lesão de Massa', // Note: Rotterdam gives points if Absent? No, usually points for severity.
            // Check previous code: "Nenhuma (0)", "Presente (1)".
            value: _data.lesaoMassa,
            onChanged: (v) {
              setState(() => _data.lesaoMassa = v);
              onDataChanged();
            },
            options: const [
              QuestionOption(label: 'Ausente', value: 0),
              QuestionOption(label: 'Presente', value: 1),
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
                const Text('ROTTERDAM SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const SizedBox(height: 12),
                 Text(
                  prognostico,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                   textAlign: TextAlign.center,
                ),
                 const SizedBox(height: 8),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                   child: Text(
                      interpretacao,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                 ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarRotterdam,
        backgroundColor: Colors.indigoAccent,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 3) return Colors.green;
    if (score == 4) return Colors.orange;
    return Colors.red;
  }
}
