import 'package:flutter/material.dart';
import '../models/nihss_data.dart';
import '../models/patient_data.dart';
import '../widgets/nihss_question_widget.dart';
import '../services/patient_service.dart';
import '../helpers/auto_save_mixin.dart';
import 'nihss_result_screen.dart';

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
      // Contraindicação relativa/absoluta para trombólise se > 185/110
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
    
    // Fórmula: (Dose * Peso * 60) / Concentração (200mcg/ml)
    final concentration = 200.0; // 50mg/250ml
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
    // Limpa dados temporários ao calcular (escala será salva permanentemente)
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('NIHSS - Escala de AVC'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Card do peso do paciente
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Peso do Paciente',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_pesoSalvo) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _pesoController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => onDataChanged(),
                          decoration: const InputDecoration(
                            labelText: 'Peso (kg)',
                            border: OutlineInputBorder(),
                            suffixText: 'kg',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _salvarPeso,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: const Text('Salvar'),
                      ),
                    ],
                  ),
                  if (_pesoSalvo)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'Peso salvo! Será usado em futuras avaliações.',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Controle de Pressão Arterial (com Nipride)
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            elevation: 2,
            color: Colors.red[50],
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: const Text(
                  'Controle de P.A. (Pressão Arterial)',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                subtitle: const Text('Parâmetros para Trombólise e Nipride', style: TextStyle(fontSize: 12)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Inputs de Pressão
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _pasController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'PAS (Sistólica)',
                                  suffixText: 'mmHg',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) => _checkBP(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _padController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'PAD (Diastólica)',
                                  suffixText: 'mmHg',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) => _checkBP(),
                              ),
                            ),
                          ],
                        ),
                        if (_isHighBP)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.warning, color: Colors.red, size: 16),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'PA > 185/110: Contraindicação para Trombólise! Tratar antes.',
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Divider(height: 24, thickness: 1),
                        
                        // Calculadora Nipride (Interna)
                        const Text(
                          'Calculadora de Nitroprussiato (Nipride)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        const Text(
                          'Diluição: 50mg/250ml (200mcg/ml)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<double>(
                                decoration: const InputDecoration(
                                  labelText: 'Dose (µg/kg/min)',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                ),
                                value: _niprideDose,
                                items: const [0.5, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]
                                    .map((dose) => DropdownMenuItem(
                                          value: dose,
                                          child: Text(dose.toString()),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _niprideDose = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    const Text('Velocidade', style: TextStyle(fontSize: 12)),
                                    Text(
                                      _calculateNiprideRate(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const Text('ml/h', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_pesoController.text.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              '⚠️ Insira o peso acima para calcular',
                              style: TextStyle(color: Colors.orange, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lista de perguntas
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                NIHSSQuestionWidget(
                  title: '1A. Nível de Consciência',
                  subtitle: '',
                  value: _nihssData.nivelConsciencia,
                  options: const [
                    '0 - Alerta',
                    '1 - Acorda com estímulo',
                    '2 - Precisa de estímulo vigoroso para acordar',
                    '3 - Irresponsivo',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.nivelConsciencia = value;
                    });
                    onDataChanged();
                  },
                ),
                NIHSSQuestionWidget(
                  title: '1B. Perguntar mês e idade',
                  subtitle: '',
                  value: _nihssData.perguntasConsciencia,
                  options: const [
                    '0 - Duas respostas corretas',
                    '1 - Uma resposta correta',
                    '2 - Nenhuma resposta correta',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.perguntasConsciencia = value;
                    });
                    onDataChanged();
                  },
                ),
                NIHSSQuestionWidget(
                  title: '1C. Comandos',
                  subtitle: 'Piscar e apertar as mãos',
                  value: _nihssData.comandosConsciencia,
                  options: const [
                    '0 - Obedece aos dois comandos',
                    '1 - Obedece um comando',
                    '2 - Não obedece comandos',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.comandosConsciencia = value;
                    });
                    onDataChanged();
                  },
                ),
                NIHSSQuestionWidget(
                  title: '2. Melhor olhar conjugado',
                  subtitle: '',
                  value: _nihssData.olharConjugado,
                  options: const [
                    '0 - Olhar normal',
                    '1 - Paralisia parcial do olhar',
                    '2 - Desvio do olhar forçado ou paralisia completa',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.olharConjugado = value;
                    });
                    onDataChanged();
                  },
                ),
                NIHSSQuestionWidget(
                  title: '3. Campo Visual',
                  subtitle: '',
                  value: _nihssData.campoVisual,
                  options: const [
                    '0 - Sem perda de visão',
                    '1 - Hemianopsia parcial',
                    '2 - Hemianopsia completa',
                    '3 - Hemianopsia bilateral, incluindo cegueira total',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.campoVisual = value;
                    });
                    onDataChanged();
                  },
                ),
                NIHSSQuestionWidget(
                  title: '4. Paralisia Facial',
                  subtitle: '',
                  value: _nihssData.paralisiaFacial,
                  options: const [
                    '0 - Normal',
                    '1 - Paralisia facial leve',
                    '2 - Paralisia facial central evidente',
                    '3 - Paralisia facial completa',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.paralisiaFacial = value;
                    });
                    onDataChanged();
                  },
                ),
                NIHSSQuestionWidget(
                  title: '5A. Motor para braço esquerdo',
                  subtitle: '',
                  value: _nihssData.motorBracoEsquerdo,
                  options: const [
                    '0 - Sem queda',
                    '1 - Queda antes dos 10 segundos completos',
                    '2 - Algum esforço contra a gravidade',
                    '3 - Nenhum esforço contra a gravidade',
                    '4 - Nenhum movimento',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.motorBracoEsquerdo = value;
                    });
                    onDataChanged();
                  },
                ),
                NIHSSQuestionWidget(
                  title: '5B. Motor para braço direito',
                  subtitle: '',
                  value: _nihssData.motorBracoDireito,
                  options: const [
                    '0 - Sem queda',
                    '1 - Queda antes dos 10 segundos completos',
                    '2 - Algum esforço contra a gravidade',
                    '3 - Nenhum esforço contra a gravidade',
                    '4 - Nenhum movimento',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.motorBracoDireito = value;
                    });
                    onDataChanged();
                  },
                ),
                NIHSSQuestionWidget(
                  title: '6A. Motor para perna esquerda',
                  subtitle: '',
                  value: _nihssData.motorPernaEsquerda,
                  options: const [
                    '0 - Sem queda',
                    '1 - Queda antes dos 5 segundos completos',
                    '2 - Algum esforço contra a gravidade',
                    '3 - Nenhum esforço contra a gravidade',
                    '4 - Nenhum movimento',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.motorPernaEsquerda = value;
                    });
                    onDataChanged();
                  },
                ),
                NIHSSQuestionWidget(
                  title: '6B. Motor para perna direita',
                  subtitle: '',
                  value: _nihssData.motorPernaDireita,
                  options: const [
                    '0 - Sem queda',
                    '1 - Queda antes dos 5 segundos completos',
                    '2 - Algum esforço contra a gravidade',
                    '3 - Nenhum esforço contra a gravidade',
                    '4 - Nenhum movimento',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.motorPernaDireita = value;
                    });
                    onDataChanged();
                  },
                ),
                NIHSSQuestionWidget(
                  title: '7. Ataxia',
                  subtitle: '',
                  value: _nihssData.ataxia,
                  options: const [
                    '0 - Ausente',
                    '1 - Presente em um membro',
                    '2 - Presente em dois membros',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.ataxia = value;
                    });
                    onDataChanged();
                  },
                ),
                NIHSSQuestionWidget(
                  title: '8. Sensibilidade',
                  subtitle: '',
                  value: _nihssData.sensibilidade,
                  options: const [
                    '0 - Normal',
                    '1 - Perda sensitiva leve ou moderada',
                    '2 - Perda sensitiva completa',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.sensibilidade = value;
                    });
                    onDataChanged();
                  },
                ),
                _buildStimulusImages(
                  ['assets/images/nihss_1.png', 'assets/images/nihss_2.png', 'assets/images/nihss_3.png'],
                  'Cartões para Avaliação de Linguagem',
                ),
                NIHSSQuestionWidget(
                  title: '9. Linguagem',
                  subtitle: '',
                  value: _nihssData.linguagem,
                  options: const [
                    '0 - Normal',
                    '1 - Afasia leve a moderada',
                    '2 - Afasia severa',
                    '3 - Afasia global ou mutismo',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.linguagem = value;
                    });
                    onDataChanged();
                  },
                ),
                _buildStimulusImages(
                  ['assets/images/nihss_4.png'],
                  'Cartão para Avaliação de Disartria',
                ),
                NIHSSQuestionWidget(
                  title: '10. Disartria',
                  subtitle: '',
                  value: _nihssData.disartria,
                  options: const [
                    '0 - Normal',
                    '1 - Disartria leve a moderada',
                    '2 - Disartria severa ou mutismo',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.disartria = value;
                    });
                    onDataChanged();
                  },
                ),
                NIHSSQuestionWidget(
                  title: '11. Desatenção',
                  subtitle: '',
                  value: _nihssData.desatencao,
                  options: const [
                    '0 - Sem alterações',
                    '1 - Desatenção visual, tátil, auditiva, espacial ou pessoal',
                    '2 - Profunda hemi-desatenção',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _nihssData.desatencao = value;
                    });
                    onDataChanged();
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          // Botão de calcular
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _calcularNIHSS,
                icon: const Icon(Icons.calculate, size: 22),
                label: const Text(
                  'Calcular NIHSS',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _pasController.dispose();
    _padController.dispose();
    super.dispose();
  }

  Widget _buildStimulusImages(List<String> paths, String title) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 8, bottom: 2, left: 0, right: 0),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: paths.map((path) {
                  return GestureDetector(
                    onTap: () => _showImageDialog(path),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: [
                            Image.asset(
                              path,
                              height: 150, // Fixed height for consistency
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  width: 150,
                                  color: Colors.grey[200],
                                  alignment: Alignment.center,
                                  child: const Text('Imagem não encontrada', textAlign: TextAlign.center),
                                );
                              },
                            ),
                            Positioned(
                              right: 4,
                              bottom: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.zoom_in,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
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
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
