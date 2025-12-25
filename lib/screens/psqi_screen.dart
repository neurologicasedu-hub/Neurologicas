import 'package:flutter/material.dart';
import '../models/psqi_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class PSQIScreen extends StatefulWidget {
  const PSQIScreen({super.key});

  @override
  State<PSQIScreen> createState() => _PSQIScreenState();
}

class _PSQIScreenState extends State<PSQIScreen> {
  final PSQIData _data = PSQIData();
  final TextEditingController _tempoAdormecerController = TextEditingController();
  final TextEditingController _horasSonoController = TextEditingController();
  final TextEditingController _horasCamaController = TextEditingController();

  @override
  void dispose() {
    _tempoAdormecerController.dispose();
    _horasSonoController.dispose();
    _horasCamaController.dispose();
    super.dispose();
  }

  Future<void> _salvarPSQI() async {
    try {
      _data.calcularComponentes();
      final score = CompletedScore(
        scoreName: 'Pittsburgh Sleep Quality Index (PSQI)',
        scoreData: {
          'qualidadeSono': _data.qualidadeSono,
          'tempoAdormecer': _data.tempoAdormecer,
          'horasSono': _data.horasSono,
          'horasCama': _data.horasCama,
          'acordarNoite': _data.acordarNoite,
          'irBanheiro': _data.irBanheiro,
          'dificuldadeRespirar': _data.dificuldadeRespirar,
          'tosseRonco': _data.tosseRonco,
          'muitoFrio': _data.muitoFrio,
          'muitoQuente': _data.muitoQuente,
          'dor': _data.dor,
          'outros': _data.outros,
          'medicacaoSono': _data.medicacaoSono,
          'dificuldadeManterVigil': _data.dificuldadeManterVigil,
          'entusiasmo': _data.entusiasmo,
        },
        resultado: '${_data.totalScore}/21 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala PSQI salva com sucesso!'),
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

  Widget _buildSliderItem(String title, String description, int value, int max, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(description, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('0', style: TextStyle(fontSize: 10)),
                Text('$value/$max', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('$max', style: const TextStyle(fontSize: 10)),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: max.toDouble(),
              divisions: max,
              onChanged: (val) => onChanged(val.toInt()),
              activeColor: Colors.indigo.shade700,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _data.calcularComponentes();
    final score = _data.totalScore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PSQI'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.indigo.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Instruções', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(
                    'Considere seu padrão de sono no último mês. Responda todas as questões.',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.indigo.shade50,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Componente 1: Qualidade Subjetiva do Sono', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          _buildSliderItem(
            'Como você avaliaria a qualidade do seu sono?',
            '0: Muito boa | 1: Boa | 2: Ruim | 3: Muito ruim',
            _data.qualidadeSono,
            3,
            (v) => setState(() => _data.qualidadeSono = v),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.indigo.shade50,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Componente 2: Latência do Sono', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quanto tempo (em minutos) você leva para adormecer?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _tempoAdormecerController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minutos para adormecer',
                      hintText: 'Ex: 30',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final min = int.tryParse(value) ?? 0;
                      setState(() => _data.tempoAdormecer = min);
                    },
                  ),
                  const SizedBox(height: 4),
                  Text('Pontuação automática: ${_data.latenciaPontuacao}/3', style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.indigo.shade50,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Componente 3: Duração do Sono', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quantas horas de sono você tem por noite?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _horasSonoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Horas de sono',
                      hintText: 'Ex: 7.5',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final horas = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                      setState(() => _data.horasSono = horas.round());
                    },
                  ),
                  const SizedBox(height: 4),
                  Text('Pontuação automática: ${_data.duracaoPontuacao}/3', style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.indigo.shade50,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Componente 4: Eficiência do Sono', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quantas horas você passa na cama?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _horasCamaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Horas na cama',
                      hintText: 'Ex: 8',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final horas = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                      setState(() => _data.horasCama = horas.round());
                    },
                  ),
                  const SizedBox(height: 4),
                  Text('Eficiência = (Horas de sono / Horas na cama) × 100', style: TextStyle(fontSize: 9, color: Colors.grey.shade700)),
                  Text('Pontuação automática: ${_data.eficienciaPontuacao}/3', style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.indigo.shade50,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Componente 5: Distúrbios do Sono', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          _buildSliderItem('Acordar no meio da noite ou de madrugada', '0: Nenhuma | 1: ≤1x/semana | 2: 1-2x/semana | 3: ≥3x/semana', _data.acordarNoite, 3, (v) => setState(() => _data.acordarNoite = v)),
          _buildSliderItem('Levantar para ir ao banheiro', '0: Nenhuma | 1: ≤1x/semana | 2: 1-2x/semana | 3: ≥3x/semana', _data.irBanheiro, 3, (v) => setState(() => _data.irBanheiro = v)),
          _buildSliderItem('Dificuldade para respirar bem', '0: Nenhuma | 1: ≤1x/semana | 2: 1-2x/semana | 3: ≥3x/semana', _data.dificuldadeRespirar, 3, (v) => setState(() => _data.dificuldadeRespirar = v)),
          _buildSliderItem('Tosse ou ronco alto', '0: Nenhuma | 1: ≤1x/semana | 2: 1-2x/semana | 3: ≥3x/semana', _data.tosseRonco, 3, (v) => setState(() => _data.tosseRonco = v)),
          _buildSliderItem('Sensação de muito frio', '0: Nenhuma | 1: ≤1x/semana | 2: 1-2x/semana | 3: ≥3x/semana', _data.muitoFrio, 3, (v) => setState(() => _data.muitoFrio = v)),
          _buildSliderItem('Sensação de muito calor', '0: Nenhuma | 1: ≤1x/semana | 2: 1-2x/semana | 3: ≥3x/semana', _data.muitoQuente, 3, (v) => setState(() => _data.muitoQuente = v)),
          _buildSliderItem('Ter dores', '0: Nenhuma | 1: ≤1x/semana | 2: 1-2x/semana | 3: ≥3x/semana', _data.dor, 3, (v) => setState(() => _data.dor = v)),
          _buildSliderItem('Outros distúrbios do sono', '0: Nenhuma | 1: ≤1x/semana | 2: 1-2x/semana | 3: ≥3x/semana', _data.outros, 3, (v) => setState(() => _data.outros = v)),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.indigo.shade50,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Componente 6: Uso de Medicação para Dormir', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          _buildSliderItem('Quão frequentemente você usa medicação para dormir?', '0: Nenhuma | 1: ≤1x/semana | 2: 1-2x/semana | 3: ≥3x/semana', _data.medicacaoSono, 3, (v) => setState(() => _data.medicacaoSono = v)),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.indigo.shade50,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Componente 7: Disfunção Diurna', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          _buildSliderItem('Dificuldade para manter entusiasmo para fazer coisas', '0: Nenhuma | 1: ≤1x/semana | 2: 1-2x/semana | 3: ≥3x/semana', _data.entusiasmo, 3, (v) => setState(() => _data.entusiasmo = v)),
          _buildSliderItem('Dificuldade para manter-se acordado(a)', '0: Nenhuma | 1: ≤1x/semana | 2: 1-2x/semana | 3: ≥3x/semana', _data.dificuldadeManterVigil, 3, (v) => setState(() => _data.dificuldadeManterVigil = v)),
          const SizedBox(height: 16),
          Card(
            color: score <= 5 ? Colors.green : score <= 10 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('PSQI Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/21', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('C1: ${_data.qualidadeSono} | C2: ${_data.latenciaPontuacao} | C3: ${_data.duracaoPontuacao} | C4: ${_data.eficienciaPontuacao} | C5: ${_data.disturbanosPontuacao} | C6: ${_data.medicacaoSono} | C7: ${_data.disfuncaoPontuacao}', style: const TextStyle(fontSize: 10, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarPSQI,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala PSQI'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

