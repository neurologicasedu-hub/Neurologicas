import 'package:flutter/material.dart';
import '../models/apache_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';

class ApacheScreen extends StatefulWidget {
  const ApacheScreen({super.key});
  @override
  State<ApacheScreen> createState() => _ApacheScreenState();
}

class _ApacheScreenState extends State<ApacheScreen> with AutoSaveMixin {
  final ApacheData _data = ApacheData();
  
  final TextEditingController _ageCtrl = TextEditingController();
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

    return CalculatorScaffold(
      title: 'APACHE II',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Acute Physiology and Chronic Health Evaluation II\nPreencha os valores fisiológicos das primeiras 24h.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          _buildSection('Dados Fisiológicos Básicos', [
            _buildNumberField('Idade', _ageCtrl, 'anos', icon: Icons.person_outline),
            _buildNumberField('Temperatura', _tempCtrl, '°C', icon: Icons.thermostat),
            _buildNumberField('Pressão Arterial Média (PAM)', _mapCtrl, 'mmHg', icon: Icons.speed),
            _buildNumberField('Frequência Cardíaca', _hrCtrl, 'bpm', icon: Icons.favorite_border),
            _buildNumberField('Frequência Respiratória', _rrCtrl, 'irpm', icon: Icons.air),
             _buildNumberField('Glasgow Coma Scale', _gcsCtrl, '3-15', icon: Icons.visibility),
          ]),

          _buildSection('Oxigenação', [
             Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                children: [
                  RadioListTile<double>(
                    title: const Text('FiO₂ < 50% (não intubado/baixa FiO₂)', style: TextStyle(fontSize: 14)),
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
                    title: const Text('FiO₂ ≥ 50%', style: TextStyle(fontSize: 14)),
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
                ],
              ),
             ),
             if (_data.fio2 < 0.5)
              _buildNumberField('PaO₂', _paO2Ctrl, 'mmHg'),
             if (_data.fio2 >= 0.5)
              _buildNumberField('Gradiente A–a', _aaCtrl, 'mmHg'),
          ]),

          _buildSection('Metabólico e Renal', [
             _buildNumberField('pH Arterial', _phCtrl, 'pH'),
             _buildNumberField('HCO₃⁻', _hco3Ctrl, 'mEq/L'),
             _buildNumberField('Sódio (Na)', _naCtrl, 'mEq/L'),
             _buildNumberField('Potássio (K)', _kCtrl, 'mEq/L'),
             _buildNumberField('Creatinina', _creatCtrl, 'mg/dL'),
          ]),

          _buildSection('Hematológico', [
             _buildNumberField('Hematócrito', _hctCtrl, '%'),
             _buildNumberField('Leucócitos', _wbcCtrl, 'x10³/µL'),
          ]),

          _buildSection('Doença Crônica', [
             Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
               child: DropdownButtonHideUnderline(
                 child: DropdownButton<int>(
                  value: _data.opcaoCronica,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Nenhum problema crônico', style: TextStyle(fontSize: 14))),
                    DropdownMenuItem(value: 1, child: Text('Crônico grave - Imunossupressão/Cirrose/etc (+5)', style: TextStyle(fontSize: 14))), // Simplified text for space
                    DropdownMenuItem(value: 2, child: Text('Pós-operatório eletivo (+2)', style: TextStyle(fontSize: 14))),
                  ],
                  onChanged: (v) {
                    setState(() {
                      _data.opcaoCronica = v ?? 0;
                    });
                    onDataChanged();
                  },
                               ),
               ),
             ), 
          ]),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(score),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(score).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('APACHE II SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const SizedBox(height: 4),
                // Show sub-scores? No, just keep it simple.
                 Container(
                   margin: const EdgeInsets.only(top: 12),
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                   child: Column(
                     children: [
                       Text(
                        'Mortalidade Estimada: $mortalidade',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                       const SizedBox(height: 4),
                       Text(
                        interpretacao,
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                     ],
                   ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          Center(
             child: Text(
              'Nota: Este aplicativo é para fins educacionais.\nUse julgamento clínico para decisões.',
              style: TextStyle(color: Colors.grey[500], fontSize: 11, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarApache,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)),
        ),
        ...children,
      ],
    );
  }

  Widget _buildNumberField(String label, TextEditingController ctrl, String suffix, {IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          icon: icon != null ? Icon(icon, color: Colors.teal.withOpacity(0.7), size: 20) : null,
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.grey[600]),
        ),
        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
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
