import 'package:flutter/material.dart';
import '../models/rmi_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class RMIScreen extends StatefulWidget {
  const RMIScreen({super.key});

  @override
  State<RMIScreen> createState() => _RMIScreenState();
}

class _RMIScreenState extends State<RMIScreen> {
  final RMIData _data = RMIData();

  Future<void> _salvarRMI() async {
    try {
      final score = CompletedScore(
        scoreName: 'Rivermead Mobility Index (RMI)',
        scoreData: {
          'girar': _data.girar,
          'sentar': _data.sentar,
          'levantar': _data.levantar,
          'manterEmPe': _data.manterEmPe,
          'transferirCamaCadeira': _data.transferirCamaCadeira,
          'caminhar10m': _data.caminhar10m,
          'caminhar10mSemAjuda': _data.caminhar10mSemAjuda,
          'subirEscadas': _data.subirEscadas,
          'permanecerEmPeSemAjuda': _data.permanecerEmPeSemAjuda,
          'sentarSemAjuda': _data.sentarSemAjuda,
          'levantarSemAjuda': _data.levantarSemAjuda,
          'caminharFora': _data.caminharFora,
          'caminhar5min': _data.caminhar5min,
          'levantarChao': _data.levantarChao,
          'subir4Degraus': _data.subir4Degraus,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala RMI salva com sucesso!'),
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
    final interpretacao = _data.interpretacao;

    return CalculatorScaffold(
      title: 'Rivermead Mobility Index',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Avaliação Funcional de Mobilidade\n(0 = Não, 1 = Sim)',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildQuestion('Girar de decúbito dorsal para lateral?', _data.girar, (v) => setState(() => _data.girar = v)),
          _buildQuestion('Sentar-se na beira da cama?', _data.sentar, (v) => setState(() => _data.sentar = v)),
          _buildQuestion('Manter-se sentado na cama?', _data.levantar, (v) => setState(() => _data.levantar = v)), 
          // Note: Variable names in RMIData seem slightly confusing (levantar for "sitting balance"?). 
          // Checking original code: "_buildItem('Manter-se sentado na beira da cama', _data.levantar...)"
          // And "_buildItem('Levantar-se sem ajuda', _data.levantarSemAjuda...)".
          // I will assume the variable mapping is correct from previous file content.
          _buildQuestion('Manter-se em pé (10s)?', _data.manterEmPe, (v) => setState(() => _data.manterEmPe = v)),
          _buildQuestion('Transferir cama -> cadeira?', _data.transferirCamaCadeira, (v) => setState(() => _data.transferirCamaCadeira = v)),
          _buildQuestion('Caminhar 10m (com ajuda)?', _data.caminhar10m, (v) => setState(() => _data.caminhar10m = v)),
          _buildQuestion('Caminhar 10m (SEM ajuda)?', _data.caminhar10mSemAjuda, (v) => setState(() => _data.caminhar10mSemAjuda = v)),
          _buildQuestion('Subir/descer escada?', _data.subirEscadas, (v) => setState(() => _data.subirEscadas = v)),
          _buildQuestion('Em pé sem ajuda (10s)?', _data.permanecerEmPeSemAjuda, (v) => setState(() => _data.permanecerEmPeSemAjuda = v)),
          _buildQuestion('Sentar-se deitado (sem ajuda)?', _data.sentarSemAjuda, (v) => setState(() => _data.sentarSemAjuda = v)),
          _buildQuestion('Levantar sem ajuda?', _data.levantarSemAjuda, (v) => setState(() => _data.levantarSemAjuda = v)),
          _buildQuestion('Caminhar fora (terreno irregular)?', _data.caminharFora, (v) => setState(() => _data.caminharFora = v)),
          _buildQuestion('Caminhar 5 minutos?', _data.caminhar5min, (v) => setState(() => _data.caminhar5min = v)),
          _buildQuestion('Levantar objeto do chão?', _data.levantarChao, (v) => setState(() => _data.levantarChao = v)),
          _buildQuestion('Subir 4 degraus sem ajuda?', _data.subir4Degraus, (v) => setState(() => _data.subir4Degraus = v)),

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
                const Text('PONTUAÇÃO TOTAL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score/15',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 12),
                 Text(
                  interpretacao,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarRMI,
        backgroundColor: Colors.blueGrey,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildQuestion(String title, int value, ValueChanged<int> onChanged) {
      return QuestionCard<int>(
        title: title,
        value: value,
        onChanged: onChanged,
        options: const [
          QuestionOption(label: 'Sim', value: 1),
          QuestionOption(label: 'Não', value: 0),
        ],
      );
  }

  Color _getScoreColor(int score) {
    if (score >= 13) return Colors.green;
    if (score >= 10) return Colors.lightGreen;
    if (score >= 7) return Colors.orange;
    return Colors.red;
  }
}
