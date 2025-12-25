import 'package:flutter/material.dart';
import '../models/icuaw_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class ICUAWScreen extends StatefulWidget {
  const ICUAWScreen({super.key});
  @override
  State<ICUAWScreen> createState() => _ICUAWScreenState();
}

class _ICUAWScreenState extends State<ICUAWScreen> {
  final ICUAWData _data = ICUAWData();

  Future<void> _salvarICUAW() async {
    try {
      final score = CompletedScore(
        scoreName: 'ICUAW Scale',
        scoreData: {
          'mrcSumScore': _data.mrcSumScore,
          'ombroAbducaoDireita': _data.ombroAbducaoDireita,
          'ombroAbducaoEsquerda': _data.ombroAbducaoEsquerda,
          'cotoveloFlexaoDireita': _data.cotoveloFlexaoDireita,
          'cotoveloFlexaoEsquerda': _data.cotoveloFlexaoEsquerda,
          'punhoExtensaoDireita': _data.punhoExtensaoDireita,
          'punhoExtensaoEsquerda': _data.punhoExtensaoEsquerda,
          'quadrilFlexaoDireita': _data.quadrilFlexaoDireita,
          'quadrilFlexaoEsquerda': _data.quadrilFlexaoEsquerda,
          'joelhoExtensaoDireita': _data.joelhoExtensaoDireita,
          'joelhoExtensaoEsquerda': _data.joelhoExtensaoEsquerda,
          'tornozeloDorsiflexaoDireita': _data.tornozeloDorsiflexaoDireita,
          'tornozeloDorsiflexaoEsquerda': _data.tornozeloDorsiflexaoEsquerda,
        },
        resultado: '${_data.diagnostico} - ${_data.interpretacao}',
        totalScore: _data.mrcSumScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ICUAW salva com sucesso!'),
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

  @override
  Widget build(BuildContext context) {
    final mrcScore = _data.mrcSumScore;
    final temICUAW = _data.temICUAW;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ICUAW Scale'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade600,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Intensive Care Unit Acquired Weakness',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'MRC Sum Score - Avaliação de 6 grupos musculares bilaterais',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'Cada movimento avaliado de 0-5 (MRC)',
            style: TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _buildSectionTitle('Ombro - Abdução'),
          _buildMuscleGroup(
            'Ombro Direito',
            _data.ombroAbducaoDireita,
            (val) => setState(() => _data.ombroAbducaoDireita = val),
          ),
          _buildMuscleGroup(
            'Ombro Esquerdo',
            _data.ombroAbducaoEsquerda,
            (val) => setState(() => _data.ombroAbducaoEsquerda = val),
          ),
          const SizedBox(height: 8),
          _buildSectionTitle('Cotovelo - Flexão'),
          _buildMuscleGroup(
            'Cotovelo Direito',
            _data.cotoveloFlexaoDireita,
            (val) => setState(() => _data.cotoveloFlexaoDireita = val),
          ),
          _buildMuscleGroup(
            'Cotovelo Esquerdo',
            _data.cotoveloFlexaoEsquerda,
            (val) => setState(() => _data.cotoveloFlexaoEsquerda = val),
          ),
          const SizedBox(height: 8),
          _buildSectionTitle('Punho - Extensão'),
          _buildMuscleGroup(
            'Punho Direito',
            _data.punhoExtensaoDireita,
            (val) => setState(() => _data.punhoExtensaoDireita = val),
          ),
          _buildMuscleGroup(
            'Punho Esquerdo',
            _data.punhoExtensaoEsquerda,
            (val) => setState(() => _data.punhoExtensaoEsquerda = val),
          ),
          const SizedBox(height: 8),
          _buildSectionTitle('Quadril - Flexão'),
          _buildMuscleGroup(
            'Quadril Direito',
            _data.quadrilFlexaoDireita,
            (val) => setState(() => _data.quadrilFlexaoDireita = val),
          ),
          _buildMuscleGroup(
            'Quadril Esquerdo',
            _data.quadrilFlexaoEsquerda,
            (val) => setState(() => _data.quadrilFlexaoEsquerda = val),
          ),
          const SizedBox(height: 8),
          _buildSectionTitle('Joelho - Extensão'),
          _buildMuscleGroup(
            'Joelho Direito',
            _data.joelhoExtensaoDireita,
            (val) => setState(() => _data.joelhoExtensaoDireita = val),
          ),
          _buildMuscleGroup(
            'Joelho Esquerdo',
            _data.joelhoExtensaoEsquerda,
            (val) => setState(() => _data.joelhoExtensaoEsquerda = val),
          ),
          const SizedBox(height: 8),
          _buildSectionTitle('Tornozelo - Dorsiflexão'),
          _buildMuscleGroup(
            'Tornozelo Direito',
            _data.tornozeloDorsiflexaoDireita,
            (val) => setState(() => _data.tornozeloDorsiflexaoDireita = val),
          ),
          _buildMuscleGroup(
            'Tornozelo Esquerdo',
            _data.tornozeloDorsiflexaoEsquerda,
            (val) => setState(() => _data.tornozeloDorsiflexaoEsquerda = val),
          ),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(mrcScore),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'MRC Sum Score',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$mrcScore/60',
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _data.diagnostico,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _data.interpretacao,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _data.conduta,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Escala MRC (Medical Research Council):',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('5 - Força normal', style: TextStyle(fontSize: 11)),
                const Text('4 - Movimento ativo contra gravidade e resistência reduzida', style: TextStyle(fontSize: 11)),
                const Text('3 - Movimento ativo contra gravidade', style: TextStyle(fontSize: 11)),
                const Text('2 - Movimento ativo com gravidade eliminada', style: TextStyle(fontSize: 11)),
                const Text('1 - Contração visível/filável, sem movimento', style: TextStyle(fontSize: 11)),
                const Text('0 - Nenhuma contração visível', style: TextStyle(fontSize: 11)),
                const SizedBox(height: 8),
                Text(
                  'Diagnóstico ICUAW: MRC Sum Score < 48/60',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarICUAW();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala ICUAW'),
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
              backgroundColor: Colors.grey.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildMuscleGroup(String title, int value, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  ICUAWData.mrcDescription(value),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 5,
              divisions: 5,
              label: ICUAWData.mrcDescription(value),
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 48) return Colors.green;
    if (score >= 36) return Colors.orange;
    return Colors.red;
  }
}
