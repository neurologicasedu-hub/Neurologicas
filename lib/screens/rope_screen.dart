import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/rope_data.dart';
import '../models/completed_score.dart';
import '../services/patient_service.dart';
import '../helpers/auto_save_mixin.dart';

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
  Map<String, dynamic> getDataToSave() {
    return _data.toJson();
  }

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
      if (_data.idade != null) {
        _idadeController.text = _data.idade.toString();
      }
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
    if (patient != null && patient.idade != null) {
       // Só preenche se ainda não tiver valor (para não sobrescrever input manual salvo)
       if (_data.idade == null) {
         setState(() {
           _data.idade = patient.idade;
           _idadeController.text = patient.idade.toString();
         });
       }
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
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Resultado RoPE'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Text(
                   '${_data.score} Pontos',
                   style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
                 ),
                 const SizedBox(height: 16),
                 Text(
                   _data.interpretacao,
                   textAlign: TextAlign.center,
                   style: const TextStyle(fontSize: 18),
                 ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); // Fecha dialog
                  Navigator.pushReplacementNamed(context, '/report'); // Vai para relatórios
                },
                child: const Text('Ver Relatório'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RoPE Score'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Risk of Paradoxical Embolism (RoPE) Score',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Identificação de FOP relacionado a AVC em pacientes com AVC criptogênico.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          _buildAgeSection(),
          const SizedBox(height: 16),
          _buildSwitchItem(
            'Sem Histórico de Hipertensão (+1)',
            'Paciente NÃO tem histórico de hipertensão?',
            _data.historicoHipertensao == false, // Switch ON means "No Hypertension" (so we confirm the condition for +1)
            (val) {
              setState(() => _data.historicoHipertensao = !val); // If val is true (Switch ON), it means "No HTN", so property is false
              onDataChanged();
            },
          ),
          _buildSwitchItem(
            'Sem Histórico de Diabetes (+1)',
            'Paciente NÃO tem histórico de diabetes?',
             _data.historicoDiabetes == false,
            (val) {
              setState(() => _data.historicoDiabetes = !val);
              onDataChanged();
            },
          ),
          _buildSwitchItem(
            'Sem Histórico de AVC/AIT (+1)',
            'Paciente NÃO tem histórico de AVC ou AIT prévio?',
             _data.historicoAVC_AIT == false,
            (val) {
               setState(() => _data.historicoAVC_AIT = !val);
               onDataChanged();
            },
          ),
          _buildSwitchItem(
            'Não Fumante (+1)',
            'Paciente NÃO é fumante?',
            _data.fumante == false,
            (val) {
              setState(() => _data.fumante = !val);
              onDataChanged();
            },
          ),
          _buildSwitchItem(
            'Infarto Cortical em Imagem (+1)',
            'Exame de imagem mostra infarto cortical?',
            _data.infartoCortical == true,
            (val) {
              setState(() => _data.infartoCortical = val); // For this one, YES adds point, so val directly maps
              onDataChanged();
            },
            isPositiveQuestion: true, // Visual cue
          ),

          const SizedBox(height: 24),
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Pontuação Estimada', style: TextStyle(fontSize: 16)),
                  Text(
                    '${_data.score}', 
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue)
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarRope();
            },
            icon: const Icon(Icons.calculate),
            label: const Text('Calcular e Salvar'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(
                  labelText: 'Idade (anos)',
                  border: OutlineInputBorder(),
                  helperText: '18-29 (5pts), 30-39 (4pts), 40-49 (3pts), 50-59 (2pts), 60-69 (1pt)',
                  helperMaxLines: 2,
                ),
                keyboardType: TextInputType.number,
                
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (val) {
                  setState(() {
                    _data.idade = int.tryParse(val);
                  });
                  onDataChanged();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(String title, String subtitle, bool value, Function(bool) onChanged, {bool isPositiveQuestion = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }
  
  @override
  void dispose() {
    _idadeController.dispose();
    super.dispose();
  }
}
