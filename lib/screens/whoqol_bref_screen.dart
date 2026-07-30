import 'package:flutter/material.dart';
import '../models/whoqol_bref_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class WHOQOLBREFScreen extends StatefulWidget {
  const WHOQOLBREFScreen({super.key});

  @override
  State<WHOQOLBREFScreen> createState() => _WHOQOLBREFScreenState();
}

class _WHOQOLBREFScreenState extends State<WHOQOLBREFScreen> {
  final WHOQOLBREFData _data = WHOQOLBREFData();

  final List<String> _questions = [
    'Como você avaliaria sua qualidade de vida?', // Q1 - Geral
    'Quão satisfeito(a) você está com sua saúde?', // Q2 - Geral
    'Quanto você precisa de algum tratamento médico para conseguir desempenhar suas atividades diárias?', // Q3 - Físico
    'Quanta energia você tem?', // Q4 - Físico
    'Com que frequência você tem sentimentos positivos?', // Q5 - Psicológico
    'O quanto você consegue se concentrar?', // Q6 - Psicológico
    'O quanto você consegue aceitar sua aparência física?', // Q7 - Psicológico
    'O quanto você se sente seguro(a) no seu dia a dia?', // Q8 - Ambiente
    'O quanto seu ambiente físico (poluição, ruído, clima, paisagem) o(a) incomoda?', // Q9 - Ambiente
    'O quanto você dorme bem?', // Q10 - Físico
    'O quanto você gosta de viver?', // Q11 - Psicológico
    'O quanto você tem dinheiro suficiente para atender suas necessidades?', // Q12 - Ambiente
    'O quanto você tem acesso às informações que precisa em seu dia a dia?', // Q13 - Ambiente
    'O quanto você tem oportunidades para atividades de lazer?', // Q14 - Ambiente
    'O quão bem você se locomove?', // Q15 - Físico
    'O quanto você consegue realizar suas atividades da vida diária?', // Q16 - Físico
    'O quanto você precisa de medicamento para funcionar no seu dia a dia?', // Q17 - Físico
    'O quanto você consegue trabalhar?', // Q18 - Físico
    'O quanto você tem sentimentos negativos como mau humor, desespero, ansiedade, depressão?', // Q19 - Psicológico (invertido)
    'O quanto você consegue manter relações pessoais íntimas?', // Q20 - Social
    'O quanto você consegue contar com seus amigos?', // Q21 - Social
    'O quanto você está satisfeito(a) com sua vida sexual?', // Q22 - Social
    'O quanto você consegue fazer coisas de que gosta nas horas de lazer?', // Q23 - Ambiente
    'O quanto você está satisfeito(a) com as condições do lugar onde vive?', // Q24 - Ambiente
    'O quanto você está satisfeito(a) com seu transporte?', // Q25 - Ambiente
    'O quanto você tem oportunidades de aprender novas habilidades?', // Q26 - Psicológico
  ];

