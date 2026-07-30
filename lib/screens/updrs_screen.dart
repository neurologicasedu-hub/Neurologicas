import 'package:flutter/material.dart';
import '../models/updrs_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class UPDRSScreen extends StatefulWidget {
  const UPDRSScreen({super.key});

  @override
  State<UPDRSScreen> createState() => _UPDRSScreenState();
}

class _UPDRSScreenState extends State<UPDRSScreen> {
  final UPDRSData _data = UPDRSData();

  Future<void> _salvarUPDRS() async {
    try {
      final score = CompletedScore(
        scoreName: 'UPDRS (Unified Parkinson\'s Disease Rating Scale)',
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
            content: const Text('Escala UPDRS salva com sucesso!'),
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

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text('$value/4', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
              ),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(activeTrackColor: Colors.purple, thumbColor: Colors.purple),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 4,
            divisions: 4,
            label: value == 0 ? 'Normal' : value == 4 ? 'Grave' : '$value',
            onChanged: (val) => onChanged(val.toInt()),
          ),
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return CalculatorScaffold(
      title: 'UPDRS',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Unified Parkinson\'s Disease Rating Scale\nAvalie cada item de 0 (normal) a 4 (grave)',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

          _buildExpansionCard('Parte I: Mentação, Comportamento e Humor', _data.parte1Score, 16, [
             _buildSliderItem('Intelecto', _data.intelecto, (val) => setState(() => _data.intelecto = val)),
             _buildSliderItem('Pensamento', _data.pensamento, (val) => setState(() => _data.pensamento = val)),
             _buildSliderItem('Depressão', _data.depressao, (val) => setState(() => _data.depressao = val)),
             _buildSliderItem('Motivação', _data.motivacao, (val) => setState(() => _data.motivacao = val)),
          ]),

          _buildExpansionCard('Parte II: Atividades de Vida Diária', _data.parte2Score, 52, [
             _buildSliderItem('Fala', _data.fala, (val) => setState(() => _data.fala = val)),
             _buildSliderItem('Salivação', _data.saliva, (val) => setState(() => _data.saliva = val)),
             _buildSliderItem('Deglutição', _data.degluticao, (val) => setState(() => _data.degluticao = val)),
             _buildSliderItem('Escrita', _data.escrita, (val) => setState(() => _data.escrita = val)),
             _buildSliderItem('Cortar Alimentos', _data.cortarAlimentos, (val) => setState(() => _data.cortarAlimentos = val)),
             _buildSliderItem('Vestir', _data.vestir, (val) => setState(() => _data.vestir = val)),
             _buildSliderItem('Higiene', _data.higiene, (val) => setState(() => _data.higiene = val)),
             _buildSliderItem('Virar na Cama', _data.virarNaCama, (val) => setState(() => _data.virarNaCama = val)),
             _buildSliderItem('Quedas', _data.quedas, (val) => setState(() => _data.quedas = val)),
             _buildSliderItem('Congelamento', _data.congelamento, (val) => setState(() => _data.congelamento = val)),
             _buildSliderItem('Caminhar', _data.caminhar, (val) => setState(() => _data.caminhar = val)),
             _buildSliderItem('Tremor', _data.tremor, (val) => setState(() => _data.tremor = val)),
             _buildSliderItem('Sensação', _data.sensacao, (val) => setState(() => _data.sensacao = val)),
          ]),

          _buildExpansionCard('Parte III: Exame Motor', _data.parte3Score, 132, [
             _buildSliderItem('Fala (Motor)', _data.falaMotor, (val) => setState(() => _data.falaMotor = val)),
             _buildSliderItem('Expressão Facial', _data.expressaoFacial, (val) => setState(() => _data.expressaoFacial = val)),
             _buildSliderItem('Tremor Repouso - Rosto', _data.tremorRepousoRosto, (val) => setState(() => _data.tremorRepousoRosto = val)),
             _buildSliderItem('Tremor Repouso - Mão Esq', _data.tremorRepousoMaoEsq, (val) => setState(() => _data.tremorRepousoMaoEsq = val)),
              _buildSliderItem('Tremor Repouso - Mão Dir', _data.tremorRepousoMaoDir, (val) => setState(() => _data.tremorRepousoMaoDir = val)),
              _buildSliderItem('Tremor Repouso - Perna Esq', _data.tremorRepousoPernaEsq, (val) => setState(() => _data.tremorRepousoPernaEsq = val)),
              _buildSliderItem('Tremor Repouso - Perna Dir', _data.tremorRepousoPernaDir, (val) => setState(() => _data.tremorRepousoPernaDir = val)),
              _buildSliderItem('Tremor Ação - Mão Esq', _data.tremorAcaoMaoEsq, (val) => setState(() => _data.tremorAcaoMaoEsq = val)),
              _buildSliderItem('Tremor Ação - Mão Dir', _data.tremorAcaoMaoDir, (val) => setState(() => _data.tremorAcaoMaoDir = val)),
              _buildSliderItem('Rigidez - Pescoço', _data.rigidezPescoco, (val) => setState(() => _data.rigidezPescoco = val)),
              _buildSliderItem('Rigidez - Braço Esq', _data.rigidezBracoEsq, (val) => setState(() => _data.rigidezBracoEsq = val)),
              _buildSliderItem('Rigidez - Braço Dir', _data.rigidezBracoDir, (val) => setState(() => _data.rigidezBracoDir = val)),
              _buildSliderItem('Rigidez - Perna Esq', _data.rigidezPernaEsq, (val) => setState(() => _data.rigidezPernaEsq = val)),
              _buildSliderItem('Rigidez - Perna Dir', _data.rigidezPernaDir, (val) => setState(() => _data.rigidezPernaDir = val)),
              _buildSliderItem('Movimento Dedos - Esq', _data.movimentoDedosEsq, (val) => setState(() => _data.movimentoDedosEsq = val)),
              _buildSliderItem('Movimento Dedos - Dir', _data.movimentoDedosDir, (val) => setState(() => _data.movimentoDedosDir = val)),
              _buildSliderItem('Movimento Mãos - Esq', _data.movimentoMaosEsq, (val) => setState(() => _data.movimentoMaosEsq = val)),
              _buildSliderItem('Movimento Mãos - Dir', _data.movimentoMaosDir, (val) => setState(() => _data.movimentoMaosDir = val)),
              _buildSliderItem('Supinação/Pronação - Esq', _data.supinacaoPronacaoEsq, (val) => setState(() => _data.supinacaoPronacaoEsq = val)),
              _buildSliderItem('Supinação/Pronação - Dir', _data.supinacaoPronacaoDir, (val) => setState(() => _data.supinacaoPronacaoDir = val)),
              _buildSliderItem('Levantar Braço - Esq', _data.levantarBracoEsq, (val) => setState(() => _data.levantarBracoEsq = val)),
              _buildSliderItem('Levantar Braço - Dir', _data.levantarBracoDir, (val) => setState(() => _data.levantarBracoDir = val)),
              _buildSliderItem('Agilidade Pernas - Esq', _data.agilidadePernasEsq, (val) => setState(() => _data.agilidadePernasEsq = val)),
              _buildSliderItem('Agilidade Pernas - Dir', _data.agilidadePernasDir, (val) => setState(() => _data.agilidadePernasDir = val)),
              _buildSliderItem('Levantar da Cadeira', _data.levantarCadeira, (val) => setState(() => _data.levantarCadeira = val)),
              _buildSliderItem('Postura', _data.postura, (val) => setState(() => _data.postura = val)),
              _buildSliderItem('Marcha', _data.marcha, (val) => setState(() => _data.marcha = val)),
              _buildSliderItem('Estabilidade Postural', _data.estabilidadePostural, (val) => setState(() => _data.estabilidadePostural = val)),
              _buildSliderItem('Bradicinesia Corporal', _data.bradicinesiaCorporal, (val) => setState(() => _data.bradicinesiaCorporal = val)),
          ]),
          
          _buildExpansionCard('Parte IV: Complicações da Terapia', _data.parte4Score, 32, [
             _buildSliderItem('Duração Discinesia', _data.duracaoDiscinesia, (val) => setState(() => _data.duracaoDiscinesia = val)),
             _buildSliderItem('Incapacidade Discinesia', _data.incapacidadeDiscinesia, (val) => setState(() => _data.incapacidadeDiscinesia = val)),
             _buildSliderItem('Dor Discinesia', _data.dorDiscinesia, (val) => setState(() => _data.dorDiscinesia = val)),
             _buildSliderItem('Presença Flutuação Clínica', _data.presencaFlutuacaoClinica, (val) => setState(() => _data.presencaFlutuacaoClinica = val)),
             _buildSliderItem('Frequência Flutuação', _data.frequenciaFlutuacao, (val) => setState(() => _data.frequenciaFlutuacao = val)),
             _buildSliderItem('Flutuação Matinal', _data.flutuacaoMatinal, (val) => setState(() => _data.flutuacaoMatinal = val)),
             _buildSliderItem('Flutuação Diurna', _data.flutuacaoDiurna, (val) => setState(() => _data.flutuacaoDiurna = val)),
             _buildSliderItem('Distonia Noturna', _data.distoniaNoturna, (val) => setState(() => _data.distoniaNoturna = val)),
          ]),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: score <= 25 ? Colors.green : score <= 50 ? Colors.orange : Colors.red,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (score <= 25 ? Colors.green : score <= 50 ? Colors.orange : Colors.red).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('UPDRS TOTAL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                Text(
                  'P1: ${_data.parte1Score} | P2: ${_data.parte2Score} | P3: ${_data.parte3Score} | P4: ${_data.parte4Score}',
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
        onPressed: _salvarUPDRS,
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildExpansionCard(String title, int score, int maxScore, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)),
            child: Text('$score / $maxScore', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
          ),
          children: children,
        ),
      ),
    );
  }
}
