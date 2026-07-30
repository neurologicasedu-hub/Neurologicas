import 'package:flutter/material.dart';
import '../models/nihss_data.dart';
import '../models/patient_data.dart';
import '../services/patient_service.dart';
import '../helpers/auto_save_mixin.dart';
import 'nihss_result_screen.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class NIHSSScreen extends StatefulWidget {
  const NIHSSScreen({super.key});

  @override
  State<NIHSSScreen> createState() => _NIHSSScreenState();
}

class _NIHSSScreenState extends State<NIHSSScreen> with AutoSaveMixin {
  final NIHSSData _nihssData = NIHSSData();
  final TextEditingController _pesoController = TextEditingController();
  bool _pesoSalvo = false;
  double? _niprideDose = 0.5;
  final TextEditingController _pasController = TextEditingController();
  final TextEditingController _padController = TextEditingController();
  bool _isHighBP = false;

  void _checkBP() {
    final pas = double.tryParse(_pasController.text);
    final pad = double.tryParse(_padController.text);
    if (pas != null && pad != null) {
      setState(() {
        _isHighBP = pas > 185 || pad > 110;
      });
    } else {
      if (_isHighBP) setState(() => _isHighBP = false);
    }
  }

  String _calculateNiprideRate() {
    final peso = double.tryParse(_pesoController.text.replaceAll(',', '.'));
    if (peso == null || _niprideDose == null) return '--';
    
    // Formula: (Dose * Peso * 60) / Concentration (200mcg/ml)
    const concentration = 200.0; 
    final rate = (_niprideDose! * peso * 60) / concentration;
    
    return rate.toStringAsFixed(1);
  }

  @override
  String get scaleName => 'nihss';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'nihssData': _nihssData.toJson(),
      'pesoText': _pesoController.text,
      'pesoSalvo': _pesoSalvo,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    if (data.containsKey('nihssData')) {
      final nihssJson = data['nihssData'] as Map<String, dynamic>;
      _nihssData.nivelConsciencia = nihssJson['nivelConsciencia'] ?? 0;
      _nihssData.perguntasConsciencia = nihssJson['perguntasConsciencia'] ?? 0;
      _nihssData.comandosConsciencia = nihssJson['comandosConsciencia'] ?? 0;
      _nihssData.olharConjugado = nihssJson['olharConjugado'] ?? 0;
      _nihssData.campoVisual = nihssJson['campoVisual'] ?? 0;
      _nihssData.paralisiaFacial = nihssJson['paralisiaFacial'] ?? 0;
      _nihssData.motorBracoEsquerdo = nihssJson['motorBracoEsquerdo'] ?? 0;
      _nihssData.motorBracoDireito = nihssJson['motorBracoDireito'] ?? 0;
      _nihssData.motorPernaEsquerda = nihssJson['motorPernaEsquerda'] ?? 0;
      _nihssData.motorPernaDireita = nihssJson['motorPernaDireita'] ?? 0;
      _nihssData.ataxia = nihssJson['ataxia'] ?? 0;
      _nihssData.sensibilidade = nihssJson['sensibilidade'] ?? 0;
      _nihssData.linguagem = nihssJson['linguagem'] ?? 0;
      _nihssData.disartria = nihssJson['disartria'] ?? 0;
      _nihssData.desatencao = nihssJson['desatencao'] ?? 0;
      _nihssData.pesoPaciente = nihssJson['pesoPaciente'];
    }
    if (data.containsKey('pesoText')) {
      _pesoController.text = data['pesoText'] ?? '';
    }
    if (data.containsKey('pesoSalvo')) {
      _pesoSalvo = data['pesoSalvo'] ?? false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _carregarDadosPaciente();
    loadTemporaryData();
  }

  Future<void> _carregarDadosPaciente() async {
    final patient = await PatientService.loadPatientData();
    if (patient != null && patient.peso != null) {
      _pesoController.text = patient.peso!.toStringAsFixed(1);
      _nihssData.pesoPaciente = patient.peso;
      setState(() {
        _pesoSalvo = true;
      });
    }
  }

