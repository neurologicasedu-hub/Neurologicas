import 'package:flutter/material.dart';
import '../models/alsfrs_r_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class ALSFRSRScreen extends StatefulWidget {
  const ALSFRSRScreen({super.key});

  @override
  State<ALSFRSRScreen> createState() => _ALSFRSRScreenState();
}

class _ALSFRSRScreenState extends State<ALSFRSRScreen> {
  final ALSFRSRData _data = ALSFRSRData();

  Future<void> _salvarALSFRSR() async {
    try {
      final score = CompletedScore(
        scoreName: 'ALSFRS-R',
        scoreData: {
          'fala': _data.fala,
          'salivacao': _data.salivacao,
          'degluticao': _data.degluticao,
          'escrita': _data.escrita,
          'cortarComUtensilios': _data.cortarComUtensilios,
          'vestirEHigiene': _data.vestirEHigiene,
          'virarNaCamaEAjustarRoupas': _data.virarNaCamaEAjustarRoupas,
          'caminhar': _data.caminhar,
          'subirEscadas': _data.subirEscadas,
          'dispneia': _data.dispneia,
          'ortopneia': _data.ortopneia,
          'insuficienciaRespiratoria': _data.insuficienciaRespiratoria,
        },
        resultado: '${_data.totalScore}/48 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ALSFRS-R salva com sucesso!'),
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
      title: 'ALSFRS-R',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Escala Funcional de Esclerose Lateral Amiotrófica Revisada.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          _buildSectionHeader('Função Bulbar'),
          _buildQuestion('1. Fala', 'Qualidade da fala.', _data.fala, (v) => setState(() => _data.fala = v), [
             const QuestionOption(label: 'Normal (4)', value: 4),
             const QuestionOption(label: 'Alteração detectável (3)', value: 3),
             const QuestionOption(label: 'Inteligível com repetição (2)', value: 2),
             const QuestionOption(label: 'Fala e inteligibilidade (1)', value: 1), // "Speech combined with nonvocal communication" typically?
             // Or simplified options based on previous file: 'Fala muito difícil'.
             // I'll stick to a clean 4-0 logic.
             // Previous Labels: 'Fala normal / Fala anormal / Fala difícil / Fala muito difícil / Sem fala'
             const QuestionOption(label: 'Perda da fala útil (0)', value: 0),
          ]),

          _buildQuestion('2. Salivação', 'Controle da saliva.', _data.salivacao, (v) => setState(() => _data.salivacao = v), [
             const QuestionOption(label: 'Normal (4)', value: 4),
             const QuestionOption(label: 'Leve excesso (3)', value: 3),
             const QuestionOption(label: 'Moderado (2)', value: 2),
             const QuestionOption(label: 'Excesso constante (1)', value: 1),
             const QuestionOption(label: 'Baba constante (0)', value: 0),
          ]),
          
          _buildQuestion('3. Deglutição', 'Capacidade de engolir.', _data.degluticao, (v) => setState(() => _data.degluticao = v), [
             const QuestionOption(label: 'Normal (4)', value: 4),
             const QuestionOption(label: 'Problemas precoces (3)', value: 3),
             const QuestionOption(label: 'Mudança consistência (2)', value: 2),
             const QuestionOption(label: 'Sonda suplementar (1)', value: 1),
             const QuestionOption(label: 'NPO / Apenas Sonda (0)', value: 0),
          ]),

          _buildSectionHeader('Função Motora Fina'),
          _buildQuestion('4. Escrita', 'Habilidade de escrever.', _data.escrita, (v) => setState(() => _data.escrita = v), [
             const QuestionOption(label: 'Normal (4)', value: 4),
             const QuestionOption(label: 'Lenta/Desleixada (3)', value: 3),
             const QuestionOption(label: 'Nem todas palavras (2)', value: 2),
             const QuestionOption(label: 'Segura caneta mas não escreve (1)', value: 1),
             const QuestionOption(label: 'Incapaz (0)', value: 0),
          ]),
          
          _buildQuestion('5. Cortar Comida', 'Uso de talheres/gastrostomia.', _data.cortarComUtensilios, (v) => setState(() => _data.cortarComUtensilios = v), [
             const QuestionOption(label: 'Normal (4)', value: 4),
             const QuestionOption(label: 'Lento/Desajeitado (3)', value: 3),
             const QuestionOption(label: 'Precisa de ajuda (2)', value: 2),
             const QuestionOption(label: 'Alguém corta comida (1)', value: 1),
             const QuestionOption(label: 'Dependente total/PEG (0)', value: 0),
          ]),

          _buildSectionHeader('Função Motora Grossa'),
          _buildQuestion('6. Vestir e Higiene', 'Independência.', _data.vestirEHigiene, (v) => setState(() => _data.vestirEHigiene = v), [
             const QuestionOption(label: 'Normal (4)', value: 4),
             const QuestionOption(label: 'Independente com esforço (3)', value: 3),
             const QuestionOption(label: 'Precisa assistência (2)', value: 2),
             const QuestionOption(label: 'Assistência total diária (1)', value: 1),
             const QuestionOption(label: 'Dependência total (0)', value: 0),
          ]),

          _buildQuestion('7. Virar na Cama', 'Mobilidade no leito.', _data.virarNaCamaEAjustarRoupas, (v) => setState(() => _data.virarNaCamaEAjustarRoupas = v), [
             const QuestionOption(label: 'Normal (4)', value: 4),
             const QuestionOption(label: 'Lento/Desajeitado (3)', value: 3),
             const QuestionOption(label: 'Pode virar sozinho com dific. (2)', value: 2),
             const QuestionOption(label: 'Pode iniciar mas não completa (1)', value: 1),
             const QuestionOption(label: 'Incapaz (0)', value: 0),
          ]),

          _buildQuestion('8. Caminhar', 'Deambulação.', _data.caminhar, (v) => setState(() => _data.caminhar = v), [
             const QuestionOption(label: 'Normal (4)', value: 4),
             const QuestionOption(label: 'Dificuldade precoce (3)', value: 3),
             const QuestionOption(label: 'Caminha com assistência (2)', value: 2),
             const QuestionOption(label: 'Movimento funcional não amb. (1)', value: 1),
             const QuestionOption(label: 'Sem função pernas (0)', value: 0),
          ]),

          _buildQuestion('9. Subir Escadas', 'Capacidade de subir degraus.', _data.subirEscadas, (v) => setState(() => _data.subirEscadas = v), [
             const QuestionOption(label: 'Normal (4)', value: 4),
             const QuestionOption(label: 'Lento (3)', value: 3),
             const QuestionOption(label: 'Instabilidade leve/Corrimão (2)', value: 2),
             const QuestionOption(label: 'Precisa assistência (1)', value: 1),
             const QuestionOption(label: 'Incapaz (0)', value: 0),
          ]),

          _buildSectionHeader('Função Respiratória'),
          _buildQuestion('10. Dispneia', 'Falta de ar.', _data.dispneia, (v) => setState(() => _data.dispneia = v), [
             const QuestionOption(label: 'Nenhuma (4)', value: 4),
             const QuestionOption(label: 'Ao caminhar (3)', value: 3),
             const QuestionOption(label: 'Ao comer/banho/vestir (2)', value: 2),
             const QuestionOption(label: 'Em repouso/sentado (1)', value: 1),
             const QuestionOption(label: 'Ventilação mecânica (0)', value: 0),
          ]),
          
          _buildQuestion('11. Ortopneia', 'Falta de ar deitado.', _data.ortopneia, (v) => setState(() => _data.ortopneia = v), [
             const QuestionOption(label: 'Nenhuma (4)', value: 4),
             const QuestionOption(label: 'Alguma dificuldade sono (3)', value: 3),
             const QuestionOption(label: 'Precisa travesseiro extra (2)', value: 2),
             const QuestionOption(label: 'Dorme sentado (1)', value: 1),
             const QuestionOption(label: 'Incapaz dormir deitado (0)', value: 0),
          ]),
          
          _buildQuestion('12. Insuficiência Resp.', 'Uso de suporte ventilatório.', _data.insuficienciaRespiratoria, (v) => setState(() => _data.insuficienciaRespiratoria = v), [
             const QuestionOption(label: 'Nenhuma (4)', value: 4),
             const QuestionOption(label: 'BiPAP intermitente (3)', value: 3),
             const QuestionOption(label: 'BiPAP noturno contínuo (2)', value: 2),
             const QuestionOption(label: 'BiPAP dia e noite (1)', value: 1),
             const QuestionOption(label: 'Ventilação invasiva/traque (0)', value: 0),
          ]),
          
          // Result Card
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
                const Text('ALSFRS-R TOTAL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const Text(
                  '/ 48',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bulbar: ${_data.scoreBulbar} | Motor: ${_data.scoreMotorFino + _data.scoreMotorGrosso} | Resp: ${_data.scoreRespiratorio}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarALSFRSR,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 20),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.red.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildQuestion(String title, String subtitle, int value, ValueChanged<int> onChanged, List<QuestionOption<int>> options) {
    return QuestionCard<int>(
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
      options: options,
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 40) return Colors.green;
    if (score >= 24) return Colors.orange;
    return Colors.red;
  }
}
