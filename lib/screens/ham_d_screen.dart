import 'package:flutter/material.dart';
import '../models/ham_d_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class HAMDScreen extends StatefulWidget {
  const HAMDScreen({super.key});

  @override
  State<HAMDScreen> createState() => _HAMDScreenState();
}

class _HAMDScreenState extends State<HAMDScreen> {
  final HAMDData _data = HAMDData();

  final List<Map<String, dynamic>> _items = [
    {'title': 'Humor Deprimido', 'max': 4, 'description': '0: Ausente\n1: Sentimentos expressos apenas quando questionado\n2: Relatado espontaneamente\n3: Comunicado através de expressão facial, voz e postura\n4: Humor depressivo expresso apenas através desses sinais'},
    {'title': 'Sentimento de Culpa', 'max': 4, 'description': '0: Ausente\n1: Auto-reprovação; sente-se que decepcionou pessoas\n2: Ideias de culpa ou pensamentos sobre erros passados\n3: Presente doença é punição; delírios de culpa\n4: Alucinações de voz acusando ou ameaçando'},
    {'title': 'Suicídio', 'max': 4, 'description': '0: Ausente\n1: Acha que a vida não vale a pena\n2: Desejos de estar morto ou pensamentos de morte\n3: Ideias ou gestos suicidas\n4: Tentativas de suicídio'},
    {'title': 'Insônia Inicial', 'max': 2, 'description': '0: Sem dificuldade\n1: Reclama de ocasionais dificuldades\n2: Dificuldade todas as noites'},
    {'title': 'Insônia do Meio da Noite', 'max': 2, 'description': '0: Sem dificuldade\n1: Paciente reclama de sono inquieto\n2: Despertares durante a noite'},
    {'title': 'Insônia Final', 'max': 2, 'description': '0: Sem dificuldade\n1: Despertar cedo mas volta a dormir\n2: Incapaz de voltar a dormir'},
    {'title': 'Trabalho e Atividades', 'max': 4, 'description': '0: Sem dificuldade\n1: Pensamentos e sentimentos de incapacidade\n2: Diminuição de atividades ou produtividade\n3: Parou trabalho por doença atual\n4: Incapaz de trabalhar'},
    {'title': 'Retardo Psicomotor', 'max': 4, 'description': '0: Ausente\n1: Ligeira lentidão\n2: Lentidão óbvia\n3: Dificuldade entrevista\n4: Estupor'},
    {'title': 'Agitação', 'max': 4, 'description': '0: Ausente\n1: Inquietude\n2: Brinca com mãos, cabelo, etc.\n3: Movimenta-se sem parar\n4: Mordendo unhas, puxando cabelo'},
    {'title': 'Ansiedade Psíquica', 'max': 4, 'description': '0: Ausente\n1: Subjetiva tensão e irritabilidade\n2: Preocupação menor\n3: Aparência apreensiva\n4: Medos expressos sem questionamento'},
    {'title': 'Ansiedade Somática', 'max': 4, 'description': '0: Ausente\n1: Leve\n2: Moderada\n3: Grave\n4: Incapacitante'},
    {'title': 'Sintomas Somáticos GI', 'max': 2, 'description': '0: Ausente\n1: Perda de apetite mas come sem encorajamento\n2: Precisa ser encorajado para comer'},
    {'title': 'Sintomas Somáticos Gerais', 'max': 2, 'description': '0: Ausente\n1: Pesos em membros, costas ou cabeça\n2: Qualquer sintoma claro e difuso'},
    {'title': 'Sintomas Genitais', 'max': 2, 'description': '0: Ausente\n1: Leve\n2: Grave'},
    {'title': 'Hipocondria', 'max': 4, 'description': '0: Ausente\n1: Auto-preocupação (corpo)\n2: Preocupa-se com saúde\n3: Queixas frequentes\n4: Delírios hipocondríacos'},
    {'title': 'Perda de Peso', 'max': 2, 'description': '0: Ausente\n1: Provável perda de peso\n2: Perda de peso definitiva'},
    {'title': 'Insight', 'max': 2, 'description': '0: Reconoce que está deprimido\n1: Reconhece doença mas atribui a causas físicas\n2: Nega estar doente'},
  ];

