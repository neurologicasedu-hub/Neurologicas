import 'package:flutter/material.dart';
import '../models/pdq39_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class PDQ39Screen extends StatefulWidget {
  const PDQ39Screen({super.key});

  @override
  State<PDQ39Screen> createState() => _PDQ39ScreenState();
}

class _PDQ39ScreenState extends State<PDQ39Screen> {
  final PDQ39Data _data = PDQ39Data();

  // Perguntas oficiais do PDQ-39 por domínio
  final List<String> _mobilidadeQuestions = [
    'Você teve dificuldade para vestir-se?',
    'Você teve dificuldade para cortar comida?',
    'Você teve dificuldade para tomar banho?',
    'Você teve dificuldade para andar?',
    'Você teve dificuldade para entrar e sair do carro?',
    'Você teve dificuldade para fazer compras?',
    'Você teve dificuldade para caminhar por lugares públicos?',
    'Você teve dificuldade para se mover dentro de casa?',
    'Você teve dificuldade para fazer suas tarefas domésticas?',
    'Você ficou confinado em casa ou precisou evitar situações sociais?',
  ];

  final List<String> _atividadesVidaDiariaQuestions = [
    'Você teve dificuldade para fazer as tarefas de rotina?',
    'Você teve dificuldade para fazer suas tarefas domésticas sozinho?',
    'Você teve dificuldade para cuidar de seus negócios pessoais?',
    'Você teve dificuldade para realizar trabalhos manuais ou hobbies?',
    'Você teve dificuldade para manter seu padrão de vida anterior?',
    'Você precisou de ajuda de outras pessoas para realizar atividades do dia a dia?',
  ];

  final List<String> _bemEstarEmocionalQuestions = [
    'Você sentiu deprimido?',
    'Você sentiu isolado e sozinho?',
    'Você teve medo ou preocupação com o futuro?',
    'Você sentiu culpado ou um fardo para os outros?',
    'Você sentiu ansioso?',
    'Você perdeu a confiança em si mesmo?',
  ];

  final List<String> _estigmaQuestions = [
    'Você evitou comer ou beber em público?',
    'Você se sentiu embaraçado pela doença de Parkinson em público?',
    'Você evitou situações sociais que você costumava frequentar?',
    'Você se sentiu excluído do mundo em geral?',
  ];

  final List<String> _suporteSocialQuestions = [
    'Você sentiu falta de apoio da família?',
    'Você sentiu falta de apoio de seus amigos?',
    'Você teve dificuldades nas relações com seu cônjuge, parceiro ou família próxima?',
  ];

  final List<String> _cognicaoQuestions = [
    'Você teve problemas para se concentrar?',
    'Você teve problemas para lembrar das coisas?',
    'Você teve dificuldades para raciocinar e resolver problemas?',
    'Você teve problemas com sua memória?',
  ];

  final List<String> _comunicacaoQuestions = [
    'Você teve dificuldades para falar?',
    'Você teve dificuldades para se comunicar com outras pessoas?',
    'Você teve problemas para entender o que as pessoas diziam?',
  ];

  final List<String> _desconfortoCorporalQuestions = [
    'Você teve dores e desconfortos musculares?',
    'Você teve câimbras ou espasmos musculares?',
    'Você teve dores ou desconfortos incomuns em qualquer parte do seu corpo?',
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
        },
        resultado: 'Total: ${_data.percentualTotal.toStringAsFixed(1)}% - ${_data.interpretation}',
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

  Widget _buildDimensionSlider(String title, List<int> items, List<String> questions, String dimensionName) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: ExpansionTile(
        title: Text('$title (${items.length} itens)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        children: [
          ...List.generate(items.length, (i) => _buildRadioItem(
            questions[i], // Use a pergunta completa ao invés de "Item X"
            items[i],
            const ['Nunca (0)', 'Ocasionalmente (1)', 'Às vezes (2)', 'Frequentemente (3)', 'Sempre/Não consigo (4)'],
            (val) => setState(() => items[i] = val),
          )),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String question, int value, List<String> options, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ...options.asMap().entries.map((entry) => RadioListTile<int>(
              title: Text(entry.value, style: const TextStyle(fontSize: 12)),
              value: entry.key,
              groupValue: value,
              onChanged: (val) => onChanged(val ?? 0),
              activeColor: Colors.pink,
              dense: true,
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final percentual = _data.percentualTotal;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDQ-39 - Parkinson\'s Disease Questionnaire'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'PDQ-39 - Questionário de Qualidade de Vida (39 itens)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Avalie cada item de 0 (nunca) a 4 (sempre ou não consigo)',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildDimensionSlider('Mobilidade', _data.mobilidade, _mobilidadeQuestions, 'mobilidade'),
          _buildDimensionSlider('Atividades de Vida Diária', _data.atividadesVidaDiaria, _atividadesVidaDiariaQuestions, 'atividadesVidaDiaria'),
          _buildDimensionSlider('Bem-estar Emocional', _data.bemEstarEmocional, _bemEstarEmocionalQuestions, 'bemEstarEmocional'),
          _buildDimensionSlider('Estigma', _data.estigma, _estigmaQuestions, 'estigma'),
          _buildDimensionSlider('Suporte Social', _data.suporteSocial, _suporteSocialQuestions, 'suporteSocial'),
          _buildDimensionSlider('Cognição', _data.cognicao, _cognicaoQuestions, 'cognicao'),
          _buildDimensionSlider('Comunicação', _data.comunicacao, _comunicacaoQuestions, 'comunicacao'),
          _buildDimensionSlider('Desconforto Corporal', _data.desconfortoCorporal, _desconfortoCorporalQuestions, 'desconfortoCorporal'),
          const SizedBox(height: 16),
          Card(
            color: percentual <= 25 ? Colors.green : percentual <= 50 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('PDQ-39: ${percentual.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Mobilidade: ${_data.percentualMobilidade.toStringAsFixed(1)}% | AVD: ${_data.percentualAtividadesVidaDiaria.toStringAsFixed(1)}%\nEmocional: ${_data.percentualBemEstarEmocional.toStringAsFixed(1)}% | Estigma: ${_data.percentualEstigma.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 11, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarPDQ39();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala PDQ-39'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
