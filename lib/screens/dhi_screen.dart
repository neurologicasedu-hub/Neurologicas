import 'package:flutter/material.dart';
import '../models/dhi_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class DHIScreen extends StatefulWidget {
  const DHIScreen({super.key});

  @override
  State<DHIScreen> createState() => _DHIScreenState();
}

class _DHIScreenState extends State<DHIScreen> {
  final DHIData _data = DHIData();

  final List<String> _options = ['Não (0)', 'Às vezes (2)', 'Sim (4)'];
  final List<int> _values = [0, 2, 4];

  // Helper method to set value
  void _setVal(String field, int val) {
    setState(() {
       switch(field) {
         case 'caminhar': _data.dificuldadeCaminhar = val; break;
         case 'fisicas': _data.dificuldadeAtividadesFisicas = val; break;
         case 'trabalho': _data.dificuldadeTrabalho = val; break;
         case 'leitura': _data.dificuldadeLeitura = val; break;
         case 'domesticas': _data.dificuldadeTarefasDomesticas = val; break;
         case 'recreacao': _data.dificuldadeRecreacao = val; break;
         case 'viagens': _data.dificuldadeViagens = val; break;
         case 'alimentacao': _data.dificuldadeAlimentacao = val; break;
         case 'transporte': _data.dificuldadeTransporte = val; break;
         case 'ansioso': _data.deixarAnsioso = val; break;
         case 'frustrado': _data.deixarFrustrado = val; break;
         case 'irritado': _data.deixarIrritado = val; break;
         case 'embaracado': _data.deixarEmbaracado = val; break;
         case 'deprimido': _data.deixarDeprimido = val; break;
         case 'autoconfianca': _data.afetarAutoconfianca = val; break;
         case 'relacionamentos': _data.afetarRelacionamentos = val; break;
         case 'medoQueda': _data.medoQueda = val; break;
         case 'saude': _data.preocupacaoSaude = val; break;
         case 'virarCabeca': _data.pioraVirarCabeca = val; break;
         case 'olharCima': _data.pioraOlharCima = val; break;
         case 'levantar': _data.pioraLevantarRapido = val; break;
         case 'virarCama': _data.pioraVirarNaCama = val; break;
         case 'curvar': _data.pioraAoCurvar = val; break;
         case 'pioraCaminhar': _data.pioraAoCaminhar = val; break;
         case 'exercitar': _data.pioraAoExercitar = val; break;
       }
    });
  }

