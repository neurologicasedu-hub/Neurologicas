import 'package:flutter/material.dart';
import '../models/mds_updrs_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class MDSUPDRSScreen extends StatefulWidget {
  final bool onlyPart3;

  const MDSUPDRSScreen({super.key, this.onlyPart3 = false});

  @override
  State<MDSUPDRSScreen> createState() => _MDSUPDRSScreenState();
}

class _MDSUPDRSScreenState extends State<MDSUPDRSScreen> {
  final MDSUPDRSData _data = MDSUPDRSData();

  Future<void> _salvarMDSUPDRS() async {
    try {
      final score = CompletedScore(
        scoreName: widget.onlyPart3 ? 'TESTE DA LEVODOPA (MDS-UPDRS Part III)' : 'MDS-UPDRS (Movement Disorder Society-UPDRS)',
        scoreData: {
          'parte1Score': _data.parte1Score,
          'parte2Score': _data.parte2Score,
          'parte3Score': _data.parte3Score,
          'parte4Score': _data.parte4Score,
          'totalScore': _data.totalScore,
        },
        resultado: 'Parte I: ${_data.parte1Score} | Parte II: ${_data.parte2Score} | Parte III: ${_data.parte3Score} | Parte IV: ${_data.parte4Score} - Total: ${_data.totalScore} - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala MDS-UPDRS salva com sucesso!'),
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

  // Lista completa de itens do MDS-UPDRS
  static final List<String> _parte1Items = [
    'Problemas Cognitivos',
    'Alucinações e Psicose',
    'Depressão',
    'Ansiedade',
    'Apatia',
    'Características de Compulsão/Impulsividade',
    'Déficit de Percepção do Período de Sono',
    'Sonolência Diurna',
    'Dor e Sensações Anormais',
    'Urgência Urinária',
    'Constipação',
    'Sensação Ortostática',
    'Fadiga',
  ];

  static final List<String> _parte2Items = [
    'Fala',
    'Salivação e Babeio',
    'Mastigação e Deglutição',
    'Comer Tarefas',
    'Vestir-se',
    'Higiene',
    'Escrever à Mão',
    'Fazer Hobbies e Outras Atividades',
    'Virar-se na Cama e Ajustar Cobertas',
    'Tremor',
    'Sair da Cama, Cadeira ou Automóvel',
    'Andar e Equilíbrio',
    'Congelamento',
  ];

  static final List<String> _parte3Items = [
    'Expressão Facial',
    'Rigidez - Pescoço',
    'Rigidez - Membro Superior Direito',
    'Rigidez - Membro Superior Esquerdo',
    'Rigidez - Membro Inferior Direito',
    'Rigidez - Membro Inferior Esquerdo',
    'Tremor em Repouso - Face, Lábios e Queixo',
    'Tremor em Repouso - Membro Superior Direito',
    'Tremor em Repouso - Membro Superior Esquerdo',
    'Tremor em Repouso - Membro Inferior Direito',
    'Tremor em Repouso - Membro Inferior Esquerdo',
    'Tremor Cinético ou Postural - Membro Superior Direito',
    'Tremor Cinético ou Postural - Membro Superior Esquerdo',
    'Movimentos Alternados - Membro Superior Direito',
    'Movimentos Alternados - Membro Superior Esquerdo',
    'Movimentos de Abertura/Fechamento - Membro Superior Direito',
    'Movimentos de Abertura/Fechamento - Membro Superior Esquerdo',
    'Agilidade da Perna - Direita',
    'Agilidade da Perna - Esquerda',
    'Levantar-se da Cadeira',
    'Postura',
    'Estabilidade da Marcha',
    'Marcha',
    'Congelamento da Marcha',
    'Dedos da Mão - Movimento Alternado - Direita',
    'Dedos da Mão - Movimento Alternado - Esquerda',
    'Dedos do Pé - Movimento Alternado - Direita',
    'Dedos do Pé - Movimento Alternado - Esquerda',
    'Bradicinesia e Hipocinesia - Direita',
    'Bradicinesia e Hipocinesia - Esquerda',
    'Constância de Movimento',
    'Movimento Discinético',
    'Distonia',
  ];

  static final List<String> _parte4Items = [
    'Tempo com Discinesias',
    'Impacto Funcional das Discinesias',
    'Tempo com Flutuações Motoras',
    'Funcionalidade no Estado "OFF"',
    'Distúrbios do Sono Relacionados ao Parkinson',
    'Cansaço',
  ];

  String _getItemDescription(String part, int index) {
    final descriptions = {
      'parte1': {
        0: 'Pergunte: "Você tem problemas de memória ou confusão?"',
        1: 'Pergunte: "Você vê, ouve ou sente coisas que outras pessoas não veem?"',
        2: 'Pergunte: "Você se sente deprimido ou triste?"',
        3: 'Pergunte: "Você se sente ansioso ou nervoso?"',
        4: 'Pergunte: "Você perdeu interesse em atividades que costumava gostar?"',
        5: 'Pergunte: "Você tem comportamentos repetitivos ou impulsivos?"',
        6: 'Pergunte: "Você tem problemas para perceber o tempo, como se estivesse sonhando acordado?"',
        7: 'Pergunte: "Você se sente sonolento durante o dia?"',
        8: 'Pergunte: "Você sente dor ou sensações estranhas?"',
        9: 'Pergunte: "Você precisa urinar com urgência?"',
        10: 'Pergunte: "Você tem problemas de constipação?"',
        11: 'Pergunte: "Você sente tontura ao levantar-se?"',
        12: 'Pergunte: "Você se sente cansado ou sem energia?"',
      },
      'parte2': {
        0: 'Pergunte: "Você tem dificuldade para falar?"',
        1: 'Pergunte: "Você baba ou tem excesso de saliva?"',
        2: 'Pergunte: "Você tem dificuldade para mastigar ou engolir?"',
        3: 'Pergunte: "Você tem dificuldade para cortar comida e manusear talheres?"',
        4: 'Pergunte: "Você tem dificuldade para vestir-se sozinho?"',
        5: 'Pergunte: "Você tem dificuldade para fazer a higiene pessoal?"',
        6: 'Pergunte: "Você tem dificuldade para escrever à mão?"',
        7: 'Pergunte: "Você tem dificuldade para fazer seus hobbies?"',
        8: 'Pergunte: "Você tem dificuldade para virar-se na cama?"',
        9: 'Pergunte: "Você tem tremor que interfere em suas atividades?"',
        10: 'Pergunte: "Você tem dificuldade para sair da cama, cadeira ou carro?"',
        11: 'Pergunte: "Você tem dificuldade para andar ou manter o equilíbrio?"',
        12: 'Pergunte: "Você tem episódios de "congelamento" (não consegue se mover)?"',
      },
      'parte3': {
        0: 'Observe: Expressão facial do paciente (hipomimia)',
        1: 'Teste: Rigidez passiva do pescoço',
        2: 'Teste: Rigidez passiva do braço direito',
        3: 'Teste: Rigidez passiva do braço esquerdo',
        4: 'Teste: Rigidez passiva da perna direita',
        5: 'Teste: Rigidez passiva da perna esquerda',
        6: 'Observe: Tremor em repouso na face, lábios e queixo',
        7: 'Observe: Tremor em repouso no braço direito',
        8: 'Observe: Tremor em repouso no braço esquerdo',
        9: 'Observe: Tremor em repouso na perna direita',
        10: 'Observe: Tremor em repouso na perna esquerda',
        11: 'Teste: Tremor cinético/postural no braço direito (movimento de mão para nariz)',
        12: 'Teste: Tremor cinético/postural no braço esquerdo (movimento de mão para nariz)',
        13: 'Teste: Movimentos alternados no braço direito (abrir/fechar mão rapidamente)',
        14: 'Teste: Movimentos alternados no braço esquerdo (abrir/fechar mão rapidamente)',
        15: 'Teste: Abertura/fechamento de punho no braço direito',
        16: 'Teste: Abertura/fechamento de punho no braço esquerdo',
        17: 'Teste: Agilidade da perna direita (bater pé no chão)',
        18: 'Teste: Agilidade da perna esquerda (bater pé no chão)',
        19: 'Teste: Levantar-se da cadeira (sem usar os braços)',
        20: 'Observe: Postura geral do paciente em pé',
        21: 'Teste: Estabilidade da marcha (empurrão leve nas costas)',
        22: 'Observe: Marcha normal (observar passos, balanço dos braços, etc.)',
        23: 'Observe: Congelamento durante a marcha',
        24: 'Teste: Movimentos alternados dos dedos da mão direita',
        25: 'Teste: Movimentos alternados dos dedos da mão esquerda',
        26: 'Teste: Movimentos alternados dos dedos do pé direito',
        27: 'Teste: Movimentos alternados dos dedos do pé esquerdo',
        28: 'Observe: Bradicinesia e hipocinesia no lado direito',
        29: 'Observe: Bradicinesia e hipocinesia no lado esquerdo',
        30: 'Observe: Constância de movimento (manter ritmo)',
        31: 'Observe: Movimentos discinéticos durante o exame',
        32: 'Observe: Distonia presente',
      },
      'parte4': {
        0: 'Pergunte: "Quanto tempo do dia você passa com movimentos involuntários (discinesias)?"',
        1: 'Pergunte: "As discinesias interferem nas suas atividades diárias?"',
        2: 'Pergunte: "Quanto tempo do dia você passa no estado "OFF" (sintomas retornam)?"',
        3: 'Pergunte: "Quando está no estado OFF, você consegue realizar suas atividades?"',
        4: 'Pergunte: "Você tem problemas de sono relacionados ao Parkinson?"',
        5: 'Pergunte: "Você sente cansaço extremo?"',
      },
    };
    
    return descriptions[part]?[index] ?? '';
  }

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged, int index, List<int> list, String part) {
    final description = _getItemDescription(part, index);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.medical_information, size: 14, color: Colors.deepPurple.shade800),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 10, color: Colors.deepPurple.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('0 - Normal', style: TextStyle(fontSize: 10)),
                Text('$value/4', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Text('4 - Muito Grave', style: TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              label: value == 0 ? 'Normal' : value == 1 ? 'Leve' : value == 2 ? 'Moderado' : value == 3 ? 'Grave' : 'Muito Grave',
              onChanged: (val) {
                setState(() {
                  list[index] = val.toInt();
                });
              },
              activeColor: Colors.deepPurple,
            ),
            const SizedBox(height: 4),
            const Text(
              '0: Normal | 1: Leve | 2: Moderado | 3: Grave | 4: Muito Grave',
              style: TextStyle(fontSize: 9, color: Colors.grey),
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
        title: Text(widget.onlyPart3 ? 'TESTE DA LEVODOPA' : 'MDS-UPDRS'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.onlyPart3 ? 'TESTE DA LEVODOPA (MDS-UPDRS Parte III)' : 'MDS-UPDRS - Movement Disorder Society Revision',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Avalie cada item de 0 (ausente) a 4 (grave)',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (!widget.onlyPart3) Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Parte I: Experiências Não Motoras na Vida Diária (${_data.parte1Score}/52)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                ...List.generate(13, (i) => _buildSliderItem(
                  _parte1Items[i],
                  _data.parte1NaoMotoras[i],
                  (val) => setState(() => _data.parte1NaoMotoras[i] = val),
                  i,
                  _data.parte1NaoMotoras,
                  'parte1',
                )),
              ],
            ),
          ),
          if (!widget.onlyPart3) Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Parte II: Experiências Motoras na Vida Diária (${_data.parte2Score}/52)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                ...List.generate(13, (i) => _buildSliderItem(
                  _parte2Items[i],
                  _data.parte2Motoras[i],
                  (val) => setState(() => _data.parte2Motoras[i] = val),
                  i,
                  _data.parte2Motoras,
                  'parte2',
                )),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text(widget.onlyPart3 ? 'MDS-UPDRS Parte III' : 'Parte III: Exame Motor (${_data.parte3Score}/132)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              initiallyExpanded: widget.onlyPart3,
              children: [
                ...List.generate(33, (i) => _buildSliderItem(
                  _parte3Items[i],
                  _data.parte3ExameMotor[i],
                  (val) => setState(() => _data.parte3ExameMotor[i] = val),
                  i,
                  _data.parte3ExameMotor,
                  'parte3',
                )),
              ],
            ),
          ),
          if (!widget.onlyPart3) Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Parte IV: Complicações Motoras (${_data.parte4Score}/24)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                ...List.generate(6, (i) => _buildSliderItem(
                  _parte4Items[i],
                  _data.parte4Complicacoes[i],
                  (val) => setState(() => _data.parte4Complicacoes[i] = val),
                  i,
                  _data.parte4Complicacoes,
                  'parte4',
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: score <= 30 ? Colors.green : score <= 60 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('MDS-UPDRS Total: $score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  if (!widget.onlyPart3) Text('Parte I: ${_data.parte1Score}/52 | Parte II: ${_data.parte2Score}/52\nParte III: ${_data.parte3Score}/132 | Parte IV: ${_data.parte4Score}/24', style: const TextStyle(fontSize: 12, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarMDSUPDRS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala MDS-UPDRS'),
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
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
