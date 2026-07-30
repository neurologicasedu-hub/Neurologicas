import 'package:flutter/material.dart';
import '../models/abc_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                    height: 1.3,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$value%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.indigo,
              inactiveTrackColor: Colors.indigo.withOpacity(0.1),
              thumbColor: Colors.indigo,
              overlayColor: Colors.indigo.withOpacity(0.1),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (val) => onChanged(val.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pontuacao = _data.pontuacaoMedia;
    return CalculatorScaffold(
      title: 'ABC Scale',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Confiança no equilíbrio ao realizar atividades.\n(0% = sem confiança, 100% = totalmente confiante)',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          
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
          
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: pontuacao >= 67 ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: (pontuacao >= 67 ? Colors.green : Colors.orange).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'MÉDIA TOTAL',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  '${pontuacao.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                   child: Text(
                    _data.interpretacao,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarABC,
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
