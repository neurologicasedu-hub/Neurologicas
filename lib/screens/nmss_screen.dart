import 'package:flutter/material.dart';
import '../models/nmss_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

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

  Widget _buildItemSlider(String title, NMSSItem item, ValueChanged<NMSSItem> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          
          // Frequency Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Frequência: ${item.frequencia}/4', style: const TextStyle(fontSize: 12)),
              Text(
                  item.frequencia == 1 ? 'Nunca' : 
                  item.frequencia == 2 ? 'Raramente' : 
                  item.frequencia == 3 ? 'Às vezes' : 'Sempre',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.blue.shade300, thumbColor: Colors.blue.shade300, trackHeight: 3),
            child: Slider(
              value: item.frequencia.toDouble(),
              min: 1, max: 4, divisions: 3,
              onChanged: (val) => onChanged(NMSSItem(frequencia: val.toInt(), severidade: item.severidade)),
            ),
          ),

          // Severity Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text('Severidade: ${item.severidade}/3', style: const TextStyle(fontSize: 12)),
               Text(
                  item.severidade == 0 ? 'Nenhuma' : 
                  item.severidade == 1 ? 'Leve' : 
                  item.severidade == 2 ? 'Moderada' : 'Grave',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade900, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.blue.shade700, thumbColor: Colors.blue.shade700, trackHeight: 3),
            child: Slider(
              value: item.severidade.toDouble(),
              min: 0, max: 3, divisions: 3,
              onChanged: (val) => onChanged(NMSSItem(frequencia: item.frequencia, severidade: val.toInt())),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Score: ${item.score}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, int score, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        trailing: Container(
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
             decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
             child: Text('Score: $score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.blue.shade900)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'NMSS',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Non-Motor Symptoms Scale\nScore = Frequência x Severidade',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

          _buildSection('Cardiovascular', _data.scoreCardiovascular, [
             _buildItemSlider('Tontura/Déficit', _data.cardiovascular, (v) => setState(() => _data.cardiovascular = v)),
          ]),
          _buildSection('Sono/Fadiga', _data.scoreSonoFadiga, [
             _buildItemSlider('Insônia', _data.sonoInsonia, (v) => setState(() => _data.sonoInsonia = v)),
             _buildItemSlider('Sonolência', _data.sonoSonolencia, (v) => setState(() => _data.sonoSonolencia = v)),
             _buildItemSlider('Pernas Inquietas', _data.sonoRls, (v) => setState(() => _data.sonoRls = v)),
             _buildItemSlider('Fadiga', _data.fadiga, (v) => setState(() => _data.fadiga = v)),
          ]),
          _buildSection('Humor/Cognição', _data.scoreHumorCognicao, [
             _buildItemSlider('Interesse', _data.interesseMotivacao, (v) => setState(() => _data.interesseMotivacao = v)),
             _buildItemSlider('Prazer', _data.prazer, (v) => setState(() => _data.prazer = v)),
             _buildItemSlider('Depressão', _data.depressao, (v) => setState(() => _data.depressao = v)),
             _buildItemSlider('Ansiedade', _data.ansiedade, (v) => setState(() => _data.ansiedade = v)),
             _buildItemSlider('Delusão', _data.delusao, (v) => setState(() => _data.delusao = v)),
             _buildItemSlider('Alucinação', _data.alucinacao, (v) => setState(() => _data.alucinacao = v)),
          ]),
          _buildSection('Percepção', _data.scorePercepcao, [
             _buildItemSlider('Visão', _data.visao, (v) => setState(() => _data.visao = v)),
             _buildItemSlider('Alucinação', _data.delusaoAlucinacao, (v) => setState(() => _data.delusaoAlucinacao = v)),
          ]),
          _buildSection('Atenção/Memória', _data.scoreAtencaoMemoria, [
             _buildItemSlider('Concentração', _data.concentracao, (v) => setState(() => _data.concentracao = v)),
             _buildItemSlider('Memória', _data.memoria, (v) => setState(() => _data.memoria = v)),
             _buildItemSlider('Esquecimento', _data.esquecimento, (v) => setState(() => _data.esquecimento = v)),
          ]),
          _buildSection('Gastrointestinal', _data.scoreGastrointestinal, [
             _buildItemSlider('Salivação', _data.salivacao, (v) => setState(() => _data.salivacao = v)),
             _buildItemSlider('Deglutição', _data.degluticao, (v) => setState(() => _data.degluticao = v)),
             _buildItemSlider('Náusea', _data.nausea, (v) => setState(() => _data.nausea = v)),
          ]),
          _buildSection('Urinário', _data.scoreUrinario, [
             _buildItemSlider('Frequência', _data.urinaFrequencia, (v) => setState(() => _data.urinaFrequencia = v)),
             _buildItemSlider('Noctúria', _data.urinaNocturia, (v) => setState(() => _data.urinaNocturia = v)),
             _buildItemSlider('Incontinência', _data.urinaIncontinencia, (v) => setState(() => _data.urinaIncontinencia = v)),
          ]),
          _buildSection('Sexual', _data.scoreSexual, [
             _buildItemSlider('Interesse', _data.sexualInteresse, (v) => setState(() => _data.sexualInteresse = v)),
             _buildItemSlider('Disfunção', _data.sexualDisfuncao, (v) => setState(() => _data.sexualDisfuncao = v)),
          ]),
          _buildSection('Miscelânea', _data.scoreMiscelanea, [
             _buildItemSlider('Dor', _data.dor, (v) => setState(() => _data.dor = v)),
             _buildItemSlider('Olfato', _data.perdaOlfato, (v) => setState(() => _data.perdaOlfato = v)),
             _buildItemSlider('Peso', _data.peso, (v) => setState(() => _data.peso = v)),
             _buildItemSlider('Suor', _data.suor, (v) => setState(() => _data.suor = v)),
             _buildItemSlider('Quedas', _data.quedas, (v) => setState(() => _data.quedas = v)),
             _buildItemSlider('Sialorreia', _data.sialorreia, (v) => setState(() => _data.sialorreia = v)),
          ]),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 20 ? Colors.green : score <= 40 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 20 ? Colors.green : score <= 40 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('NMSS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 12),
                 Text(
                  _data.interpretation,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarNMSS,
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}