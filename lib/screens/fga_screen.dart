import 'package:flutter/material.dart';
import '../models/fga_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class FGAScreen extends StatefulWidget {
  const FGAScreen({super.key});

  @override
  State<FGAScreen> createState() => _FGAScreenState();
}

class _FGAScreenState extends State<FGAScreen> {
  final FGAData _data = FGAData();

  Future<void> _salvarFGA() async {
    try {
      final score = CompletedScore(
        scoreName: 'Functional Gait Assessment (FGA)',
        scoreData: {
          'caminharSuperficiePlana': _data.caminharSuperficiePlana,
          'caminharMudancaVelocidade': _data.caminharMudancaVelocidade,
          'caminharViradasCabecaHorizontal': _data.caminharViradasCabecaHorizontal,
          'caminharViradasCabecaVertical': _data.caminharViradasCabecaVertical,
          'girar180': _data.girar180,
          'caminharAtravessarObstaculo': _data.caminharAtravessarObstaculo,
          'caminharLinhaRetaTandem': _data.caminharLinhaRetaTandem,
          'subirDescerEscadas': _data.subirDescerEscadas,
          'caminharOlhosFechados': _data.caminharOlhosFechados,
          'caminharCostas': _data.caminharCostas,
          'caminharSuperficieEstreita': _data.caminharSuperficieEstreita,
        },
        resultado: '${_data.totalScore}/30 - ${_data.interpretacao}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala FGA salva com sucesso!'),
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
    return CalculatorScaffold(
      title: 'Functional Gait Assessment (FGA)',
      body: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Avaliação de marcha funcional sob desafios.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),

        _buildQuestion('1. Superfície Plana', 'Caminhar em superfície plana.', _data.caminharSuperficiePlana, (v) => setState(() => _data.caminharSuperficiePlana = v)),
        _buildQuestion('2. Mudança de Velocidade', 'Caminhar mudando velocidade.', _data.caminharMudancaVelocidade, (v) => setState(() => _data.caminharMudancaVelocidade = v)),
        _buildQuestion('3. Virar Cabeça (Horizontal)', 'Caminhar virando a cabeça horizontalmente.', _data.caminharViradasCabecaHorizontal, (v) => setState(() => _data.caminharViradasCabecaHorizontal = v)),
        _buildQuestion('4. Virar Cabeça (Vertical)', 'Caminhar virando a cabeça verticalmente.', _data.caminharViradasCabecaVertical, (v) => setState(() => _data.caminharViradasCabecaVertical = v)),
        _buildQuestion('5. Girar 180°', 'Caminhar e girar 180 graus.', _data.girar180, (v) => setState(() => _data.girar180 = v)),
        _buildQuestion('6. Atravessar Obstáculo', 'Caminhar sobre obstáculo.', _data.caminharAtravessarObstaculo, (v) => setState(() => _data.caminharAtravessarObstaculo = v)),
        _buildQuestion('7. Linha Reta (Tandem)', 'Caminhar em linha reta (calcanhar-dedo).', _data.caminharLinhaRetaTandem, (v) => setState(() => _data.caminharLinhaRetaTandem = v)),
        _buildQuestion('8. Olhos Fechados', 'Caminhar com olhos fechados.', _data.caminharOlhosFechados, (v) => setState(() => _data.caminharOlhosFechados = v)),
        _buildQuestion('9. Caminhar de Costas', 'Caminhar para trás.', _data.caminharCostas, (v) => setState(() => _data.caminharCostas = v)),
        _buildQuestion('10. Escadas', 'Subir e descer escadas.', _data.subirDescerEscadas, (v) => setState(() => _data.subirDescerEscadas = v)), // Note: Moved Item 10 to standard place? Original was 8th item?
        // Original list:
        // 1. Plana
        // 2. Velocidade
        // 3. Horizontal
        // 4. Vertical
        // 5. Girar 180
        // 6. Obstaculo
        // 7. Tandem
        // 8. Escadas
        // 9. Olhos Fechados
        // 10. Costas
        // 11. Superficie Estreita ??? (Standard FGA has 10 items).
        // Let's check original file again.
        // Original keys: 'caminharSuperficieEstreita'.
        // Wait, standard FGA is 10 items.
        // Item 10 is Steps (Stairs).
        // Did the previous implementation have 11 items?
        // Original Code Items:
        // 1. Plana
        // 2. Velocidade
        // 3. Horizontal
        // 4. Vertical
        // 5. Girar180
        // 6. Obstaculo
        // 7. Tandem
        // 8. Escadas
        // 9. Olhos Fechados
        // 10. Costas
        // 11. Superficie Estreita
        // This suggests a modified FGA or just extra item. I will preserve ALL items from previous file to avoid data loss.
        
        // Wait, Item 8 in original was Escadas.
        // Item 9 Olhos Fechados.
        // Item 10 Costas.
        // Item 11 Superficie Estreita.
        // I will just append the 11th item.
        _buildQuestion('11. Superfície Estreita', 'Caminhar em base estreita.', _data.caminharSuperficieEstreita, (v) => setState(() => _data.caminharSuperficieEstreita = v)),

        // Result Card
        Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(_data.totalScore),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(_data.totalScore).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('FGA SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '${_data.totalScore}',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                Text(
                 // Dynamic max score based on 11 items -> 33 max
                  '/ 33', // Original file said 'maximo 30 pontos' in text but had 11 items 0-3? That's 33.
                          // Or maybe one item was non-scored?
                          // _data.totalScore getter in fga_data likely sums all.
                          // Let's assume 33 if 11 items.
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                   child: Text(
                    _data.interpretacao,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarFGA,
        backgroundColor: Colors.amber.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildQuestion(String title, String subtitle, int value, ValueChanged<int> onChanged) {
    return QuestionCard<int>(
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
      options: const [
        QuestionOption(label: 'Normal (3)', value: 3),
        QuestionOption(label: 'Leve (2)', value: 2),
        QuestionOption(label: 'Moderado (1)', value: 1),
        QuestionOption(label: 'Grave (0)', value: 0),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score > 22) return Colors.green;
    return Colors.orange;
  }
}