  Future<void> _salvarWHOQOLBREF() async {
    try {
      final score = CompletedScore(
        scoreName: 'WHOQOL-BREF',
        scoreData: {
           // Mapping manually to ensure completeness
          'qualidadeVida': _data.qualidadeVida,
          'satisfacaoSaude': _data.satisfacaoSaude,
          'dorDesconforto': _data.dorDesconforto,
          'energiaFadiga': _data.energiaFadiga,
          'sonoRepouso': _data.sonoRepouso,
          'mobilidade': _data.mobilidade,
          'atividadesDiarias': _data.atividadesDiarias,
          'dependenciaMedicamentos': _data.dependenciaMedicamentos,
          'capacidadeTrabalho': _data.capacidadeTrabalho,
          'sentimentosPositivos': _data.sentimentosPositivos,
          'aprenderMemoria': _data.aprenderMemoria,
          'autoestima': _data.autoestima,
          'imagemCorporal': _data.imagemCorporal,
          'sentimentosNegativos': _data.sentimentosNegativos,
          'espiritualidade': _data.espiritualidade,
          'relacoesPessoais': _data.relacoesPessoais,
          'suporteSocial': _data.suporteSocial,
          'atividadeSexual': _data.atividadeSexual,
          'segurancaFisica': _data.segurancaFisica,
          'ambienteDomestico': _data.ambienteDomestico,
          'recursosFinanceiros': _data.recursosFinanceiros,
          'servicosSaude': _data.servicosSaude,
          'novasInformacoes': _data.novasInformacoes,
          'recreacaoLazer': _data.recreacaoLazer,
          'ambienteFisico': _data.ambienteFisico,
          'transporte': _data.transporte,
        },
        resultado: '${_data.scoreTotal.toStringAsFixed(1)}/100 - ${_data.interpretation}',
        totalScore: _data.scoreTotal.round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala WHOQOL-BREF salva com sucesso!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ver Relatório',
              textColor: Colors.white,
              onPressed: () => Navigator.pushReplacementNamed(context, '/report'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  int _getValue(int index) {
    final values = [
      _data.qualidadeVida, _data.satisfacaoSaude, _data.dorDesconforto, _data.energiaFadiga,
      _data.sentimentosPositivos, _data.aprenderMemoria, _data.autoestima, _data.segurancaFisica,
      _data.ambienteDomestico, _data.sonoRepouso, _data.imagemCorporal, _data.recursosFinanceiros,
      _data.servicosSaude, _data.novasInformacoes, _data.mobilidade, _data.atividadesDiarias,
      _data.dependenciaMedicamentos, _data.capacidadeTrabalho, _data.sentimentosNegativos, _data.relacoesPessoais,
      _data.suporteSocial, _data.atividadeSexual, _data.recreacaoLazer, _data.ambienteFisico,
      _data.transporte, _data.espiritualidade,
    ];
    return values[index];
  }

  void _setValue(int index, int value) {
    switch (index) {
      case 0: setState(() => _data.qualidadeVida = value); break;
      case 1: setState(() => _data.satisfacaoSaude = value); break;
      case 2: setState(() => _data.dorDesconforto = value); break;
      case 3: setState(() => _data.energiaFadiga = value); break;
      case 4: setState(() => _data.sentimentosPositivos = value); break;
      case 5: setState(() => _data.aprenderMemoria = value); break;
      case 6: setState(() => _data.autoestima = value); break;
      case 7: setState(() => _data.segurancaFisica = value); break;
      case 8: setState(() => _data.ambienteDomestico = value); break;
      case 9: setState(() => _data.sonoRepouso = value); break;
      case 10: setState(() => _data.imagemCorporal = value); break;
      case 11: setState(() => _data.recursosFinanceiros = value); break;
      case 12: setState(() => _data.servicosSaude = value); break;
      case 13: setState(() => _data.novasInformacoes = value); break;
      case 14: setState(() => _data.mobilidade = value); break;
      case 15: setState(() => _data.atividadesDiarias = value); break;
      case 16: setState(() => _data.dependenciaMedicamentos = value); break;
      case 17: setState(() => _data.capacidadeTrabalho = value); break;
      case 18: setState(() => _data.sentimentosNegativos = value); break;
      case 19: setState(() => _data.relacoesPessoais = value); break;
      case 20: setState(() => _data.suporteSocial = value); break;
      case 21: setState(() => _data.atividadeSexual = value); break;
      case 22: setState(() => _data.recreacaoLazer = value); break;
      case 23: setState(() => _data.ambienteFisico = value); break;
      case 24: setState(() => _data.transporte = value); break;
      case 25: setState(() => _data.espiritualidade = value); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.scoreTotal;
    return CalculatorScaffold(
      title: 'WHOQOL-BREF',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Avaliação de Qualidade de Vida Abreviada.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          ...List.generate(_questions.length, (i) => _buildQuestionItem(i, _questions[i], _getValue(i), (v) => _setValue(i, v))),

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
                const Text('WHOQOL SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  score.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const Text(
                  '/ 100',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                 Text(
                   'Físico: ${_data.scoreFisico.toStringAsFixed(0)} | Psico: ${_data.scorePsicologico.toStringAsFixed(0)} | Social: ${_data.scoreSocial.toStringAsFixed(0)} | Amb: ${_data.scoreAmbiente.toStringAsFixed(0)}',
                   style: const TextStyle(fontSize: 11, color: Colors.white70),
                 ),
                 const SizedBox(height: 8),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                   child: Text(
                    _data.interpretation,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarWHOQOLBREF,
        backgroundColor: Colors.green.shade700,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildQuestionItem(int index, String question, int value, ValueChanged<int> onChanged) {
    return QuestionCard<int>(
      title: 'Q${index + 1}. $question',
      value: value,
      onChanged: onChanged,
      options: const [
        QuestionOption(label: '1 - Muito ruim/Nada', value: 1),
        QuestionOption(label: '2 - Ruim/Muito pouco', value: 2),
        QuestionOption(label: '3 - Nem ruim nem boa/Médio', value: 3),
        QuestionOption(label: '4 - Boa/Muito', value: 4),
        QuestionOption(label: '5 - Muito boa/Extremamente', value: 5),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 75) return Colors.green;
    if (score >= 50) return Colors.lightGreen;
    if (score >= 25) return Colors.orange;
    return Colors.red;
  }
}
