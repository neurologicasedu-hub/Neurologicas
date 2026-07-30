import 'package:flutter/material.dart';
import '../models/npi_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class NPIScreen extends StatefulWidget {
  const NPIScreen({super.key});

  @override
  State<NPIScreen> createState() => _NPIScreenState();
}

class _NPIScreenState extends State<NPIScreen> {
  final NPIData _data = NPIData();

  final List<Map<String, dynamic>> _domains = [
    {'title': 'Delírios', 'description': 'Crenças falsas, ideias de perseguição'},
    {'title': 'Alucinações', 'description': 'Ver ou ouvir coisas que não existem'},
    {'title': 'Agitação/Agressividade', 'description': 'Comportamento agressivo, resistência'},
    {'title': 'Depressão/Disforia', 'description': 'Tristeza, choro, desânimo'},
    {'title': 'Ansiedade', 'description': 'Preocupação excessiva, tensão'},
    {'title': 'Euforia/Elevação', 'description': 'Alegria excessiva ou inadequada'},
    {'title': 'Apatia/Indiferença', 'description': 'Falta de interesse ou emoção'},
    {'title': 'Desinibição', 'description': 'Comportamento socialmente inadequado'},
    {'title': 'Irritabilidade/Labilidade', 'description': 'Mudanças rápidas de humor, impaciência'},
    {'title': 'Comportamento Motor', 'description': 'Atividades repetitivas, andar sem rumo'},
    {'title': 'Sono/Comportamento Noturno', 'description': 'Insônia, perambulação noturna'},
    {'title': 'Apetite/Alimentação', 'description': 'Mudanças no apetite ou preferências'},
  ];

  final List<String> _frequenciaOptions = ['Não (0)', 'Ocasional (1)', 'Freq. (2)', 'Muito Freq. (3)', 'Constante (4)'];
  final List<String> _severidadeOptions = ['Não (0)', 'Leve (1)', 'Moderada (2)', 'Grave (3)'];

  Future<void> _salvarNPI() async {
    try {
      final score = CompletedScore(
        scoreName: 'Neuropsychiatric Inventory (NPI)',
        scoreData: {
          'delusaoFreq': _data.delusao.frequencia, 'delusaoSev': _data.delusao.severidade,
          'alucinacoesFreq': _data.alucinacoes.frequencia, 'alucinacoesSev': _data.alucinacoes.severidade,
          'agitacaoFreq': _data.agitacao.frequencia, 'agitacaoSev': _data.agitacao.severidade,
          'depressaoFreq': _data.depressao.frequencia, 'depressaoSev': _data.depressao.severidade,
          'ansiedadeFreq': _data.ansiedade.frequencia, 'ansiedadeSev': _data.ansiedade.severidade,
          'euforiaFreq': _data.euforia.frequencia, 'euforiaSev': _data.euforia.severidade,
          'apatiaFreq': _data.apatia.frequencia, 'apatiaSev': _data.apatia.severidade,
          'desinibicaoFreq': _data.desinibicao.frequencia, 'desinibicaoSev': _data.desinibicao.severidade,
          'irritabilidadeFreq': _data.irritabilidade.frequencia, 'irritabilidadeSev': _data.irritabilidade.severidade,
          'comportamentoMotorFreq': _data.comportamentoMotor.frequencia, 'comportamentoMotorSev': _data.comportamentoMotor.severidade,
          'sonoFreq': _data.sono.frequencia, 'sonoSev': _data.sono.severidade,
          'apetiteFreq': _data.apetite.frequencia, 'apetiteSev': _data.apetite.severidade,
        },
        resultado: '${_data.totalScore}/144 - ${_data.interpretation} (${_data.numeroSintomas} sintomas)',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala NPI salva com sucesso!'),
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

  Widget _buildDomainItem(int index, Map<String, dynamic> domain, NPIDomain item, ValueChanged<NPIDomain> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: ExpansionTile(
        title: Text('${index + 1}. ${domain['title']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text('Score: ${item.score}/12', style: TextStyle(fontSize: 12, color: item.presente ? Colors.orange.shade800 : Colors.grey)),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(domain['description'], style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                const SizedBox(height: 12),
                
                // Frequency
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Frequência (0-4)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(_frequenciaOptions[item.frequencia], style: TextStyle(fontSize: 12, color: Colors.blue.shade700)),
                  ],
                ),
                SliderTheme(
                   data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.blue, thumbColor: Colors.blue),
                   child: Slider(
                    value: item.frequencia.toDouble(),
                    min: 0, max: 4, divisions: 4,
                    onChanged: (val) => onChanged(NPIDomain(frequencia: val.toInt(), severidade: item.severidade)),
                  ),
                ),

                // Severity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Severidade (0-3)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(_severidadeOptions[item.severidade], style: TextStyle(fontSize: 12, color: Colors.red.shade700)),
                  ],
                ),
                SliderTheme(
                   data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.red, thumbColor: Colors.red),
                   child: Slider(
                    value: item.severidade.toDouble(),
                    min: 0, max: 3, divisions: 3,
                    onChanged: (val) => onChanged(NPIDomain(frequencia: item.frequencia, severidade: val.toInt())),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text('Score = Freq x Sev = ${item.score}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'NPI',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Neuropsychiatric Inventory\nAvalie Frequência (0-4) e Severidade (0-3)',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          
          ...List.generate(12, (i) {
             final items = [
              _data.delusao, _data.alucinacoes, _data.agitacao, _data.depressao,
              _data.ansiedade, _data.euforia, _data.apatia, _data.desinibicao,
              _data.irritabilidade, _data.comportamentoMotor, _data.sono, _data.apetite,
            ];
            final setters = [
              (v) => setState(() => _data.delusao = v),
              (v) => setState(() => _data.alucinacoes = v),
              (v) => setState(() => _data.agitacao = v),
              (v) => setState(() => _data.depressao = v),
              (v) => setState(() => _data.ansiedade = v),
              (v) => setState(() => _data.euforia = v),
              (v) => setState(() => _data.apatia = v),
              (v) => setState(() => _data.desinibicao = v),
              (v) => setState(() => _data.irritabilidade = v),
              (v) => setState(() => _data.comportamentoMotor = v),
              (v) => setState(() => _data.sono = v),
              (v) => setState(() => _data.apetite = v),
            ];
            return _buildDomainItem(i, _domains[i], items[i], setters[i]);
          }),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score == 0 ? Colors.green : score <= 24 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score == 0 ? Colors.green : score <= 24 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('NPI TOTAL SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$score', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 8),
                Text('Sintomas presentes: ${_data.numeroSintomas}/12', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 12),
                Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarNPI,
        backgroundColor: Colors.orange.shade800,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
