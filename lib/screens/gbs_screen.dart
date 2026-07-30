import 'package:flutter/material.dart';
import '../models/gbs_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class GBSScreen extends StatefulWidget {
  const GBSScreen({super.key});
  @override
  State<GBSScreen> createState() => _GBSScreenState();
}

class _GBSScreenState extends State<GBSScreen> {
  final GBSData _data = GBSData();

  Future<void> _salvarGBS() async {
    try {
      final score = CompletedScore(
        scoreName: 'GBS Disability Score',
        scoreData: {
          'nivelDeficiencia': _data.nivelDeficiencia,
        },
        resultado: '${_data.interpretacao} - ${_data.conduta}',
        totalScore: _data.nivelDeficiencia,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala GBS salva com sucesso!'),
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
    final nivel = _data.nivelDeficiencia;
    final interpretacao = _data.interpretacao;
    final conduta = _data.conduta;
    
    return CalculatorScaffold(
      title: 'GBS Disability Score',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Guillain-Barré Syndrome Disability Score',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          
          ...List.generate(7, (index) {
            int currentLevel = index;
            final tempData = GBSData(nivelDeficiencia: currentLevel);
            final isSelected = currentLevel == nivel;
            
            return GestureDetector(
              onTap: () => setState(() => _data.nivelDeficiencia = currentLevel),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green.shade50 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isSelected ? Colors.green : Colors.transparent, width: 2),
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
                        border: Border.all(color: isSelected ? Colors.green : Colors.grey),
                        color: isSelected ? Colors.green : Colors.transparent,
                      ),
                       child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nível $currentLevel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? Colors.green.shade800 : Colors.black87)),
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
              color: _getScoreColor(nivel),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(nivel).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('RESULTADO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  'Nível $nivel',
                  style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 12),
                 Text(
                  interpretacao,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                 const SizedBox(height: 8),
                 Container(
                   padding: const EdgeInsets.all(8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                   child: Text(
                      conduta,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                 ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarGBS,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getScoreColor(int nivel) {
    if (nivel <= 2) return Colors.green;
    if (nivel == 3) return Colors.orange;
    return Colors.red;
  }
}