  Future<void> _salvarDHI() async {
    try {
      final score = CompletedScore(
        scoreName: 'Dizziness Handicap Inventory (DHI)',
        scoreData: {
          'dificuldadeCaminhar': _data.dificuldadeCaminhar,
          'dificuldadeAtividadesFisicas': _data.dificuldadeAtividadesFisicas,
          'dificuldadeTrabalho': _data.dificuldadeTrabalho,
          'dificuldadeLeitura': _data.dificuldadeLeitura,
          'dificuldadeTarefasDomesticas': _data.dificuldadeTarefasDomesticas,
          'dificuldadeRecreacao': _data.dificuldadeRecreacao,
          'dificuldadeViagens': _data.dificuldadeViagens,
          'dificuldadeAlimentacao': _data.dificuldadeAlimentacao,
          'dificuldadeTransporte': _data.dificuldadeTransporte,
          'deixarAnsioso': _data.deixarAnsioso,
          'deixarFrustrado': _data.deixarFrustrado,
          'deixarIrritado': _data.deixarIrritado,
          'deixarEmbaracado': _data.deixarEmbaracado,
          'deixarDeprimido': _data.deixarDeprimido,
          'afetarAutoconfianca': _data.afetarAutoconfianca,
          'afetarRelacionamentos': _data.afetarRelacionamentos,
          'medoQueda': _data.medoQueda,
          'preocupacaoSaude': _data.preocupacaoSaude,
          'pioraVirarCabeca': _data.pioraVirarCabeca,
          'pioraOlharCima': _data.pioraOlharCima,
          'pioraLevantarRapido': _data.pioraLevantarRapido,
          'pioraVirarNaCama': _data.pioraVirarNaCama,
          'pioraAoCurvar': _data.pioraAoCurvar,
          'pioraAoCaminhar': _data.pioraAoCaminhar,
          'pioraAoExercitar': _data.pioraAoExercitar,
        },
        resultado: 'Total: ${_data.totalScore} - ${_data.interpretacao}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala DHI salva com sucesso!'),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Widget _buildQ(String title, int val, String key) {
    final currentLabel = _options[_values.indexOf(val)];
    return QuestionCard<String>(
       title: title,
       options: _options.map((e) => QuestionOption(label: e, value: e)).toList(),
       value: currentLabel,
       onChanged: (v) => _setVal(key, _values[_options.indexOf(v)]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scoreTotal = _data.totalScore;
    return CalculatorScaffold(
      title: 'DHI',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Dizziness Handicap Inventory\nAvalie o impacto da tontura',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

          const Padding(
             padding: EdgeInsets.symmetric(vertical: 8),
             child: Text('Funcional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple)),
          ),
          _buildQ('Sua tontura interfere quando caminha?', _data.dificuldadeCaminhar, 'caminhar'),
          _buildQ('Sua tontura interfere em atividades físicas?', _data.dificuldadeAtividadesFisicas, 'fisicas'),
          _buildQ('Sua tontura interfere no trabalho/responsabilidades?', _data.dificuldadeTrabalho, 'trabalho'),
          _buildQ('Sua tontura interfere na leitura?', _data.dificuldadeLeitura, 'leitura'),
          _buildQ('Sua tontura interfere em tarefas domésticas?', _data.dificuldadeTarefasDomesticas, 'domesticas'),
          _buildQ('Sua tontura interfere em atividades recreativas?', _data.dificuldadeRecreacao, 'recreacao'),
          _buildQ('Sua tontura interfere em viagens?', _data.dificuldadeViagens, 'viagens'),
          _buildQ('Sua tontura interfere na alimentação?', _data.dificuldadeAlimentacao, 'alimentacao'),
          _buildQ('Sua tontura interfere no uso de transporte?', _data.dificuldadeTransporte, 'transporte'),

          const Padding(
             padding: EdgeInsets.symmetric(vertical: 8),
             child: Text('Emocional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple)),
          ),
          _buildQ('Sua tontura o deixa ansioso?', _data.deixarAnsioso, 'ansioso'),
          _buildQ('Sua tontura o deixa frustrado?', _data.deixarFrustrado, 'frustrado'),
          _buildQ('Sua tontura o deixa irritado?', _data.deixarIrritado, 'irritado'),
          _buildQ('Sua tontura o deixa embaraçado?', _data.deixarEmbaracado, 'embaracado'),
          _buildQ('Sua tontura o deixa deprimido?', _data.deixarDeprimido, 'deprimido'),
          _buildQ('Sua tontura afeta sua autoconfiança?', _data.afetarAutoconfianca, 'autoconfianca'),
          _buildQ('Sua tontura afeta relacionamentos?', _data.afetarRelacionamentos, 'relacionamentos'),
          _buildQ('Tem medo de cair devido à tontura?', _data.medoQueda, 'medoQueda'),
          _buildQ('Preocupado com saúde devido à tontura?', _data.preocupacaoSaude, 'saude'),

          const Padding(
             padding: EdgeInsets.symmetric(vertical: 8),
             child: Text('Físico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple)),
          ),
          _buildQ('Piora ao virar a cabeça rápido?', _data.pioraVirarCabeca, 'virarCabeca'),
          _buildQ('Piora ao olhar para cima?', _data.pioraOlharCima, 'olharCima'),
          _buildQ('Piora ao levantar rápido?', _data.pioraLevantarRapido, 'levantar'),
          _buildQ('Piora ao virar na cama?', _data.pioraVirarNaCama, 'virarCama'),
          _buildQ('Piora ao se curvar?', _data.pioraAoCurvar, 'curvar'),
          _buildQ('Piora ao caminhar?', _data.pioraAoCaminhar, 'pioraCaminhar'),
          _buildQ('Piora ao se exercitar?', _data.pioraAoExercitar, 'exercitar'),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scoreTotal <= 30 ? Colors.green : scoreTotal <= 60 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (scoreTotal <= 30 ? Colors.green : scoreTotal <= 60 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('DHI TOTAL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                 const SizedBox(height: 8),
                Text('$scoreTotal', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 8),
                Text('F:${_data.scoreFuncional}  E:${_data.scoreEmocional}  Fi:${_data.scoreFisico}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 12),
                Text(_data.interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarDHI,
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}