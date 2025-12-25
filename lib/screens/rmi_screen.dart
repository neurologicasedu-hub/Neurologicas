import 'package:flutter/material.dart';
import '../models/rmi_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class RMIScreen extends StatefulWidget {
  const RMIScreen({super.key});

  @override
  State<RMIScreen> createState() => _RMIScreenState();
}

class _RMIScreenState extends State<RMIScreen> {
  final RMIData _data = RMIData();

  Future<void> _salvarRMI() async {
    try {
      final score = CompletedScore(
        scoreName: 'Rivermead Mobility Index (RMI)',
        scoreData: {
          'girar': _data.girar,
          'sentar': _data.sentar,
          'levantar': _data.levantar,
          'manterEmPe': _data.manterEmPe,
          'transferirCamaCadeira': _data.transferirCamaCadeira,
          'caminhar10m': _data.caminhar10m,
          'caminhar10mSemAjuda': _data.caminhar10mSemAjuda,
          'subirEscadas': _data.subirEscadas,
          'permanecerEmPeSemAjuda': _data.permanecerEmPeSemAjuda,
          'sentarSemAjuda': _data.sentarSemAjuda,
          'levantarSemAjuda': _data.levantarSemAjuda,
          'caminharFora': _data.caminharFora,
          'caminhar5min': _data.caminhar5min,
          'levantarChao': _data.levantarChao,
          'subir4Degraus': _data.subir4Degraus,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala RMI salva com sucesso!'),
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
    final score = _data.totalScore;
    final interpretacao = _data.interpretacao;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rivermead Mobility Index'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Avalie cada item (0 = Não consegue, 1 = Consegue)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildItem('Girar de decúbito dorsal para lateral', _data.girar, (val) => setState(() => _data.girar = val)),
          _buildItem('Sentar-se na beira da cama', _data.sentar, (val) => setState(() => _data.sentar = val)),
          _buildItem('Manter-se sentado na beira da cama', _data.levantar, (val) => setState(() => _data.levantar = val)),
          _buildItem('Manter-se em pé por 10 segundos', _data.manterEmPe, (val) => setState(() => _data.manterEmPe = val)),
          _buildItem('Transferir da cama para cadeira', _data.transferirCamaCadeira, (val) => setState(() => _data.transferirCamaCadeira = val)),
          _buildItem('Caminhar 10m com ajuda', _data.caminhar10m, (val) => setState(() => _data.caminhar10m = val)),
          _buildItem('Caminhar 10m sem ajuda', _data.caminhar10mSemAjuda, (val) => setState(() => _data.caminhar10mSemAjuda = val)),
          _buildItem('Subir e descer escada', _data.subirEscadas, (val) => setState(() => _data.subirEscadas = val)),
          _buildItem('Permanecer em pé sem ajuda por 10 segundos', _data.permanecerEmPeSemAjuda, (val) => setState(() => _data.permanecerEmPeSemAjuda = val)),
          _buildItem('Sentar-se sem ajuda de decúbito', _data.sentarSemAjuda, (val) => setState(() => _data.sentarSemAjuda = val)),
          _buildItem('Levantar-se sem ajuda', _data.levantarSemAjuda, (val) => setState(() => _data.levantarSemAjuda = val)),
          _buildItem('Caminhar fora', _data.caminharFora, (val) => setState(() => _data.caminharFora = val)),
          _buildItem('Caminhar 5 minutos', _data.caminhar5min, (val) => setState(() => _data.caminhar5min = val)),
          _buildItem('Levantar objeto do chão', _data.levantarChao, (val) => setState(() => _data.levantarChao = val)),
          _buildItem('Subir 4 degraus sem ajuda', _data.subir4Degraus, (val) => setState(() => _data.subir4Degraus = val)),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(score),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Pontuação Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/15', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarRMI();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala RMI'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, int value, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 13))),
            Row(
              children: [
                _buildButton('0', value == 0, () => onChanged(0)),
                const SizedBox(width: 8),
                _buildButton('1', value == 1, () => onChanged(1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, bool selected, VoidCallback onPressed) {
    return SizedBox(
      width: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.blueGrey : Colors.grey.shade300,
          foregroundColor: selected ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 13) return Colors.green;
    if (score >= 10) return Colors.lightGreen;
    if (score >= 7) return Colors.orange;
    return Colors.red;
  }
}

