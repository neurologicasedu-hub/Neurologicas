import 'package:flutter/material.dart';
import '../models/mgfa_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class MGFAScreen extends StatefulWidget {
  const MGFAScreen({super.key});
  @override
  State<MGFAScreen> createState() => _MGFAScreenState();
}

class _MGFAScreenState extends State<MGFAScreen> {
  final MGFAData _data = MGFAData();

  Future<void> _salvarMGFA() async {
    try {
      final score = CompletedScore(
        scoreName: 'MGFA Classification',
        scoreData: {
          'classe': _data.classe,
        },
        resultado: _data.interpretacao,
        totalScore: _data.classe,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala MGFA salva com sucesso!'),
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
    final classe = _data.classe;
    final interpretacao = _data.interpretacao;

    return CalculatorScaffold(
      title: 'MGFA Classification',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Myasthenia Gravis Foundation of America Clinical Classification',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          ...List.generate(5, (index) {
            int currentClass = index + 1;
            final tempData = MGFAData(classe: currentClass);
            final isSelected = currentClass == classe;
            
            return GestureDetector(
              onTap: () => setState(() => _data.classe = currentClass),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade50 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isSelected ? Colors.blue : Colors.transparent, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
                        color: isSelected ? Colors.blue : Colors.transparent,
                      ),
                       child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Classe $currentClass', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? Colors.blue.shade800 : Colors.black87)),
                          const SizedBox(height: 4),
                          Text(tempData.descricao, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(classe),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(classe).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('CLASSIFICAÇÃO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  'Classe $classe',
                  style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 12),
                 Text(
                  interpretacao,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarMGFA,
        backgroundColor: Colors.blue.shade800,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getScoreColor(int classe) {
    if (classe <= 2) return Colors.green;
    if (classe <= 3) return Colors.orange;
    return Colors.red;
  }
}
