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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card principal com resultado
            Card(
              elevation: 6,
              color: _getScoreColor(totalScore),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.assessment,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pontuação Total NIHSS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$totalScore',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      interpretacao,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Alerta para Angio TC
            if (precisaAngioTC)
              Card(
                elevation: 4,
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.red.shade700,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Atenção!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Paciente com pontuação superior a 5 pontos. Sugerido investigar obstrução de grandes vasos através de Angio TC.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 20),
            
            // Detalhamento das respostas
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalhamento das Respostas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('1A. Nível de Consciência', nihssData.nivelConsciencia),
                    _buildDetailRow('1B. Perguntar mês e idade', nihssData.perguntasConsciencia),
                    _buildDetailRow('1C. Comandos', nihssData.comandosConsciencia),
                    _buildDetailRow('2. Melhor olhar conjugado', nihssData.olharConjugado),
                    _buildDetailRow('3. Campo Visual', nihssData.campoVisual),
                    _buildDetailRow('4. Paralisia Facial', nihssData.paralisiaFacial),
                    _buildDetailRow('5A. Motor para braço esquerdo', nihssData.motorBracoEsquerdo),
                    _buildDetailRow('5B. Motor para braço direito', nihssData.motorBracoDireito),
                    _buildDetailRow('6A. Motor para perna esquerda', nihssData.motorPernaEsquerda),
                    _buildDetailRow('6B. Motor para perna direita', nihssData.motorPernaDireita),
                    _buildDetailRow('7. Ataxia', nihssData.ataxia),
                    _buildDetailRow('8. Sensibilidade', nihssData.sensibilidade),
                    _buildDetailRow('9. Linguagem', nihssData.linguagem),
                    _buildDetailRow('10. Disartria', nihssData.disartria),
                    _buildDetailRow('11. Desatenção', nihssData.desatencao),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Informações do paciente
            if (nihssData.pesoPaciente != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informações do Paciente',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Peso: ${nihssData.pesoPaciente!.toStringAsFixed(1)} kg',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 20),
            
            // Botão para salvar escala
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _salvarNIHSS(context);
                },
                icon: const Icon(Icons.save),
                label: const Text('Salvar Escala NIHSS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Botão para prosseguir para critérios de exclusão
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
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Prosseguir para Critérios de Exclusão'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
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
      ),
    );
  }

  Widget _buildDetailRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$value',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
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
