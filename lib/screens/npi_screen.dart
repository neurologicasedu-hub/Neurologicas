import 'package:flutter/material.dart';
import '../models/npi_data.dart';

// NPIDomain é uma classe top-level no arquivo npi_data.dart
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class NPIScreen extends StatefulWidget {
  const NPIScreen({super.key});

  @override
  State<NPIScreen> createState() => _NPIScreenState();
}

class _NPIScreenState extends State<NPIScreen> {
  final NPIData _data = NPIData();

  final List<Map<String, dynamic>> _domains = [
    {'title': 'Delírios', 'description': 'Avalia crenças falsas, ideias de perseguição, etc.'},
    {'title': 'Alucinações', 'description': 'Avalia percepções sensoriais sem estímulo (ver, ouvir coisas)'},
    {'title': 'Agitação/Agressividade', 'description': 'Avalia comportamento agressivo, agitação física'},
    {'title': 'Depressão/Disforia', 'description': 'Avalia tristeza, choro, desânimo'},
    {'title': 'Ansiedade', 'description': 'Avalia preocupação, tensão, nervosismo'},
    {'title': 'Euforia/Elevação do humor', 'description': 'Avalia alegria excessiva, euforia inadequada'},
    {'title': 'Apatia/Indiferença', 'description': 'Avalia falta de interesse, indiferença'},
    {'title': 'Desinibição', 'description': 'Avalia perda de inibição, comportamento inadequado'},
    {'title': 'Irritabilidade/Labilidade', 'description': 'Avalia irritação fácil, mudanças de humor'},
    {'title': 'Perturbação do Comportamento Motor', 'description': 'Avalia comportamentos repetitivos, agitação motora'},
    {'title': 'Distúrbio do Sono e Comportamento Noturno', 'description': 'Avalia insônia, sono fragmentado, comportamento noturno'},
    {'title': 'Alterações do Apetite e Alimentação', 'description': 'Avalia mudanças no apetite, preferências alimentares'},
  ];

  final List<String> _frequenciaOptions = ['Não presente (0)', 'Ocasionalmente (1)', 'Frequentemente (2)', 'Muito frequentemente (3)', 'Constantemente (4)'];
  final List<String> _severidadeOptions = ['Não presente (0)', 'Leve (1)', 'Moderada (2)', 'Grave (3)'];

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
        resultado: '${_data.totalScore}/144 - ${_data.interpretation} (${_data.numeroSintomas} domínios com sintomas)',
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
    final domains = [
      _data.delusao, _data.alucinacoes, _data.agitacao, _data.depressao,
      _data.ansiedade, _data.euforia, _data.apatia, _data.desinibicao,
      _data.irritabilidade, _data.comportamentoMotor, _data.sono, _data.apetite,
    ];
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: ExpansionTile(
        title: Text('${index + 1}. ${domain['title']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        subtitle: Text('Score: ${domains[index].score}/12', style: TextStyle(fontSize: 11, color: domains[index].presente ? Colors.red.shade700 : Colors.grey)),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(domain['description'], style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                const SizedBox(height: 12),
                const Text('Frequência (1-4):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('0', style: TextStyle(fontSize: 10)),
                    Text('${domains[index].frequencia}/4', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    const Text('4', style: TextStyle(fontSize: 10)),
                  ],
                ),
                Slider(
                  value: domains[index].frequencia.toDouble(),
                  min: 0,
                  max: 4,
                  divisions: 4,
                  label: _frequenciaOptions[domains[index].frequencia],
                  onChanged: (val) {
                    final novo = NPIDomain(frequencia: val.toInt(), severidade: domains[index].severidade);
                    onChanged(novo);
                  },
                  activeColor: Colors.blue.shade700,
                ),
                const SizedBox(height: 12),
                const Text('Severidade (1-3):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('0', style: TextStyle(fontSize: 10)),
                    Text('${domains[index].severidade}/3', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    const Text('3', style: TextStyle(fontSize: 10)),
                  ],
                ),
                Slider(
                  value: domains[index].severidade.toDouble(),
                  min: 0,
                  max: 3,
                  divisions: 3,
                  label: _severidadeOptions[domains[index].severidade],
                  onChanged: (val) {
                    final novo = NPIDomain(frequencia: domains[index].frequencia, severidade: val.toInt());
                    onChanged(novo);
                  },
                  activeColor: Colors.red.shade700,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    children: [
                      const Icon(Icons.calculate, size: 14, color: Colors.orange),
                      const SizedBox(width: 6),
                      Text('Score = Frequência × Severidade = ${domains[index].score}/12', style: TextStyle(fontSize: 11, color: Colors.orange.shade900)),
                    ],
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('NPI'),
        centerTitle: true,
        backgroundColor: Colors.orange.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.orange.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Instruções', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(
                    'Para cada domínio, avalie:\n'
                    '• Frequência (0-4): Quão frequentemente o sintoma ocorre\n'
                    '• Severidade (0-3): Quão severo é o sintoma\n'
                    'Score = Frequência × Severidade (máx 12 por domínio)',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          _buildDomainItem(0, _domains[0], _data.delusao, (v) => setState(() => _data.delusao = v)),
          _buildDomainItem(1, _domains[1], _data.alucinacoes, (v) => setState(() => _data.alucinacoes = v)),
          _buildDomainItem(2, _domains[2], _data.agitacao, (v) => setState(() => _data.agitacao = v)),
          _buildDomainItem(3, _domains[3], _data.depressao, (v) => setState(() => _data.depressao = v)),
          _buildDomainItem(4, _domains[4], _data.ansiedade, (v) => setState(() => _data.ansiedade = v)),
          _buildDomainItem(5, _domains[5], _data.euforia, (v) => setState(() => _data.euforia = v)),
          _buildDomainItem(6, _domains[6], _data.apatia, (v) => setState(() => _data.apatia = v)),
          _buildDomainItem(7, _domains[7], _data.desinibicao, (v) => setState(() => _data.desinibicao = v)),
          _buildDomainItem(8, _domains[8], _data.irritabilidade, (v) => setState(() => _data.irritabilidade = v)),
          _buildDomainItem(9, _domains[9], _data.comportamentoMotor, (v) => setState(() => _data.comportamentoMotor = v)),
          _buildDomainItem(10, _domains[10], _data.sono, (v) => setState(() => _data.sono = v)),
          _buildDomainItem(11, _domains[11], _data.apetite, (v) => setState(() => _data.apetite = v)),
          const SizedBox(height: 16),
          Card(
            color: score == 0 ? Colors.green : score <= 12 ? Colors.lightGreen : score <= 24 ? Colors.orange : score <= 48 ? Colors.deepOrange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('NPI Score Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/144', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Domínios com sintomas: ${_data.numeroSintomas}/12', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarNPI,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala NPI'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

