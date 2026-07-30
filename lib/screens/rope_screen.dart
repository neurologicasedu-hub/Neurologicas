import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/rope_data.dart';
import '../models/completed_score.dart';
import '../services/patient_service.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';

class RopeScreen extends StatefulWidget {
  const RopeScreen({super.key});

  @override
  State<RopeScreen> createState() => _RopeScreenState();
}

class _RopeScreenState extends State<RopeScreen> with AutoSaveMixin {
  final RopeData _data = RopeData();
  final _idadeController = TextEditingController();

  @override
  String get scaleName => 'rope';

  @override
  Map<String, dynamic> getDataToSave() => _data.toJson();

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    final savedData = RopeData.fromJson(data);
    setState(() {
      _data.historicoHipertensao = savedData.historicoHipertensao;
      _data.historicoDiabetes = savedData.historicoDiabetes;
      _data.historicoAVC_AIT = savedData.historicoAVC_AIT;
      _data.fumante = savedData.fumante;
      _data.infartoCortical = savedData.infartoCortical;
      _data.idade = savedData.idade;
      if (_data.idade != null) _idadeController.text = _data.idade.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPatientData();
    loadTemporaryData();
  }

  Future<void> _loadPatientData() async {
    final patient = await PatientService.loadPatientData();
    if (patient != null && patient.idade != null && _data.idade == null) {
       setState(() {
         _data.idade = patient.idade;
         _idadeController.text = patient.idade.toString();
       });
    }
  }

  Future<void> _salvarRope() async {
    try {
      final score = CompletedScore(
        scoreName: 'RoPE Score',
        scoreData: _data.toJson(),
        resultado: '${_data.score} pontos - ${_data.interpretacao}',
        totalScore: _data.score,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('RoPE Score salvo/calculado!'),
            backgroundColor: Colors.blueAccent,
            action: SnackBarAction(label: 'Relatório', textColor: Colors.white, onPressed: () => Navigator.pushReplacementNamed(context, '/report')),
          ),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.score;
    return CalculatorScaffold(
      title: 'RoPE Score',
      body: [
          const Padding(
             padding: EdgeInsets.only(bottom: 16),
             child: Text('Risk of Paradoxical Embolism\nIdentificação de FOP em AVC criptogênico', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ),
          
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    const Text('1. Idade', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _idadeController,
                      decoration: const InputDecoration(labelText: 'Idade (anos)', border: OutlineInputBorder(), hintText: 'Ex: 45'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (val) {
                        setState(() => _data.idade = int.tryParse(val));
                        onDataChanged();
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('2. Histórico', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    
                    SwitchListTile(
                      title: const Text('Sem Hipertensão (+1 se habilitado)'),
                      subtitle: const Text('Paciente NÃO tem hipertensão?'),
                      value: _data.historicoHipertensao == false,
                      onChanged: (val) {
                         setState(() => _data.historicoHipertensao = !val);
                         onDataChanged();
                      },
                      activeColor: Colors.blueAccent,
                    ),
                    SwitchListTile(
                      title: const Text('Sem Diabetes (+1 se habilitado)'),
                      subtitle: const Text('Paciente NÃO tem diabetes?'),
                      value: _data.historicoDiabetes == false,
                      onChanged: (val) {
                         setState(() => _data.historicoDiabetes = !val);
                         onDataChanged();
                      },
                      activeColor: Colors.blueAccent,
                    ),
                    SwitchListTile(
                      title: const Text('Sem AVC/AIT Prévio (+1 se habilitado)'),
                      subtitle: const Text('Paciente NÃO tem histórico?'),
                      value: _data.historicoAVC_AIT == false,
                      onChanged: (val) {
                         setState(() => _data.historicoAVC_AIT = !val);
                         onDataChanged();
                      },
                      activeColor: Colors.blueAccent,
                    ),
                     SwitchListTile(
                      title: const Text('Não Fumante (+1 se habilitado)'),
                      subtitle: const Text('Paciente NÃO fuma?'),
                      value: _data.fumante == false,
                      onChanged: (val) {
                         setState(() => _data.fumante = !val);
                         onDataChanged();
                      },
                      activeColor: Colors.blueAccent,
                    ),
                    const SizedBox(height: 16),
                    const Text('3. Imagem', style: TextStyle(fontWeight: FontWeight.bold)),
                    SwitchListTile(
                      title: const Text('Infarto Cortical (+1)'),
                      subtitle: const Text('Imagem mostra infarto cortical?'),
                      value: _data.infartoCortical == true,
                      onChanged: (val) {
                         setState(() => _data.infartoCortical = val);
                         onDataChanged();
                      },
                      activeColor: Colors.blueAccent,
                    ),
                 ],
               ),
             ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('RoPE SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                 const SizedBox(height: 8),
                Text('$score', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                const SizedBox(height: 12),
                Text(_data.interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarRope,
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
  
  @override
  void dispose() {
    _idadeController.dispose();
    super.dispose();
  }
}
