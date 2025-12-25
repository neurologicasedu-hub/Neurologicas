import 'package:flutter/material.dart';
import '../models/nmss_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class NMSSScreen extends StatefulWidget {
  const NMSSScreen({super.key});

  @override
  State<NMSSScreen> createState() => _NMSSScreenState();
}

class _NMSSScreenState extends State<NMSSScreen> {
  final NMSSData _data = NMSSData();

  Future<void> _salvarNMSS() async {
    try {
      final score = CompletedScore(
        scoreName: 'NMSS (Non-Motor Symptoms Scale)',
        scoreData: {
          'scoreCardiovascular': _data.scoreCardiovascular,
          'scoreSonoFadiga': _data.scoreSonoFadiga,
          'scoreHumorCognicao': _data.scoreHumorCognicao,
          'scorePercepcao': _data.scorePercepcao,
          'scoreAtencaoMemoria': _data.scoreAtencaoMemoria,
          'scoreGastrointestinal': _data.scoreGastrointestinal,
          'scoreUrinario': _data.scoreUrinario,
          'scoreSexual': _data.scoreSexual,
          'scoreMiscelanea': _data.scoreMiscelanea,
        },
        resultado: 'Total: ${_data.totalScore} - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala NMSS salva com sucesso!'),
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

  Widget _buildItemSlider(String title, NMSSItem item, ValueChanged<NMSSItem> onChanged) {
    final score = item.score;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text('Frequência:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                Text(
                  item.frequencia == 1 ? 'Nunca' : 
                  item.frequencia == 2 ? 'Raramente' : 
                  item.frequencia == 3 ? 'Às vezes' : 'Frequentemente',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text('${item.frequencia}/4', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: item.frequencia.toDouble(),
              min: 1,
              max: 4,
              divisions: 3,
              label: item.frequencia == 1 ? 'Nunca' : 
                     item.frequencia == 2 ? 'Raramente' : 
                     item.frequencia == 3 ? 'Às vezes' : 'Frequentemente',
              onChanged: (val) {
                final novoItem = NMSSItem(frequencia: val.toInt(), severidade: item.severidade);
                onChanged(novoItem);
              },
              activeColor: Colors.lightBlue.shade300,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text('Severidade:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                Text(
                  item.severidade == 0 ? 'Nenhuma' : 
                  item.severidade == 1 ? 'Leve' : 
                  item.severidade == 2 ? 'Moderada' : 'Grave',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text('${item.severidade}/3', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: item.severidade.toDouble(),
              min: 0,
              max: 3,
              divisions: 3,
              label: item.severidade == 0 ? 'Nenhuma' : 
                     item.severidade == 1 ? 'Leve' : 
                     item.severidade == 2 ? 'Moderada' : 'Grave',
              onChanged: (val) {
                final novoItem = NMSSItem(frequencia: item.frequencia, severidade: val.toInt());
                onChanged(novoItem);
              },
              activeColor: Colors.lightBlue.shade600,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Score: Frequência × Severidade =', style: TextStyle(fontSize: 12)),
                  Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('NMSS - Non-Motor Symptoms Scale'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'NMSS - Escala de Sintomas Não Motores (30 itens, 9 domínios)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Para cada item: Frequência (1-4) × Severidade (0-3) = Score 0-12',
            style: TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Cardiovascular (Score: ${_data.scoreCardiovascular}/12)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildItemSlider('Tontura/Déficit cardiovascular', _data.cardiovascular, (item) => setState(() => _data.cardiovascular = item)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Sono/Fadiga (Score: ${_data.scoreSonoFadiga}/48)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildItemSlider('Insônia', _data.sonoInsonia, (item) => setState(() => _data.sonoInsonia = item)),
                _buildItemSlider('Sonolência Diurna', _data.sonoSonolencia, (item) => setState(() => _data.sonoSonolencia = item)),
                _buildItemSlider('Síndrome das Pernas Inquietas', _data.sonoRls, (item) => setState(() => _data.sonoRls = item)),
                _buildItemSlider('Fadiga', _data.fadiga, (item) => setState(() => _data.fadiga = item)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Humor/Cognição (Score: ${_data.scoreHumorCognicao}/72)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildItemSlider('Interesse/Motivação', _data.interesseMotivacao, (item) => setState(() => _data.interesseMotivacao = item)),
                _buildItemSlider('Prazer', _data.prazer, (item) => setState(() => _data.prazer = item)),
                _buildItemSlider('Depressão', _data.depressao, (item) => setState(() => _data.depressao = item)),
                _buildItemSlider('Ansiedade', _data.ansiedade, (item) => setState(() => _data.ansiedade = item)),
                _buildItemSlider('Delusão', _data.delusao, (item) => setState(() => _data.delusao = item)),
                _buildItemSlider('Alucinação', _data.alucinacao, (item) => setState(() => _data.alucinacao = item)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Percepção (Score: ${_data.scorePercepcao}/24)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildItemSlider('Visão', _data.visao, (item) => setState(() => _data.visao = item)),
                _buildItemSlider('Delusão/Alucinação', _data.delusaoAlucinacao, (item) => setState(() => _data.delusaoAlucinacao = item)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Atenção/Memória (Score: ${_data.scoreAtencaoMemoria}/36)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildItemSlider('Concentração', _data.concentracao, (item) => setState(() => _data.concentracao = item)),
                _buildItemSlider('Memória', _data.memoria, (item) => setState(() => _data.memoria = item)),
                _buildItemSlider('Esquecimento', _data.esquecimento, (item) => setState(() => _data.esquecimento = item)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Gastrointestinal (Score: ${_data.scoreGastrointestinal}/36)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildItemSlider('Salivação', _data.salivacao, (item) => setState(() => _data.salivacao = item)),
                _buildItemSlider('Deglutição', _data.degluticao, (item) => setState(() => _data.degluticao = item)),
                _buildItemSlider('Náusea', _data.nausea, (item) => setState(() => _data.nausea = item)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Urinário (Score: ${_data.scoreUrinario}/36)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildItemSlider('Frequência Urinária', _data.urinaFrequencia, (item) => setState(() => _data.urinaFrequencia = item)),
                _buildItemSlider('Noctúria', _data.urinaNocturia, (item) => setState(() => _data.urinaNocturia = item)),
                _buildItemSlider('Incontinência', _data.urinaIncontinencia, (item) => setState(() => _data.urinaIncontinencia = item)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Sexual (Score: ${_data.scoreSexual}/24)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildItemSlider('Interesse Sexual', _data.sexualInteresse, (item) => setState(() => _data.sexualInteresse = item)),
                _buildItemSlider('Disfunção Sexual', _data.sexualDisfuncao, (item) => setState(() => _data.sexualDisfuncao = item)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Miscelânea (Score: ${_data.scoreMiscelanea}/72)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildItemSlider('Dor', _data.dor, (item) => setState(() => _data.dor = item)),
                _buildItemSlider('Perda de Olfato', _data.perdaOlfato, (item) => setState(() => _data.perdaOlfato = item)),
                _buildItemSlider('Peso', _data.peso, (item) => setState(() => _data.peso = item)),
                _buildItemSlider('Suor', _data.suor, (item) => setState(() => _data.suor = item)),
                _buildItemSlider('Quedas', _data.quedas, (item) => setState(() => _data.quedas = item)),
                _buildItemSlider('Sialorreia', _data.sialorreia, (item) => setState(() => _data.sialorreia = item)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: score <= 20 ? Colors.green : score <= 40 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('NMSS Total: $score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarNMSS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala NMSS'),
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
              backgroundColor: Colors.lightBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}