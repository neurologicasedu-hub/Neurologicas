import 'package:flutter/material.dart';
import '../models/nihss_data.dart';
import '../models/completed_score.dart';
import '../services/patient_service.dart';
import 'trombolise_screen.dart';

class NIHSSResultScreen extends StatelessWidget {
  final NIHSSData nihssData;

  const NIHSSResultScreen({
    super.key,
    required this.nihssData,
  });

  Future<void> _salvarNIHSS(BuildContext context) async {
    try {
      final score = CompletedScore(
        scoreName: 'NIHSS',
        scoreData: nihssData.toJson(),
        resultado: nihssData.interpretacaoClinica,
        totalScore: nihssData.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala NIHSS salva com sucesso!'),
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
      if (context.mounted) {
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
    final totalScore = nihssData.totalScore;
    final interpretacao = nihssData.interpretacaoClinica;
    final precisaAngioTC = nihssData.precisaAngioTC;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado NIHSS'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Score Result Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getScoreGradient(totalScore),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _getScoreColor(totalScore).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                   const Text(
                    'PONTUAÇÃO TOTAL',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$totalScore',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      interpretacao,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Angio TC Alert
            if (precisaAngioTC)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recomendação de Exame',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sugerido investigar obstrução de grandes vasos (Angio TC) devido à pontuação > 5.',
                            style: TextStyle(fontSize: 14, color: Colors.orange.shade900),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

             // Patient Info
             if (nihssData.pesoPaciente != null)
               Container(
                 margin: const EdgeInsets.only(bottom: 24),
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(16),
                   border: Border.all(color: Colors.grey.shade200),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withOpacity(0.02),
                       blurRadius: 10,
                       offset: const Offset(0, 4),
                     ),
                   ],
                 ),
                 child: Row(
                   children: [
                     Icon(Icons.monitor_weight_outlined, color: Colors.blue.shade700),
                     const SizedBox(width: 12),
                     const Text('Peso do Paciente:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                     const SizedBox(width: 8),
                     Text('${nihssData.pesoPaciente!.toStringAsFixed(1)} kg', style: const TextStyle(fontSize: 16)),
                   ],
                 ),
               ),

            // Detailed Results
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 12),
                  child: Text(
                    'DETALHAMENTO',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                _buildDetailRow('1A. Nível de Consciência', nihssData.nivelConsciencia),
                _buildDetailRow('1B. Perguntas', nihssData.perguntasConsciencia),
                _buildDetailRow('1C. Comandos', nihssData.comandosConsciencia),
                _buildDetailRow('2. Olhar Conjugado', nihssData.olharConjugado),
                _buildDetailRow('3. Campo Visual', nihssData.campoVisual),
                _buildDetailRow('4. Paralisia Facial', nihssData.paralisiaFacial),
                _buildDetailRow('5A. Braço Esquerdo', nihssData.motorBracoEsquerdo),
                _buildDetailRow('5B. Braço Direito', nihssData.motorBracoDireito),
                _buildDetailRow('6A. Perna Esquerda', nihssData.motorPernaEsquerda),
                _buildDetailRow('6B. Perna Direita', nihssData.motorPernaDireita),
                _buildDetailRow('7. Ataxia', nihssData.ataxia),
                _buildDetailRow('8. Sensibilidade', nihssData.sensibilidade),
                _buildDetailRow('9. Linguagem', nihssData.linguagem),
                _buildDetailRow('10. Disartria', nihssData.disartria),
                _buildDetailRow('11. Desatenção', nihssData.desatencao),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _salvarNIHSS(context);
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text('SALVAR NO HISTÓRICO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TromboliseScreen(
                        nihssScore: nihssData.totalScore,
                        pesoPaciente: nihssData.pesoPaciente,
                        interpretacaoNIHSS: nihssData.interpretacaoClinica,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.bolt),
                label: const Text('AVALIAR TROMBÓLISE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00509D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    icon: const Icon(Icons.home),
                    label: const Text('Início'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, int value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: value > 0 ? Colors.red.shade50 : Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: value > 0 ? Colors.red.shade100 : Colors.green.shade100,
              ),
            ),
            child: Text(
              '+$value',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: value > 0 ? Colors.red.shade700 : Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  List<Color> _getScoreGradient(int score) {
     if (score == 0) return [Colors.green.shade400, Colors.green.shade700];
     if (score <= 4) return [Colors.lightGreen.shade400, Colors.lightGreen.shade700];
     if (score <= 15) return [Colors.orange.shade400, Colors.orange.shade700];
     if (score <= 20) return [Colors.deepOrange.shade400, Colors.deepOrange.shade700];
     return [Colors.red.shade400, Colors.red.shade700];
  }

  Color _getScoreColor(int score) {
    if (score == 0) {
      return Colors.green;
    } else if (score <= 4) {
      return Colors.lightGreen;
    } else if (score <= 15) {
      return Colors.orange;
    } else if (score <= 20) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }
}