  Future<void> _salvarHAMD() async {
    try {
      final score = CompletedScore(
        scoreName: 'Hamilton Depression Rating Scale (HAM-D)',
        scoreData: {
          'humorDeprimido': _data.humorDeprimido,
          'sentimentoCulpa': _data.sentimentoCulpa,
          'suicidio': _data.suicidio,
          'insoniaInicial': _data.insoniaInicial,
          'insoniaMeio': _data.insoniaMeio,
          'insoniaFinal': _data.insoniaFinal,
          'trabalhoAtividades': _data.trabalhoAtividades,
          'retardoPsicomotor': _data.retardoPsicomotor,
          'agitacao': _data.agitacao,
          'ansiedadePsiquica': _data.ansiedadePsiquica,
          'ansiedadeSomatica': _data.ansiedadeSomatica,
          'sintomasSomaticosGI': _data.sintomasSomaticosGI,
          'sintomasSomaticosGerais': _data.sintomasSomaticosGerais,
          'sintomasGenitais': _data.sintomasGenitais,
          'hipocondria': _data.hipocondria,
          'perdaPeso': _data.perdaPeso,
          'insight': _data.insight,
        },
        resultado: '${_data.totalScore}/52 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala HAM-D salva com sucesso!'),
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

  Widget _buildItem(int index, Map<String, dynamic> item, int value, ValueChanged<int> onChanged) {
    final items = [
      _data.humorDeprimido, _data.sentimentoCulpa, _data.suicidio, _data.insoniaInicial,
      _data.insoniaMeio, _data.insoniaFinal, _data.trabalhoAtividades, _data.retardoPsicomotor,
      _data.agitacao, _data.ansiedadePsiquica, _data.ansiedadeSomatica, _data.sintomasSomaticosGI,
      _data.sintomasSomaticosGerais, _data.sintomasGenitais, _data.hipocondria, _data.perdaPeso,
      _data.insight,
    ];
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index + 1}. ${item['title']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            if (item['description'] != null) ...[
              const SizedBox(height: 4),
              Text(item['description'], style: TextStyle(fontSize: 9, color: Colors.grey.shade700)),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('0', style: TextStyle(fontSize: 10)),
                Text('${items[index]}/${item['max']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('${item['max']}', style: const TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: items[index].toDouble(),
              min: 0,
              max: item['max'].toDouble(),
              divisions: item['max'],
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.blue.shade700,
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
        title: const Text('HAM-D / HDRS'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'HAM-D - Hamilton Depression Rating Scale\nAvaliação clínica de sintomas depressivos (17 itens)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildItem(0, _items[0], _data.humorDeprimido, (v) => setState(() => _data.humorDeprimido = v)),
          _buildItem(1, _items[1], _data.sentimentoCulpa, (v) => setState(() => _data.sentimentoCulpa = v)),
          _buildItem(2, _items[2], _data.suicidio, (v) => setState(() => _data.suicidio = v)),
          _buildItem(3, _items[3], _data.insoniaInicial, (v) => setState(() => _data.insoniaInicial = v)),
          _buildItem(4, _items[4], _data.insoniaMeio, (v) => setState(() => _data.insoniaMeio = v)),
          _buildItem(5, _items[5], _data.insoniaFinal, (v) => setState(() => _data.insoniaFinal = v)),
          _buildItem(6, _items[6], _data.trabalhoAtividades, (v) => setState(() => _data.trabalhoAtividades = v)),
          _buildItem(7, _items[7], _data.retardoPsicomotor, (v) => setState(() => _data.retardoPsicomotor = v)),
          _buildItem(8, _items[8], _data.agitacao, (v) => setState(() => _data.agitacao = v)),
          _buildItem(9, _items[9], _data.ansiedadePsiquica, (v) => setState(() => _data.ansiedadePsiquica = v)),
          _buildItem(10, _items[10], _data.ansiedadeSomatica, (v) => setState(() => _data.ansiedadeSomatica = v)),
          _buildItem(11, _items[11], _data.sintomasSomaticosGI, (v) => setState(() => _data.sintomasSomaticosGI = v)),
          _buildItem(12, _items[12], _data.sintomasSomaticosGerais, (v) => setState(() => _data.sintomasSomaticosGerais = v)),
          _buildItem(13, _items[13], _data.sintomasGenitais, (v) => setState(() => _data.sintomasGenitais = v)),
          _buildItem(14, _items[14], _data.hipocondria, (v) => setState(() => _data.hipocondria = v)),
          _buildItem(15, _items[15], _data.perdaPeso, (v) => setState(() => _data.perdaPeso = v)),
          _buildItem(16, _items[16], _data.insight, (v) => setState(() => _data.insight = v)),
          const SizedBox(height: 16),
          Card(
            color: score <= 7 ? Colors.green : score <= 17 ? Colors.lightGreen : score <= 24 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('HAM-D Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/52', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarHAMD,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala HAM-D'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

