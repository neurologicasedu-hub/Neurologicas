import 'package:flutter/material.dart';
import '../models/abc_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class ABCScreen extends StatefulWidget {
  const ABCScreen({super.key});

  @override
  State<ABCScreen> createState() => _ABCScreenState();
}

class _ABCScreenState extends State<ABCScreen> {
  final ABCData _data = ABCData();

  Future<void> _salvarABC() async {
    try {
      final score = CompletedScore(
        scoreName: 'ABC Scale - Activities-Specific Balance Confidence',
        scoreData: {
          'andarCasa': _data.andarCasa,
          'subirDescerEscadas': _data.subirDescerEscadas,
          'pegarObjetoChao': _data.pegarObjetoChao,
          'alcancarAcimaCabeca': _data.alcancarAcimaCabeca,
          'andarCalcadasIrregulares': _data.andarCalcadasIrregulares,
          'andarSuperficiesEscorregadias': _data.andarSuperficiesEscorregadias,
          'andarMultidoes': _data.andarMultidoes,
          'andarRampa': _data.andarRampa,
          'andarEscadasRolantes': _data.andarEscadasRolantes,
          'subirDescerCalcadas': _data.subirDescerCalcadas,
          'andarSemCorrimao': _data.andarSemCorrimao,
          'andarVirarRapidamente': _data.andarVirarRapidamente,
          'andarForaSozinho': _data.andarForaSozinho,
          'entrarSairCarro': _data.entrarSairCarro,
          'tomarBanhoSemApoio': _data.tomarBanhoSemApoio,
          'andarConversar': _data.andarConversar,
        },
        resultado: _data.interpretacao,
        totalScore: _data.pontuacaoMedia.round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ABC salva com sucesso!'),
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
                Text('$value%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pontuacao = _data.pontuacaoMedia;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ABC Scale'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Activities-Specific Balance Confidence Scale',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Quanto você está confiante de que pode manter o equilíbrio e não cair ao realizar cada uma das seguintes atividades? (0% = sem confiança, 100% = totalmente confiante)',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _buildSliderItem('Andar pela casa', _data.andarCasa, (val) => setState(() => _data.andarCasa = val)),
          _buildSliderItem('Subir ou descer escadas', _data.subirDescerEscadas, (val) => setState(() => _data.subirDescerEscadas = val)),
          _buildSliderItem('Pegar um objeto no chão', _data.pegarObjetoChao, (val) => setState(() => _data.pegarObjetoChao = val)),
          _buildSliderItem('Alcançar algo acima da cabeça', _data.alcancarAcimaCabeca, (val) => setState(() => _data.alcancarAcimaCabeca = val)),
          _buildSliderItem('Andar em calçadas irregulares', _data.andarCalcadasIrregulares, (val) => setState(() => _data.andarCalcadasIrregulares = val)),
          _buildSliderItem('Andar em superfícies escorregadias', _data.andarSuperficiesEscorregadias, (val) => setState(() => _data.andarSuperficiesEscorregadias = val)),
          _buildSliderItem('Andar em multidões', _data.andarMultidoes, (val) => setState(() => _data.andarMultidoes = val)),
          _buildSliderItem('Andar em uma rampa', _data.andarRampa, (val) => setState(() => _data.andarRampa = val)),
          _buildSliderItem('Andar em escadas rolantes', _data.andarEscadasRolantes, (val) => setState(() => _data.andarEscadasRolantes = val)),
          _buildSliderItem('Subir e descer de calçadas', _data.subirDescerCalcadas, (val) => setState(() => _data.subirDescerCalcadas = val)),
          _buildSliderItem('Andar em superfícies sem corrimão', _data.andarSemCorrimao, (val) => setState(() => _data.andarSemCorrimao = val)),
          _buildSliderItem('Andar e virar rapidamente', _data.andarVirarRapidamente, (val) => setState(() => _data.andarVirarRapidamente = val)),
          _buildSliderItem('Andar fora de casa sozinho', _data.andarForaSozinho, (val) => setState(() => _data.andarForaSozinho = val)),
          _buildSliderItem('Entrar ou sair de um carro', _data.entrarSairCarro, (val) => setState(() => _data.entrarSairCarro = val)),
          _buildSliderItem('Tomar banho sem apoio', _data.tomarBanhoSemApoio, (val) => setState(() => _data.tomarBanhoSemApoio = val)),
          _buildSliderItem('Andar e conversar ao mesmo tempo', _data.andarConversar, (val) => setState(() => _data.andarConversar = val)),
          const SizedBox(height: 16),
          Card(
            color: pontuacao >= 67 ? Colors.green : Colors.orange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Pontuação Média',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${pontuacao.toStringAsFixed(1)}%',
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
              await _salvarABC();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala ABC'),
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
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
