import 'package:flutter/material.dart';
import '../models/berg_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class BergScreen extends StatefulWidget {
  const BergScreen({super.key});

  @override
  State<BergScreen> createState() => _BergScreenState();
}

class _BergScreenState extends State<BergScreen> {
  final BergData _data = BergData();

  Future<void> _salvarBerg() async {
    try {
      final score = CompletedScore(
        scoreName: 'Berg Balance Scale (BBS)',
        scoreData: {
          'sentarLevantar': _data.sentarLevantar,
          'ficarPeSemApoio': _data.ficarPeSemApoio,
          'sentarSemApoio': _data.sentarSemApoio,
          'ficarPeOlhosFechados': _data.ficarPeOlhosFechados,
          'ficarPePesJuntos': _data.ficarPePesJuntos,
          'alcancarFrente': _data.alcancarFrente,
          'pegarObjetoChao': _data.pegarObjetoChao,
          'girarOlharTras': _data.girarOlharTras,
          'girar360': _data.girar360,
          'peNaFrente': _data.peNaFrente,
          'ficarUmPeSo': _data.ficarUmPeSo,
          'transferirCadeiras': _data.transferirCadeiras,
          'inclinarFrente': _data.inclinarFrente,
          'subirDescerDegraus': _data.subirDescerDegraus,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Berg salva com sucesso!'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontSize: 13))),
                Text('$value/4', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.deepPurple,
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
        title: const Text('Berg Balance Scale'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Berg Balance Scale (BBS)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Avaliação de equilíbrio funcional (0-4 pontos por item, máximo 56 pontos)',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _buildSliderItem('Sentar-se para levantar-se', _data.sentarLevantar, (val) => setState(() => _data.sentarLevantar = val)),
          _buildSliderItem('Ficar de pé sem apoio', _data.ficarPeSemApoio, (val) => setState(() => _data.ficarPeSemApoio = val)),
          _buildSliderItem('Sentar sem apoio', _data.sentarSemApoio, (val) => setState(() => _data.sentarSemApoio = val)),
          _buildSliderItem('Ficar de pé com olhos fechados', _data.ficarPeOlhosFechados, (val) => setState(() => _data.ficarPeOlhosFechados = val)),
          _buildSliderItem('Ficar de pé com os pés juntos', _data.ficarPePesJuntos, (val) => setState(() => _data.ficarPePesJuntos = val)),
          _buildSliderItem('Alcançar para frente enquanto em pé', _data.alcancarFrente, (val) => setState(() => _data.alcancarFrente = val)),
          _buildSliderItem('Pegar objeto no chão', _data.pegarObjetoChao, (val) => setState(() => _data.pegarObjetoChao = val)),
          _buildSliderItem('Girar para olhar para trás', _data.girarOlharTras, (val) => setState(() => _data.girarOlharTras = val)),
          _buildSliderItem('Girar 360°', _data.girar360, (val) => setState(() => _data.girar360 = val)),
          _buildSliderItem('Colocar um pé na frente do outro', _data.peNaFrente, (val) => setState(() => _data.peNaFrente = val)),
          _buildSliderItem('Ficar em um pé só', _data.ficarUmPeSo, (val) => setState(() => _data.ficarUmPeSo = val)),
          _buildSliderItem('Transferir-se entre cadeiras', _data.transferirCadeiras, (val) => setState(() => _data.transferirCadeiras = val)),
          _buildSliderItem('Inclinar-se para frente e voltar', _data.inclinarFrente, (val) => setState(() => _data.inclinarFrente = val)),
          _buildSliderItem('Subir e descer degraus', _data.subirDescerDegraus, (val) => setState(() => _data.subirDescerDegraus = val)),
          const SizedBox(height: 16),
          Card(
            color: score >= 45 ? Colors.green : score >= 40 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'BBS Score',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$score/56',
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
              await _salvarBerg();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Berg'),
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
