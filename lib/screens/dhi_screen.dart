import 'package:flutter/material.dart';
import '../models/dhi_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class DHIScreen extends StatefulWidget {
  const DHIScreen({super.key});

  @override
  State<DHIScreen> createState() => _DHIScreenState();
}

class _DHIScreenState extends State<DHIScreen> {
  final DHIData _data = DHIData();

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
        resultado: 'Funcional: ${_data.scoreFuncional} | Emocional: ${_data.scoreEmocional} | Físico: ${_data.scoreFisico} - ${_data.interpretacao}',
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

  Widget _buildRadioItem(String title, int value, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            RadioListTile<int>(
              title: const Text('Sim (4 pontos)', style: TextStyle(fontSize: 12)),
              value: 4,
              groupValue: value,
              onChanged: (val) => onChanged(val ?? 0),
              activeColor: Colors.purple,
              dense: true,
            ),
            RadioListTile<int>(
              title: const Text('Às vezes (2 pontos)', style: TextStyle(fontSize: 12)),
              value: 2,
              groupValue: value,
              onChanged: (val) => onChanged(val ?? 0),
              activeColor: Colors.purple,
              dense: true,
            ),
            RadioListTile<int>(
              title: const Text('Não (0 pontos)', style: TextStyle(fontSize: 12)),
              value: 0,
              groupValue: value,
              onChanged: (val) => onChanged(val ?? 0),
              activeColor: Colors.purple,
              dense: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scoreTotal = _data.totalScore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dizziness Handicap Inventory'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Dizziness Handicap Inventory (DHI)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Avalie como sua tontura/vertigem afeta sua vida diária.\nResponda: Sim (4), Às vezes (2), ou Não (0)',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Domínio Funcional (9 perguntas)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.purple),
          ),
          const SizedBox(height: 8),
          _buildRadioItem('Sua tontura interfere quando você caminha?', _data.dificuldadeCaminhar, (val) => setState(() => _data.dificuldadeCaminhar = val)),
          _buildRadioItem('Sua tontura interfere em suas atividades físicas?', _data.dificuldadeAtividadesFisicas, (val) => setState(() => _data.dificuldadeAtividadesFisicas = val)),
          _buildRadioItem('Sua tontura interfere no seu trabalho ou em suas responsabilidades?', _data.dificuldadeTrabalho, (val) => setState(() => _data.dificuldadeTrabalho = val)),
          _buildRadioItem('Sua tontura interfere na sua capacidade de ler?', _data.dificuldadeLeitura, (val) => setState(() => _data.dificuldadeLeitura = val)),
          _buildRadioItem('Sua tontura interfere na realização de tarefas domésticas?', _data.dificuldadeTarefasDomesticas, (val) => setState(() => _data.dificuldadeTarefasDomesticas = val)),
          _buildRadioItem('Sua tontura interfere em suas atividades recreativas?', _data.dificuldadeRecreacao, (val) => setState(() => _data.dificuldadeRecreacao = val)),
          _buildRadioItem('Sua tontura interfere quando você viaja?', _data.dificuldadeViagens, (val) => setState(() => _data.dificuldadeViagens = val)),
          _buildRadioItem('Sua tontura interfere quando você come?', _data.dificuldadeAlimentacao, (val) => setState(() => _data.dificuldadeAlimentacao = val)),
          _buildRadioItem('Sua tontura interfere quando você usa meios de transporte (ônibus, carro, etc.)?', _data.dificuldadeTransporte, (val) => setState(() => _data.dificuldadeTransporte = val)),
          const SizedBox(height: 12),
          const Text(
            'Domínio Emocional (9 perguntas)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.purple),
          ),
          const SizedBox(height: 8),
          _buildRadioItem('Sua tontura o deixa ansioso ou preocupado?', _data.deixarAnsioso, (val) => setState(() => _data.deixarAnsioso = val)),
          _buildRadioItem('Sua tontura o deixa frustrado?', _data.deixarFrustrado, (val) => setState(() => _data.deixarFrustrado = val)),
          _buildRadioItem('Sua tontura o deixa irritado?', _data.deixarIrritado, (val) => setState(() => _data.deixarIrritado = val)),
          _buildRadioItem('Sua tontura o deixa embaraçado?', _data.deixarEmbaracado, (val) => setState(() => _data.deixarEmbaracado = val)),
          _buildRadioItem('Sua tontura o deixa deprimido?', _data.deixarDeprimido, (val) => setState(() => _data.deixarDeprimido = val)),
          _buildRadioItem('Sua tontura afeta sua autoconfiança?', _data.afetarAutoconfianca, (val) => setState(() => _data.afetarAutoconfianca = val)),
          _buildRadioItem('Sua tontura afeta seus relacionamentos familiares ou sociais?', _data.afetarRelacionamentos, (val) => setState(() => _data.afetarRelacionamentos = val)),
          _buildRadioItem('Você tem medo de cair devido à sua tontura?', _data.medoQueda, (val) => setState(() => _data.medoQueda = val)),
          _buildRadioItem('Você fica preocupado com sua saúde devido à tontura?', _data.preocupacaoSaude, (val) => setState(() => _data.preocupacaoSaude = val)),
          const SizedBox(height: 12),
          const Text(
            'Domínio Físico (7 perguntas)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.purple),
          ),
          const SizedBox(height: 8),
          _buildRadioItem('Sua tontura piora quando você vira a cabeça rapidamente?', _data.pioraVirarCabeca, (val) => setState(() => _data.pioraVirarCabeca = val)),
          _buildRadioItem('Sua tontura piora quando você olha para cima?', _data.pioraOlharCima, (val) => setState(() => _data.pioraOlharCima = val)),
          _buildRadioItem('Sua tontura piora quando você se levanta rapidamente?', _data.pioraLevantarRapido, (val) => setState(() => _data.pioraLevantarRapido = val)),
          _buildRadioItem('Sua tontura piora quando você vira na cama?', _data.pioraVirarNaCama, (val) => setState(() => _data.pioraVirarNaCama = val)),
          _buildRadioItem('Sua tontura piora quando você se curva?', _data.pioraAoCurvar, (val) => setState(() => _data.pioraAoCurvar = val)),
          _buildRadioItem('Sua tontura piora quando você caminha?', _data.pioraAoCaminhar, (val) => setState(() => _data.pioraAoCaminhar = val)),
          _buildRadioItem('Sua tontura piora quando você se exercita?', _data.pioraAoExercitar, (val) => setState(() => _data.pioraAoExercitar = val)),
          const SizedBox(height: 16),
          Card(
            color: scoreTotal <= 30 ? Colors.green : scoreTotal <= 60 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Funcional: ${_data.scoreFuncional} | Emocional: ${_data.scoreEmocional} | Físico: ${_data.scoreFisico}',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'DHI Score Total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$scoreTotal/100',
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _data.interpretacao,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarDHI();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala DHI'),
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
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}