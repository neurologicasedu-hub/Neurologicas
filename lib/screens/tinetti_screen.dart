import 'package:flutter/material.dart';
import '../models/tinetti_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class TinettiScreen extends StatefulWidget {
  const TinettiScreen({super.key});

  @override
  State<TinettiScreen> createState() => _TinettiScreenState();
}

class _TinettiScreenState extends State<TinettiScreen> {
  final TinettiData _data = TinettiData();

  Future<void> _salvarTinetti() async {
    try {
      final score = CompletedScore(
        scoreName: 'Tinetti Balance Assessment',
        scoreData: {
          'sentarEquilibrio': _data.sentarEquilibrio,
          'levantarEquilibrio': _data.levantarEquilibrio,
          'tentarLevantarEquilibrio': _data.tentarLevantarEquilibrio,
          'estabilidadePeEquilibrio': _data.estabilidadePeEquilibrio,
          'estabilidadePeComTosEquilibrio': _data.estabilidadePeComTosEquilibrio,
          'fecharOlhosEquilibrio': _data.fecharOlhosEquilibrio,
          'rodar360Equilibrio': _data.rodar360Equilibrio,
          'balancarEquilibrio': _data.balancarEquilibrio,
          'girarCabecaEquilibrio': _data.girarCabecaEquilibrio,
          'comprimentoPassoMarcha': _data.comprimentoPassoMarcha,
          'alturaPassoMarcha': _data.alturaPassoMarcha,
          'simetriaPassosMarcha': _data.simetriaPassosMarcha,
          'continuidadePassosMarcha': _data.continuidadePassosMarcha,
          'caminharLinhaRetaMarcha': _data.caminharLinhaRetaMarcha,
          'troncoMarcha': _data.troncoMarcha,
          'comprimentoPassoMarchaLongo': _data.comprimentoPassoMarchaLongo,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Tinetti salva com sucesso!'),
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

  String _getTinettiDescription(String itemName, int value, int max) {
    final descriptions = {
      'Sentar': {
        0: 'Incorreto: postura inadequada ou desequilibrada',
        1: 'Correto: postura ereta e estável',
      },
      'Levantar': {
        0: 'Incapaz: não consegue levantar sem ajuda',
        1: 'Usa braços: precisa apoiar nos braços da cadeira',
        2: 'Sem apoio: levanta sem usar os braços',
      },
      'Tentar levantar': {
        0: 'Incapaz: não consegue levantar',
        1: 'Necessita mais de uma tentativa',
        2: 'Consegue em única tentativa',
      },
      'Estabilidade em pé imediata': {
        0: 'Instável: desequilíbrio nos primeiros 5 segundos',
        1: 'Estável com apoio: precisa de apoio',
        2: 'Estável sem apoio: equilibrado sozinho',
      },
      'Estabilidade em pé com toque': {
        0: 'Começa a cair',
        1: 'Agarra ou balança (usa braços para equilibrar)',
        2: 'Equilibrado: mantém-se estável',
      },
      'Fechar os olhos': {
        0: 'Desequilibrado ou instável',
        1: 'Equilibrado: mantém estabilidade com olhos fechados',
      },
      'Rodar 360°': {
        0: 'Passos descontínuos: para ou tropeça',
        1: 'Instável: mostra desequilíbrios durante o giro',
        2: 'Estável: completa o giro sem desequilíbrio',
      },
      'Balancear': {
        0: 'Desequilibrado ou instável',
        1: 'Equilibrado: mantém-se estável ao balançar',
      },
      'Girar cabeça': {
        0: 'Inseguro: erra a distância ou cai na cadeira',
        1: 'Usa braços ou movimentação abrupta',
        2: 'Seguro: movimentação suave e controlada',
      },
      'Comprimento do passo': {
        0: 'Ambos os passos curtos',
        1: 'Um passo (direito ou esquerdo) curto',
        2: 'Ambos os passos adequados',
      },
      'Altura do passo': {
        0: 'Ambos os pés não levantam adequadamente',
        1: 'Um pé não levanta adequadamente',
        2: 'Ambos os pés levantam adequadamente',
      },
      'Simetria dos passos': {
        0: 'Assimetria: passos claramente diferentes',
        1: 'Simetria: passos similares',
      },
      'Continuidade dos passos': {
        0: 'Paradas ou desvios: marcha não contínua',
        1: 'Marcha contínua: sem paradas ou desvios',
      },
      'Caminhar em linha reta': {
        0: 'Marcação desviada: não consegue manter linha reta',
        1: 'Marcação sem desvios: mantém linha reta',
      },
      'Tronco': {
        0: 'Oscilante ou uso de auxílio',
        1: 'Sem oscilações e sem uso de auxílio',
      },
      'Comprimento do passo (marcha)': {
        0: 'Passo muito curto',
        1: 'Passo adequado',
        2: 'Passo longo e seguro',
      },
    };
    
    final itemDescriptions = descriptions[itemName];
    if (itemDescriptions != null && itemDescriptions.containsKey(value)) {
      return itemDescriptions[value]!;
    }
    return '';
  }

  Widget _buildSliderItem(String title, int value, int max, ValueChanged<int> onChanged) {
    final description = _getTinettiDescription(title, value, max);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('0', style: TextStyle(fontSize: 10)),
                Text('$value/$max', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Text('$max', style: const TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: max.toDouble(),
              divisions: max,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.brown,
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.brown.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Score $value: $description',
                        style: TextStyle(fontSize: 11, color: Colors.brown.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
        title: const Text('Tinetti Balance Assessment'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tinetti Balance Assessment',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Parte A - Equilíbrio (0-16 pontos)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSliderItem('Sentar', _data.sentarEquilibrio, 1, (val) => setState(() => _data.sentarEquilibrio = val)),
          _buildSliderItem('Levantar', _data.levantarEquilibrio, 1, (val) => setState(() => _data.levantarEquilibrio = val)),
          _buildSliderItem('Tentar levantar', _data.tentarLevantarEquilibrio, 2, (val) => setState(() => _data.tentarLevantarEquilibrio = val)),
          _buildSliderItem('Estabilidade em pé imediata', _data.estabilidadePeEquilibrio, 1, (val) => setState(() => _data.estabilidadePeEquilibrio = val)),
          _buildSliderItem('Estabilidade em pé com toque', _data.estabilidadePeComTosEquilibrio, 2, (val) => setState(() => _data.estabilidadePeComTosEquilibrio = val)),
          _buildSliderItem('Fechar os olhos', _data.fecharOlhosEquilibrio, 1, (val) => setState(() => _data.fecharOlhosEquilibrio = val)),
          _buildSliderItem('Rodar 360°', _data.rodar360Equilibrio, 4, (val) => setState(() => _data.rodar360Equilibrio = val)),
          _buildSliderItem('Balancear', _data.balancarEquilibrio, 1, (val) => setState(() => _data.balancarEquilibrio = val)),
          _buildSliderItem('Girar cabeça', _data.girarCabecaEquilibrio, 2, (val) => setState(() => _data.girarCabecaEquilibrio = val)),
          const SizedBox(height: 12),
          const Text(
            'Parte B - Marcha (0-12 pontos)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSliderItem('Comprimento do passo', _data.comprimentoPassoMarcha, 2, (val) => setState(() => _data.comprimentoPassoMarcha = val)),
          _buildSliderItem('Altura do passo', _data.alturaPassoMarcha, 2, (val) => setState(() => _data.alturaPassoMarcha = val)),
          _buildSliderItem('Simetria dos passos', _data.simetriaPassosMarcha, 1, (val) => setState(() => _data.simetriaPassosMarcha = val)),
          _buildSliderItem('Continuidade dos passos', _data.continuidadePassosMarcha, 1, (val) => setState(() => _data.continuidadePassosMarcha = val)),
          _buildSliderItem('Caminhar em linha reta', _data.caminharLinhaRetaMarcha, 2, (val) => setState(() => _data.caminharLinhaRetaMarcha = val)),
          _buildSliderItem('Tronco', _data.troncoMarcha, 2, (val) => setState(() => _data.troncoMarcha = val)),
          _buildSliderItem('Comprimento do passo (marcha)', _data.comprimentoPassoMarchaLongo, 2, (val) => setState(() => _data.comprimentoPassoMarchaLongo = val)),
          const SizedBox(height: 16),
          Card(
            color: scoreTotal >= 25 ? Colors.green : scoreTotal >= 19 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Equilíbrio: ${_data.scoreEquilibrio}/16 | Marcha: ${_data.scoreMarcha}/12',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Score Total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$scoreTotal/28',
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
              await _salvarTinetti();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Tinetti'),
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
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
