import 'package:flutter/material.dart';
import '../models/mds_updrs_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

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
        resultado: 'P1: ${_data.parte1Score} | P2: ${_data.parte2Score} | P3: ${_data.parte3Score} | P4: ${_data.parte4Score} - Total: ${_data.totalScore} - ${_data.interpretation}',
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

  // --- (Item definitions remain the same as original) ---
  static final List<String> _parte1Items = [
    'Problemas Cognitivos', 'Alucinações e Psicose', 'Depressão', 'Ansiedade', 'Apatia', 
    'Características de Compulsão/Impulsividade', 'Déficit de Percepção do Período de Sono', 
    'Sonolência Diurna', 'Dor e Sensações Anormais', 'Urgência Urinária', 'Constipação', 
    'Sensação Ortostática', 'Fadiga',
  ];

  static final List<String> _parte2Items = [
    'Fala', 'Salivação e Babeio', 'Mastigação e Deglutição', 'Comer Tarefas', 'Vestir-se', 
    'Higiene', 'Escrever à Mão', 'Fazer Hobbies e Outras Atividades', 
    'Virar-se na Cama e Ajustar Cobertas', 'Tremor', 'Sair da Cama, Cadeira ou Automóvel', 
    'Andar e Equilíbrio', 'Congelamento',
  ];

  static final List<String> _parte3Items = [
    'Expressão Facial', 'Rigidez - Pescoço', 'Rigidez - MSD', 'Rigidez - MSE', 
    'Rigidez - MID', 'Rigidez - MIE', 'Tremor Repouso - Face', 
    'Tremor Repouso - MSD', 'Tremor Repouso - MSE', 'Tremor Repouso - MID', 
    'Tremor Repouso - MIE', 'Tremor Cinético/Postural - MSD', 'Tremor Cinético/Postural - MSE', 
    'Movimentos Alternados - MSD', 'Movimentos Alternados - MSE', 
    'Movimentos de Abertura/Fechamento - MSD', 'Movimentos de Abertura/Fechamento - MSE', 
    'Agilidade da Perna - Direita', 'Agilidade da Perna - Esquerda', 
    'Levantar-se da Cadeira', 'Postura', 'Estabilidade da Marcha', 'Marcha', 
    'Congelamento da Marcha', 'Dedos da Mão - Movimento Alternado - Dir', 
    'Dedos da Mão - Movimento Alternado - Esq', 'Dedos do Pé - Movimento Alternado - Dir', 
    'Dedos do Pé - Movimento Alternado - Esq', 'Bradicinesia - Dir', 'Bradicinesia - Esq', 
    'Constância de Movimento', 'Movimento Discinético', 'Distonia',
  ];

  static final List<String> _parte4Items = [
    'Tempo com Discinesias', 'Impacto das Discinesias', 'Tempo com Mediações', 
    'Funcionalidade no Estado "OFF"', 'Distúrbios do Sono', 'Cansaço',
  ];

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged, int index, List<int> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text('$value/4', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple.shade900)),
              ),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.deepPurple, thumbColor: Colors.deepPurple),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 4,
            divisions: 4,
            label: value == 0 ? 'Normal' : '$value',
            onChanged: (val) {
              setState(() => list[index] = val.toInt());
            },
          ),
        ),
        const Divider(),
      ],
    );
  }
  
  Widget _buildExpansionCard(String title, int score, int maxScore, List<Widget> children, {bool initiallyExpanded = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: Text('$score / $maxScore', style: TextStyle(fontSize: 12, color: Colors.deepPurple.shade700)),
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: widget.onlyPart3 ? 'TESTE DA LEVODOPA' : 'MDS-UPDRS',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              widget.onlyPart3 ? 'Avaliação Motora (Part III)\nAvalie de 0 (Normal) a 4 (Grave)' : 'Movement Disorder Society-UPDRS\nAvalie de 0 (Normal) a 4 (Grave)',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

          if (!widget.onlyPart3)
            _buildExpansionCard(
              'Parte I: Experiências Não Motoras', 
              _data.parte1Score, 52, 
              List.generate(_parte1Items.length, (i) => _buildSliderItem(_parte1Items[i], _data.parte1NaoMotoras[i], (val) {}, i, _data.parte1NaoMotoras))
            ),

          if (!widget.onlyPart3)
             _buildExpansionCard(
              'Parte II: Experiências Motoras', 
              _data.parte2Score, 52, 
              List.generate(_parte2Items.length, (i) => _buildSliderItem(_parte2Items[i], _data.parte2Motoras[i], (val) {}, i, _data.parte2Motoras))
            ),

           _buildExpansionCard(
            'Parte III: Exame Motor', 
            _data.parte3Score, 132, 
            List.generate(_parte3Items.length, (i) => _buildSliderItem(_parte3Items[i], _data.parte3ExameMotor[i], (val) {}, i, _data.parte3ExameMotor)),
            initiallyExpanded: widget.onlyPart3
          ),

          if (!widget.onlyPart3)
             _buildExpansionCard(
              'Parte IV: Complicações Motoras', 
              _data.parte4Score, 24, 
              List.generate(_parte4Items.length, (i) => _buildSliderItem(_parte4Items[i], _data.parte4Complicacoes[i], (val) {}, i, _data.parte4Complicacoes))
            ),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 30 ? Colors.green : score <= 60 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 30 ? Colors.green : score <= 60 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                Text(widget.onlyPart3 ? 'TESTE LEVODOPA TOTAL' : 'MDS-UPDRS TOTAL', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 if (!widget.onlyPart3)
                  Text(
                    'P1: ${_data.parte1Score}  P2: ${_data.parte2Score}  P3: ${_data.parte3Score}  P4: ${_data.parte4Score}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
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
        onPressed: _salvarMDSUPDRS,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