  Future<void> _salvarPeso() async {
    final peso = double.tryParse(_pesoController.text.replaceAll(',', '.'));
    if (peso != null && peso > 0) {
      final patient = await PatientService.loadPatientData() ?? PatientData();
      patient.peso = peso;
      await PatientService.savePatient(patient);
      _nihssData.pesoPaciente = peso;
      setState(() {
        _pesoSalvo = true;
      });
      onDataChanged();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Peso salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um peso válido'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _calcularNIHSS() {
    clearTemporaryData();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NIHSSResultScreen(nihssData: _nihssData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'NIHSS - Escala de AVC',
      body: [
        _buildWeightCard(),
        _buildBPCard(),
        _buildQuestion(
          title: '1A. Nível de Consciência',
          value: _nihssData.nivelConsciencia,
          options: const ['0 - Alerta', '1 - Acorda com estímulo', '2 - Estímulo vigoroso', '3 - Irresponsivo'],
          onChanged: (v) => setState(() => _nihssData.nivelConsciencia = v),
        ),
        _buildQuestion(
          title: '1B. Perguntar mês e idade',
          value: _nihssData.perguntasConsciencia,
          options: const ['0 - Duas corretas', '1 - Uma correta', '2 - Nenhuma correta'],
          onChanged: (v) => setState(() => _nihssData.perguntasConsciencia = v),
        ),
        _buildQuestion(
          title: '1C. Comandos',
          subtitle: 'Piscar e apertar mãos',
          value: _nihssData.comandosConsciencia,
          options: const ['0 - Obedece ambos', '1 - Obedece um', '2 - Não obedece'],
          onChanged: (v) => setState(() => _nihssData.comandosConsciencia = v),
        ),
        _buildQuestion(
          title: '2. Melhor olhar conjugado',
          value: _nihssData.olharConjugado,
          options: const ['0 - Normal', '1 - Paralisia parcial', '2 - Desvio forçado'],
          onChanged: (v) => setState(() => _nihssData.olharConjugado = v),
        ),
        _buildQuestion(
          title: '3. Campo Visual',
          value: _nihssData.campoVisual,
          options: const ['0 - Normal', '1 - Hemianopsia parcial', '2 - Hemianopsia completa', '3 - Hemianopsia bilateral'],
          onChanged: (v) => setState(() => _nihssData.campoVisual = v),
        ),
        _buildQuestion(
          title: '4. Paralisia Facial',
          value: _nihssData.paralisiaFacial,
          options: const ['0 - Normal', '1 - Leve', '2 - Central evidente', '3 - Completa'],
          onChanged: (v) => setState(() => _nihssData.paralisiaFacial = v),
        ),
        _buildQuestion(
          title: '5A. Motor Braço Esquerdo',
          value: _nihssData.motorBracoEsquerdo,
          options: const ['0 - Sem queda', '1 - Queda < 10s', '2 - Esforço contra gravidade', '3 - Sem esforço contra gravidade', '4 - Sem movimento'],
          onChanged: (v) => setState(() => _nihssData.motorBracoEsquerdo = v),
        ),
        _buildQuestion(
          title: '5B. Motor Braço Direito',
          value: _nihssData.motorBracoDireito,
          options: const ['0 - Sem queda', '1 - Queda < 10s', '2 - Esforço contra gravidade', '3 - Sem esforço contra gravidade', '4 - Sem movimento'],
          onChanged: (v) => setState(() => _nihssData.motorBracoDireito = v),
        ),
        _buildQuestion(
          title: '6A. Motor Perna Esquerda',
          value: _nihssData.motorPernaEsquerda,
          options: const ['0 - Sem queda', '1 - Queda < 5s', '2 - Esforço contra gravidade', '3 - Sem esforço contra gravidade', '4 - Sem movimento'],
          onChanged: (v) => setState(() => _nihssData.motorPernaEsquerda = v),
        ),
        _buildQuestion(
          title: '6B. Motor Perna Direita',
          value: _nihssData.motorPernaDireita,
          options: const ['0 - Sem queda', '1 - Queda < 5s', '2 - Esforço contra gravidade', '3 - Sem esforço contra gravidade', '4 - Sem movimento'],
          onChanged: (v) => setState(() => _nihssData.motorPernaDireita = v),
        ),
        _buildQuestion(
          title: '7. Ataxia',
          value: _nihssData.ataxia,
          options: const ['0 - Ausente', '1 - Um membro', '2 - Dois membros'],
          onChanged: (v) => setState(() => _nihssData.ataxia = v),
        ),
        _buildQuestion(
          title: '8. Sensibilidade',
          value: _nihssData.sensibilidade,
          options: const ['0 - Normal', '1 - Perda leve/moderada', '2 - Perda completa'],
          onChanged: (v) => setState(() => _nihssData.sensibilidade = v),
        ),
        _buildStimulusImages(
          ['assets/images/nihss_1.png', 'assets/images/nihss_2.png', 'assets/images/nihss_3.png'],
          'Cartões para Linguagem',
        ),
        _buildQuestion(
          title: '9. Linguagem',
          value: _nihssData.linguagem,
          options: const ['0 - Normal', '1 - Afasia leve/moderada', '2 - Afasia severa', '3 - Global/Mutismo'],
          onChanged: (v) => setState(() => _nihssData.linguagem = v),
        ),
        _buildStimulusImages(
          ['assets/images/nihss_4.png'],
          'Cartão para Disartria',
        ),
        _buildQuestion(
          title: '10. Disartria',
          value: _nihssData.disartria,
          options: const ['0 - Normal', '1 - Leve/Moderada', '2 - Severa/Mutismo'],
          onChanged: (v) => setState(() => _nihssData.disartria = v),
        ),
        _buildQuestion(
          title: '11. Desatenção',
          value: _nihssData.desatencao,
          options: const ['0 - Sem alterações', '1 - Desatenção em uma mod.', '2 - Hemi-desatenção profunda'],
          onChanged: (v) => setState(() => _nihssData.desatencao = v),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _calcularNIHSS,
        backgroundColor: const Color(0xFF00509D),
        icon: const Icon(Icons.calculate, color: Colors.white),
        label: const Text('Calcular Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildQuestion({
    required String title,
    String? subtitle,
    required int value,
    required List<String> options,
    required ValueChanged<int> onChanged,
  }) {
    // Generate QuestionOption objects from string list
    List<QuestionOption<int>> optionObjects = [];
    for (int i = 0; i < options.length; i++) {
      optionObjects.add(QuestionOption(label: options[i], value: i));
    }

    return QuestionCard<int>(
      title: title,
      subtitle: subtitle,
      value: value,
      options: optionObjects,
      onChanged: (val) {
        onChanged(val);
        onDataChanged(); // Auto-save trigger
      },
    );
  }

  Widget _buildWeightCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.monitor_weight_outlined, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              const Text('Peso do Paciente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (_pesoSalvo) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _pesoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Peso (kg)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: (_) => onDataChanged(),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _salvarPeso,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00509D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Salvar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBPCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.favorite_border, color: Colors.red, size: 20),
          ),
          title: const Text('Controle de Pressão Arterial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          subtitle: const Text('Parâmetros para Trombólise e Nipride', style: TextStyle(fontSize: 12, color: Colors.grey)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _pasController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'PAS (Sistólica)',
                            suffixText: 'mmHg',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onChanged: (v) => _checkBP(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _padController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'PAD (Diastólica)',
                            suffixText: 'mmHg',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onChanged: (v) => _checkBP(),
                        ),
                      ),
                    ],
                  ),
                  if (_isHighBP)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[100]!),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Contraindicação para Trombólise! (PA > 185/110). Tratar antes.',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  const Text('Calculadora de Nipride', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<double>(
                            decoration: const InputDecoration(
                              labelText: 'Dose (µg/kg/min)',
                              border: InputBorder.none,
                            ),
                            value: _niprideDose,
                            items: [0.5, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0].map((dose) => DropdownMenuItem(value: dose, child: Text(dose.toString()))).toList(),
                            onChanged: (v) => setState(() => _niprideDose = v),
                          ),
                        ),
                        Container(width: 1, height: 40, color: Colors.grey[300]),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Velocidade', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(
                                '${_calculateNiprideRate()} ml/h',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00509D)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStimulusImages(List<String> paths, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.purple[50], borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.image_outlined, color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: paths.map((path) {
                return GestureDetector(
                  onTap: () => _showImageDialog(path),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        path,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                           return Container(
                                  height: 120,
                                  width: 120,
                                  color: Colors.grey[100],
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                );
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            fit: StackFit.loose,
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(backgroundColor: Colors.black54),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  @override
  void dispose() {
    _pesoController.dispose();
    _pasController.dispose();
    _padController.dispose();
    super.dispose();
  }
}
