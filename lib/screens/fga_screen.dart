import 'package:flutter/material.dart';
import '../models/fga_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class FGAScreen extends StatefulWidget {
  const FGAScreen({super.key});

  @override
  State<FGAScreen> createState() => _FGAScreenState();
}

class _FGAScreenState extends State<FGAScreen> {
  final FGAData _data = FGAData();

  Future<void> _salvarFGA() async {
    try {
      final score = CompletedScore(
        scoreName: 'Functional Gait Assessment (FGA)',
        scoreData: {
          'caminharSuperficiePlana': _data.caminharSuperficiePlana,
          'caminharMudancaVelocidade': _data.caminharMudancaVelocidade,
          'caminharViradasCabecaHorizontal': _data.caminharViradasCabecaHorizontal,
          'caminharViradasCabecaVertical': _data.caminharViradasCabecaVertical,
          'girar180': _data.girar180,
          'caminharAtravessarObstaculo': _data.caminharAtravessarObstaculo,
          'caminharLinhaRetaTandem': _data.caminharLinhaRetaTandem,
          'subirDescerEscadas': _data.subirDescerEscadas,
          'caminharOlhosFechados': _data.caminharOlhosFechados,
          'caminharCostas': _data.caminharCostas,
          'caminharSuperficieEstreita': _data.caminharSuperficieEstreita,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala FGA salva com sucesso!'),
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

  String _getFGADescription(int value) {
    switch (value) {
      case 0:
        return 'Grave comprometimento: Não consegue completar a tarefa ou precisa de assistência máxima';
      case 1:
        return 'Comprometimento moderado: Completa a tarefa com modificações significativas ou demonstra instabilidade';
      case 2:
        return 'Comprometimento leve: Completa a tarefa com modificações mínimas ou demonstra leve instabilidade';
      case 3:
        return 'Normal: Completa a tarefa sem modificações ou assistência';
      default:
        return '';
    }
  }

  Widget _buildSliderItem(String title, int value, ValueChanged<int> onChanged) {
    final description = _getFGADescription(value);
    
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
                Text('$value/3', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const Text('3', style: TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 3,
              divisions: 3,
              label: '$value - ${["Grave", "Moderado", "Leve", "Normal"][value]}',
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.amber.shade700,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.amber.shade900),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Score $value: $description',
                          style: TextStyle(fontSize: 11, color: Colors.amber.shade900),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '0: Grave | 1: Moderado | 2: Leve | 3: Normal',
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ],
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
        title: const Text('Functional Gait Assessment'),
        centerTitle: true,
        backgroundColor: Colors.amber.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Functional Gait Assessment (FGA)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Avaliação de marcha funcional sob desafios (0-3 pontos por item, máximo 30 pontos)',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _buildSliderItem('Caminhar em superfície plana', _data.caminharSuperficiePlana, (val) => setState(() => _data.caminharSuperficiePlana = val)),
          _buildSliderItem('Caminhar com mudanças de velocidade', _data.caminharMudancaVelocidade, (val) => setState(() => _data.caminharMudancaVelocidade = val)),
          _buildSliderItem('Caminhar com viradas da cabeça (horizontal)', _data.caminharViradasCabecaHorizontal, (val) => setState(() => _data.caminharViradasCabecaHorizontal = val)),
          _buildSliderItem('Caminhar com viradas da cabeça (vertical)', _data.caminharViradasCabecaVertical, (val) => setState(() => _data.caminharViradasCabecaVertical = val)),
          _buildSliderItem('Girar em 180°', _data.girar180, (val) => setState(() => _data.girar180 = val)),
          _buildSliderItem('Caminhar e atravessar obstáculo', _data.caminharAtravessarObstaculo, (val) => setState(() => _data.caminharAtravessarObstaculo = val)),
          _buildSliderItem('Caminhar em linha reta (tandem)', _data.caminharLinhaRetaTandem, (val) => setState(() => _data.caminharLinhaRetaTandem = val)),
          _buildSliderItem('Subir e descer escadas', _data.subirDescerEscadas, (val) => setState(() => _data.subirDescerEscadas = val)),
          _buildSliderItem('Caminhar com os olhos fechados', _data.caminharOlhosFechados, (val) => setState(() => _data.caminharOlhosFechados = val)),
          _buildSliderItem('Caminhar de costas', _data.caminharCostas, (val) => setState(() => _data.caminharCostas = val)),
          _buildSliderItem('Caminhar em superfície estreita', _data.caminharSuperficieEstreita, (val) => setState(() => _data.caminharSuperficieEstreita = val)),
          const SizedBox(height: 16),
          Card(
            color: score > 22 ? Colors.green : Colors.orange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'FGA Score',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$score/30',
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
              await _salvarFGA();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala FGA'),
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
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
