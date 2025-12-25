import 'package:flutter/material.dart';
import '../models/updrs_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

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
        resultado: 'Parte I: ${_data.parte1Score} | Parte II: ${_data.parte2Score} | Parte III: ${_data.parte3Score} | Parte IV: ${_data.parte4Score} - Total: ${_data.totalScore} - ${_data.interpretation}',
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

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged) {
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
                const Text('0 - Normal', style: TextStyle(fontSize: 10)),
                Text('$value/4', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Text('4 - Grave', style: TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.purple,
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
        title: const Text('UPDRS - Unified Parkinson\'s Disease Rating Scale'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'UPDRS - Escala Unificada de Avaliação da Doença de Parkinson',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Avalie cada item de 0 (normal) a 4 (grave)',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Parte I: Mentação, Comportamento e Humor (${_data.parte1Score}/16)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildSliderItem('Intelecto', _data.intelecto, (val) => setState(() => _data.intelecto = val)),
                _buildSliderItem('Pensamento', _data.pensamento, (val) => setState(() => _data.pensamento = val)),
                _buildSliderItem('Depressão', _data.depressao, (val) => setState(() => _data.depressao = val)),
                _buildSliderItem('Motivação', _data.motivacao, (val) => setState(() => _data.motivacao = val)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Parte II: Atividades de Vida Diária (${_data.parte2Score}/52)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
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
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Parte III: Exame Motor (mds-updrs) - "TESTE DA LEVODOPA" (${_data.parte3Score}/132)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildSliderItem('Fala (Motor)', _data.falaMotor, (val) => setState(() => _data.falaMotor = val)),
                _buildSliderItem('Expressão Facial', _data.expressaoFacial, (val) => setState(() => _data.expressaoFacial = val)),
                _buildSliderItem('Tremor Repouso - Rosto', _data.tremorRepousoRosto, (val) => setState(() => _data.tremorRepousoRosto = val)),
                _buildSliderItem('Tremor Repouso - Mão Esquerda', _data.tremorRepousoMaoEsq, (val) => setState(() => _data.tremorRepousoMaoEsq = val)),
                _buildSliderItem('Tremor Repouso - Mão Direita', _data.tremorRepousoMaoDir, (val) => setState(() => _data.tremorRepousoMaoDir = val)),
                _buildSliderItem('Tremor Repouso - Perna Esquerda', _data.tremorRepousoPernaEsq, (val) => setState(() => _data.tremorRepousoPernaEsq = val)),
                _buildSliderItem('Tremor Repouso - Perna Direita', _data.tremorRepousoPernaDir, (val) => setState(() => _data.tremorRepousoPernaDir = val)),
                _buildSliderItem('Tremor Ação - Mão Esquerda', _data.tremorAcaoMaoEsq, (val) => setState(() => _data.tremorAcaoMaoEsq = val)),
                _buildSliderItem('Tremor Ação - Mão Direita', _data.tremorAcaoMaoDir, (val) => setState(() => _data.tremorAcaoMaoDir = val)),
                _buildSliderItem('Rigidez - Pescoço', _data.rigidezPescoco, (val) => setState(() => _data.rigidezPescoco = val)),
                _buildSliderItem('Rigidez - Braço Esquerdo', _data.rigidezBracoEsq, (val) => setState(() => _data.rigidezBracoEsq = val)),
                _buildSliderItem('Rigidez - Braço Direito', _data.rigidezBracoDir, (val) => setState(() => _data.rigidezBracoDir = val)),
                _buildSliderItem('Rigidez - Perna Esquerda', _data.rigidezPernaEsq, (val) => setState(() => _data.rigidezPernaEsq = val)),
                _buildSliderItem('Rigidez - Perna Direita', _data.rigidezPernaDir, (val) => setState(() => _data.rigidezPernaDir = val)),
                _buildSliderItem('Movimento Dedos - Esquerdo', _data.movimentoDedosEsq, (val) => setState(() => _data.movimentoDedosEsq = val)),
                _buildSliderItem('Movimento Dedos - Direito', _data.movimentoDedosDir, (val) => setState(() => _data.movimentoDedosDir = val)),
                _buildSliderItem('Movimento Mãos - Esquerdo', _data.movimentoMaosEsq, (val) => setState(() => _data.movimentoMaosEsq = val)),
                _buildSliderItem('Movimento Mãos - Direito', _data.movimentoMaosDir, (val) => setState(() => _data.movimentoMaosDir = val)),
                _buildSliderItem('Supinação/Pronação - Esquerdo', _data.supinacaoPronacaoEsq, (val) => setState(() => _data.supinacaoPronacaoEsq = val)),
                _buildSliderItem('Supinação/Pronação - Direito', _data.supinacaoPronacaoDir, (val) => setState(() => _data.supinacaoPronacaoDir = val)),
                _buildSliderItem('Levantar Braço - Esquerdo', _data.levantarBracoEsq, (val) => setState(() => _data.levantarBracoEsq = val)),
                _buildSliderItem('Levantar Braço - Direito', _data.levantarBracoDir, (val) => setState(() => _data.levantarBracoDir = val)),
                _buildSliderItem('Agilidade Pernas - Esquerdo', _data.agilidadePernasEsq, (val) => setState(() => _data.agilidadePernasEsq = val)),
                _buildSliderItem('Agilidade Pernas - Direito', _data.agilidadePernasDir, (val) => setState(() => _data.agilidadePernasDir = val)),
                _buildSliderItem('Levantar da Cadeira', _data.levantarCadeira, (val) => setState(() => _data.levantarCadeira = val)),
                _buildSliderItem('Postura', _data.postura, (val) => setState(() => _data.postura = val)),
                _buildSliderItem('Marcha', _data.marcha, (val) => setState(() => _data.marcha = val)),
                _buildSliderItem('Estabilidade Postural', _data.estabilidadePostural, (val) => setState(() => _data.estabilidadePostural = val)),
                _buildSliderItem('Bradicinesia Corporal', _data.bradicinesiaCorporal, (val) => setState(() => _data.bradicinesiaCorporal = val)),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: ExpansionTile(
              title: Text('Parte IV: Complicações da Terapia (${_data.parte4Score}/32)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              children: [
                _buildSliderItem('Duração Discinesia', _data.duracaoDiscinesia, (val) => setState(() => _data.duracaoDiscinesia = val)),
                _buildSliderItem('Incapacidade Discinesia', _data.incapacidadeDiscinesia, (val) => setState(() => _data.incapacidadeDiscinesia = val)),
                _buildSliderItem('Dor Discinesia', _data.dorDiscinesia, (val) => setState(() => _data.dorDiscinesia = val)),
                _buildSliderItem('Presença Flutuação Clínica', _data.presencaFlutuacaoClinica, (val) => setState(() => _data.presencaFlutuacaoClinica = val)),
                _buildSliderItem('Frequência Flutuação', _data.frequenciaFlutuacao, (val) => setState(() => _data.frequenciaFlutuacao = val)),
                _buildSliderItem('Flutuação Matinal', _data.flutuacaoMatinal, (val) => setState(() => _data.flutuacaoMatinal = val)),
                _buildSliderItem('Flutuação Diurna', _data.flutuacaoDiurna, (val) => setState(() => _data.flutuacaoDiurna = val)),
                _buildSliderItem('Distonia Noturna', _data.distoniaNoturna, (val) => setState(() => _data.distoniaNoturna = val)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: score <= 25 ? Colors.green : score <= 50 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('UPDRS Total: $score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Parte I: ${_data.parte1Score}/16 | Parte II: ${_data.parte2Score}/52\nParte III: ${_data.parte3Score}/132 | Parte IV: ${_data.parte4Score}/32', style: const TextStyle(fontSize: 12, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarUPDRS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala UPDRS'),
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
