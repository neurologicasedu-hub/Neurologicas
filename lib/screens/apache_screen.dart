import 'package:flutter/material.dart';
import '../models/apache_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

class ApacheScreen extends StatefulWidget {
  const ApacheScreen({super.key});
  @override
  State<ApacheScreen> createState() => _ApacheScreenState();
}

class _ApacheScreenState extends State<ApacheScreen> with AutoSaveMixin {
  final ApacheData _data = ApacheData();
  
  final TextEditingController _ageCtrl = TextEditingController();

  @override
  String get scaleName => 'apache';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'idade': _data.idade,
      'temperatura': _data.temperatura,
      'pressaoArterialMedia': _data.pressaoArterialMedia,
      'frequenciaCardiaca': _data.frequenciaCardiaca,
      'frequenciaRespiratoria': _data.frequenciaRespiratoria,
      'paO2': _data.paO2,
      'gradienteAA': _data.gradienteAA,
      'ph': _data.ph,
      'hco3': _data.hco3,
      'sodio': _data.sodio,
      'potassio': _data.potassio,
      'creatinina': _data.creatinina,
      'hematocrito': _data.hematocrito,
      'leucocitos': _data.leucocitos,
      'glasgowComaScale': _data.glasgowComaScale,
      'fio2': _data.fio2,
      'opcaoCronica': _data.opcaoCronica,
      'ageText': _ageCtrl.text,
      'tempText': _tempCtrl.text,
      'mapText': _mapCtrl.text,
      'hrText': _hrCtrl.text,
      'rrText': _rrCtrl.text,
      'paO2Text': _paO2Ctrl.text,
      'aaText': _aaCtrl.text,
      'phText': _phCtrl.text,
      'hco3Text': _hco3Ctrl.text,
      'naText': _naCtrl.text,
      'kText': _kCtrl.text,
      'creatText': _creatCtrl.text,
      'hctText': _hctCtrl.text,
      'wbcText': _wbcCtrl.text,
      'gcsText': _gcsCtrl.text,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.idade = data['idade'];
    _data.temperatura = data['temperatura'];
    _data.pressaoArterialMedia = data['pressaoArterialMedia'];
    _data.frequenciaCardiaca = data['frequenciaCardiaca'];
    _data.frequenciaRespiratoria = data['frequenciaRespiratoria'];
    _data.paO2 = data['paO2'];
    _data.gradienteAA = data['gradienteAA'];
    _data.ph = data['ph'];
    _data.hco3 = data['hco3'];
    _data.sodio = data['sodio'];
    _data.potassio = data['potassio'];
    _data.creatinina = data['creatinina'];
    _data.hematocrito = data['hematocrito'];
    _data.leucocitos = data['leucocitos'];
    _data.glasgowComaScale = data['glasgowComaScale'];
    _data.fio2 = data['fio2'] ?? 0.21;
    _data.opcaoCronica = data['opcaoCronica'] ?? 0;
    if (data.containsKey('ageText')) _ageCtrl.text = data['ageText'] ?? '';
    if (data.containsKey('tempText')) _tempCtrl.text = data['tempText'] ?? '';
    if (data.containsKey('mapText')) _mapCtrl.text = data['mapText'] ?? '';
    if (data.containsKey('hrText')) _hrCtrl.text = data['hrText'] ?? '';
    if (data.containsKey('rrText')) _rrCtrl.text = data['rrText'] ?? '';
    if (data.containsKey('paO2Text')) _paO2Ctrl.text = data['paO2Text'] ?? '';
    if (data.containsKey('aaText')) _aaCtrl.text = data['aaText'] ?? '';
    if (data.containsKey('phText')) _phCtrl.text = data['phText'] ?? '';
    if (data.containsKey('hco3Text')) _hco3Ctrl.text = data['hco3Text'] ?? '';
    if (data.containsKey('naText')) _naCtrl.text = data['naText'] ?? '';
    if (data.containsKey('kText')) _kCtrl.text = data['kText'] ?? '';
    if (data.containsKey('creatText')) _creatCtrl.text = data['creatText'] ?? '';
    if (data.containsKey('hctText')) _hctCtrl.text = data['hctText'] ?? '';
    if (data.containsKey('wbcText')) _wbcCtrl.text = data['wbcText'] ?? '';
    if (data.containsKey('gcsText')) _gcsCtrl.text = data['gcsText'] ?? '';
    _updateData();
    setState(() {});
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
      _ageCtrl.text = patient.idade!.toString();
      _updateData();
    }
  }
  final TextEditingController _tempCtrl = TextEditingController();
  final TextEditingController _mapCtrl = TextEditingController();
  final TextEditingController _hrCtrl = TextEditingController();
  final TextEditingController _rrCtrl = TextEditingController();
  final TextEditingController _paO2Ctrl = TextEditingController();
  final TextEditingController _aaCtrl = TextEditingController();
  final TextEditingController _phCtrl = TextEditingController();
  final TextEditingController _hco3Ctrl = TextEditingController();
  final TextEditingController _naCtrl = TextEditingController();
  final TextEditingController _kCtrl = TextEditingController();
  final TextEditingController _creatCtrl = TextEditingController();
  final TextEditingController _hctCtrl = TextEditingController();
  final TextEditingController _wbcCtrl = TextEditingController();
  final TextEditingController _gcsCtrl = TextEditingController();

  @override
  void dispose() {
    _ageCtrl.dispose();
    _tempCtrl.dispose();
    _mapCtrl.dispose();
    _hrCtrl.dispose();
    _rrCtrl.dispose();
    _paO2Ctrl.dispose();
    _aaCtrl.dispose();
    _phCtrl.dispose();
    _hco3Ctrl.dispose();
    _naCtrl.dispose();
    _kCtrl.dispose();
    _creatCtrl.dispose();
    _hctCtrl.dispose();
    _wbcCtrl.dispose();
    _gcsCtrl.dispose();
    super.dispose();
  }

  double _d(String s) => double.tryParse(s.replaceAll(',', '.')) ?? double.nan;
  int? _i(String s) => int.tryParse(s);

  Future<void> _salvarApache() async {
    try {
      _updateData();
      final score = CompletedScore(
        scoreName: 'APACHE II',
        scoreData: {
          'idade': _data.idade,
          'temperatura': _data.temperatura,
          'map': _data.pressaoArterialMedia,
          'fc': _data.frequenciaCardiaca,
          'fr': _data.frequenciaRespiratoria,
          'pao2': _data.paO2,
          'gradienteAA': _data.gradienteAA,
          'ph': _data.ph,
          'hco3': _data.hco3,
          'sodio': _data.sodio,
          'potassio': _data.potassio,
          'creatinina': _data.creatinina,
          'hematocrito': _data.hematocrito,
          'leucocitos': _data.leucocitos,
          'gcs': _data.glasgowComaScale,
          'fio2': _data.fio2,
          'opcaoCronica': _data.opcaoCronica,
        },
        resultado: '${_data.interpretacao} - ${_data.mortalidadeEstimada}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala APACHE II salva com sucesso!'),
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

  void _updateData() {
    setState(() {
      _data.idade = _i(_ageCtrl.text);
      _data.temperatura = _d(_tempCtrl.text);
      _data.pressaoArterialMedia = _d(_mapCtrl.text);
      _data.frequenciaCardiaca = _d(_hrCtrl.text);
      _data.frequenciaRespiratoria = _d(_rrCtrl.text);
      _data.paO2 = _d(_paO2Ctrl.text);
      _data.gradienteAA = _d(_aaCtrl.text);
      _data.ph = _d(_phCtrl.text);
      _data.hco3 = _d(_hco3Ctrl.text);
      _data.sodio = _d(_naCtrl.text);
      _data.potassio = _d(_kCtrl.text);
      _data.creatinina = _d(_creatCtrl.text);
      _data.hematocrito = _d(_hctCtrl.text);
      _data.leucocitos = _d(_wbcCtrl.text);
      _data.glasgowComaScale = _i(_gcsCtrl.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    final mortalidade = _data.mortalidadeEstimada;
    final interpretacao = _data.interpretacao;

    return Scaffold(
      appBar: AppBar(
        title: const Text('APACHE II'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'APACHE II — Calculadora',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Preencha os valores (valores extremos nas primeiras 24h). Use °C para temperatura.',
            style: TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _buildNumberField('Idade (anos)', _ageCtrl, 'ex: 65'),
          _buildNumberField('Temperatura (°C)', _tempCtrl, 'ex: 37.0'),
          _buildNumberField('Pressão arterial média (mmHg)', _mapCtrl, 'ex: 75'),
          _buildNumberField('Frequência cardíaca (bpm)', _hrCtrl, 'ex: 90'),
          _buildNumberField('Frequência respiratória (irpm)', _rrCtrl, 'ex: 18'),
          const SizedBox(height: 8),
          const Text(
            'Oxigenação',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          RadioListTile<double>(
            title: const Text('FiO₂ < 50% (não intubado ou baixa FiO₂)'),
            value: 0.21,
            groupValue: _data.fio2,
            onChanged: (v) {
              setState(() {
                _data.fio2 = v ?? 0.21;
                _updateData();
              });
              onDataChanged();
            },
            activeColor: Colors.teal,
          ),
          RadioListTile<double>(
            title: const Text('FiO₂ ≥ 50%'),
            value: 0.5,
            groupValue: _data.fio2,
            onChanged: (v) {
              setState(() {
                _data.fio2 = v ?? 0.5;
                _updateData();
              });
              onDataChanged();
            },
            activeColor: Colors.teal,
          ),
          if (_data.fio2 < 0.5)
            _buildNumberField('PaO₂ (mmHg)', _paO2Ctrl, 'ex: 80'),
          if (_data.fio2 >= 0.5)
            _buildNumberField('Gradiente A–a (mmHg)', _aaCtrl, 'ex: 150'),
          const SizedBox(height: 8),
          _buildNumberField('pH arterial (use se disponível)', _phCtrl, 'ex: 7.35'),
          _buildNumberField('HCO₃⁻ (se pH não disponível) mEq/L', _hco3Ctrl, 'ex: 24'),
          const SizedBox(height: 8),
          _buildNumberField('Sódio (mEq/L)', _naCtrl, 'ex: 140'),
          _buildNumberField('Potássio (mEq/L)', _kCtrl, 'ex: 4.2'),
          _buildNumberField('Creatinina (mg/dL)', _creatCtrl, 'ex: 1.0'),
          _buildNumberField('Hematócrito (%)', _hctCtrl, 'ex: 40'),
          _buildNumberField('Leucócitos (×10³/µL)', _wbcCtrl, 'ex: 8'),
          _buildNumberField('Glasgow Coma Scale (0-15)', _gcsCtrl, 'ex: 15'),
          const SizedBox(height: 8),
          const Text(
            'Problemas de saúde crônicos',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          DropdownButton<int>(
            value: _data.opcaoCronica,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 0, child: Text('Nenhum')),
              DropdownMenuItem(value: 1, child: Text('Crônico grave — não operatório / pós-op emergente (+5)')),
              DropdownMenuItem(value: 2, child: Text('Pós-op eletivo (+2)')),
            ],
            onChanged: (v) {
              setState(() {
                _data.opcaoCronica = v ?? 0;
              });
              onDataChanged();
            },
          ),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(score),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'APACHE II Score',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$score',
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    interpretacao,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mortalidade estimada: $mortalidade',
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                    textAlign: TextAlign.center,
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
                  'Tabela de mortalidade (APACHE-II):',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  '0–4: 4% não cirúrgico / 1% pós-cirúrgico\n5–9: 8% / 3%\n10–14: 15% / 7%\n15–19: 24% / 12%\n20–24: 40% / 30%\n25–29: 55% / 35%\n30–34: ≈73%\n35+: 85% / 88%',
                  style: TextStyle(fontSize: 11),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aviso: este aplicativo é educacional. Para decisões clínicas use ferramentas validadas e protocolos locais.',
                  style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarApache();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala APACHE II'),
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
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController ctrl, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (_) {
          _updateData();
          onDataChanged();
        },
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 9) return Colors.green;
    if (score <= 19) return Colors.orange;
    if (score <= 29) return Colors.deepOrange;
    return Colors.red;
  }
}
