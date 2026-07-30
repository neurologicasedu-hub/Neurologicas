import 'package:flutter/material.dart';
import '../models/pdq39_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class PDQ39Screen extends StatefulWidget {
  const PDQ39Screen({super.key});

  @override
  State<PDQ39Screen> createState() => _PDQ39ScreenState();
}

class _PDQ39ScreenState extends State<PDQ39Screen> {
  final PDQ39Data _data = PDQ39Data();

  final List<String> _mobilidadeQuestions = [
    'Dificuldade para vestir-se?',
    'Dificuldade para cortar comida?',
    'Dificuldade para tomar banho?',
    'Dificuldade para andar?',
    'Dificuldade para entrar e sair do carro?',
    'Dificuldade para fazer compras?',
    'Dificuldade para caminhar por lugares públicos?',
    'Dificuldade para se mover dentro de casa?',
    'Dificuldade para fazer suas tarefas domésticas?',
    'Confinado em casa ou evitou situações sociais?',
  ];

  final List<String> _atividadesVidaDiariaQuestions = [
    'Dificuldade para fazer as tarefas de rotina?',
    'Dificuldade para fazer tarefas domésticas sozinho?',
    'Dificuldade para cuidar de seus negócios pessoais?',
    'Dificuldade para realizar trabalhos manuais ou hobbies?',
    'Dificuldade para manter padrão de vida anterior?',
    'Precisou de ajuda de outras pessoas?',
  ];

  final List<String> _bemEstarEmocionalQuestions = [
    'Sentiu-se deprimido?',
    'Sentiu-se isolado e sozinho?',
    'Teve medo ou preocupação com o futuro?',
    'Sentiu-se culpado ou um fardo?',
    'Sentiu-se ansioso?',
    'Perdeu a confiança em si mesmo?',
  ];

  final List<String> _estigmaQuestions = [
    'Evitou comer ou beber em público?',
    'Sentiu-se embaraçado pela doença em público?',
    'Evitou situações sociais?',
    'Sentiu-se excluído do mundo em geral?',
  ];

  final List<String> _suporteSocialQuestions = [
    'Falta de apoio da família?',
    'Falta de apoio de amigos?',
    'Dificuldades nas relações familiares?',
  ];

  final List<String> _cognicaoQuestions = [
    'Problemas para se concentrar?',
    'Problemas para lembrar das coisas?',
    'Dificuldades para raciocinar?',
    'Problemas com memória?',
  ];

  final List<String> _comunicacaoQuestions = [
    'Dificuldades para falar?',
    'Dificuldades para comunicar-se?',
    'Problemas para entender o que diziam?',
  ];

  final List<String> _desconfortoCorporalQuestions = [
    'Dores e desconfortos musculares?',
    'Câimbras ou espasmos?',
    'Dores ou desconfortos incomuns?',
  ];

  Future<void> _salvarPDQ39() async {
    try {
      final score = CompletedScore(
        scoreName: 'PDQ-39 (Parkinson\'s Disease Questionnaire)',
        scoreData: {
          'percentualTotal': _data.percentualTotal,
          'percentualMobilidade': _data.percentualMobilidade,
          'percentualAtividadesVidaDiaria': _data.percentualAtividadesVidaDiaria,
          'percentualBemEstarEmocional': _data.percentualBemEstarEmocional,
          // Store all if needed, but model handles calculation
        },
        resultado: '${_data.percentualTotal.toStringAsFixed(1)}% - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala PDQ-39 salva com sucesso!'),
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
    final percentual = _data.percentualTotal;
    return CalculatorScaffold(
      title: 'PDQ-39 (Parkinson)',
      body: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Questionário de Qualidade de Vida na Doença de Parkinson.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),

        _buildSectionHeader('Mobilidade'),
        ...List.generate(_mobilidadeQuestions.length, (i) => _buildQuestionItem(i, _mobilidadeQuestions[i], _data.mobilidade[i], (v) => setState(() => _data.mobilidade[i] = v))),

        _buildSectionHeader('Atividades de Vida Diária'),
        ...List.generate(_atividadesVidaDiariaQuestions.length, (i) => _buildQuestionItem(i, _atividadesVidaDiariaQuestions[i], _data.atividadesVidaDiaria[i], (v) => setState(() => _data.atividadesVidaDiaria[i] = v))),
        
        _buildSectionHeader('Bem-Estar Emocional'),
        ...List.generate(_bemEstarEmocionalQuestions.length, (i) => _buildQuestionItem(i, _bemEstarEmocionalQuestions[i], _data.bemEstarEmocional[i], (v) => setState(() => _data.bemEstarEmocional[i] = v))),

        _buildSectionHeader('Estigma'),
        ...List.generate(_estigmaQuestions.length, (i) => _buildQuestionItem(i, _estigmaQuestions[i], _data.estigma[i], (v) => setState(() => _data.estigma[i] = v))),

        _buildSectionHeader('Suporte Social'),
        ...List.generate(_suporteSocialQuestions.length, (i) => _buildQuestionItem(i, _suporteSocialQuestions[i], _data.suporteSocial[i], (v) => setState(() => _data.suporteSocial[i] = v))),

        _buildSectionHeader('Cognição'),
        ...List.generate(_cognicaoQuestions.length, (i) => _buildQuestionItem(i, _cognicaoQuestions[i], _data.cognicao[i], (v) => setState(() => _data.cognicao[i] = v))),

        _buildSectionHeader('Comunicação'),
        ...List.generate(_comunicacaoQuestions.length, (i) => _buildQuestionItem(i, _comunicacaoQuestions[i], _data.comunicacao[i], (v) => setState(() => _data.comunicacao[i] = v))),

        _buildSectionHeader('Desconforto Corporal'),
        ...List.generate(_desconfortoCorporalQuestions.length, (i) => _buildQuestionItem(i, _desconfortoCorporalQuestions[i], _data.desconfortoCorporal[i], (v) => setState(() => _data.desconfortoCorporal[i] = v))),

        // Result Card
        Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(percentual),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(percentual).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('PDQ-39 TOTAL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '${percentual.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const SizedBox(height: 12),
                Text(
                  'Mobilidade: ${_data.percentualMobilidade.toStringAsFixed(0)}% | AVD: ${_data.percentualAtividadesVidaDiaria.toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                Text(
                  'Emocional: ${_data.percentualBemEstarEmocional.toStringAsFixed(0)}% | Estigma: ${_data.percentualEstigma.toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                 const SizedBox(height: 12),
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
        onPressed: _salvarPDQ39,
        backgroundColor: Colors.pink,
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
          color: Colors.pink.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildQuestionItem(int index, String question, int value, ValueChanged<int> onChanged) {
    return QuestionCard<int>(
      title: question,
      value: value,
      onChanged: onChanged,
      options: const [
        QuestionOption(label: 'Nunca (0)', value: 0),
        QuestionOption(label: 'Ocasionalmente (1)', value: 1),
        QuestionOption(label: 'Às vezes (2)', value: 2),
        QuestionOption(label: 'Frequentemente (3)', value: 3),
        QuestionOption(label: 'Sempre/Impossível (4)', value: 4),
      ],
    );
  }

  Color _getScoreColor(double percentual) {
    if (percentual <= 25) return Colors.green;
    if (percentual <= 50) return Colors.orange;
    return Colors.red;
  }
}
