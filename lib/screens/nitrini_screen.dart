import 'package:flutter/material.dart';
import 'dart:async';
import '../models/nitrini_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class NitriniScreen extends StatefulWidget {
  const NitriniScreen({super.key});

  @override
  State<NitriniScreen> createState() => _NitriniScreenState();
}

class _NitriniScreenState extends State<NitriniScreen> {
  final NitriniData _data = NitriniData();
  
  // Timer vars
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _isTimerRunning = false;
  String _activeSectionTimer = '';

  // Controllers for Intrusions/Scores
  final Map<String, TextEditingController> _controllers = {};

  final List<String> _items = [
    'Sapato', 'Casa', 'Pente', 'Chave', 'Avião',
    'Balde', 'Tartaruga', 'Livro', 'Colher', 'Árvore'
  ];

  final TextEditingController _ageController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _controllers['memoriaIncidentalIntrusoes'] = TextEditingController();
    _controllers['memoriaImediataIntrusoes'] = TextEditingController();
    _controllers['aprendizadoIntrusoes'] = TextEditingController();
    _controllers['memoriaTardiaIntrusoes'] = TextEditingController();
    _controllers['reconhecimentoIntrusoes'] = TextEditingController();
    _controllers['fluenciaScore'] = TextEditingController();
    _controllers['relogioScore'] = TextEditingController();
    
    // Listeners for live update if needed, though setState on change covers it.
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controllers.forEach((_, controller) => controller.dispose());
    _ageController.dispose();
    super.dispose();
  }

  void _startTimer(String section, int seconds) {
    if (_isTimerRunning) return;

    setState(() {
      _activeSectionTimer = section;
      _secondsRemaining = seconds;
      _isTimerRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _stopTimer();
        _showTimeUpDialog();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _activeSectionTimer = '';
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tempo Esgotado!'),
        content: const Text('O tempo para esta etapa encerrou.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _salvarNitrini() async {
    try {
      String interpretation = _generateInterpretation();
      final score = CompletedScore(
        scoreName: 'Bateria Breve Nitrini (BBRC)',
        scoreData: _data.toJson(),
        resultado: interpretation,
        totalScore: _calculateTotalScore(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Avaliação salva com sucesso!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Relatório',
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

  String _generateInterpretation() {
    int imediata = _data.memoriaImediataScore;
    int aprendizado = _data.aprendizadoScore;
    int tardia = _data.memoriaTardiaScore;
    int fluencia = _data.fluenciaVerbalScore;
    int relogio = _data.desenhoRelogioScore;
    int reconhecimento = _data.reconhecimentoScore - _data.reconhecimentoIntrusoes;
    
    List<String> findings = [];
    
    // 1. Atenção (Memória Imediata)
    if (imediata < 5) {
      findings.add('Atenção Comprometida (< 5)');
    }
    
    // 2. Pontos Cardeais para Alzheimer/Vascular
    bool memoryDeficit = (aprendizado < 7) || (tardia < 6);
    int fluenciaCutoff = _data.isLiterate ? 13 : 9;
    bool fluencyDeficit = fluencia < fluenciaCutoff;
    
    if (memoryDeficit && fluencyDeficit) {
       findings.add('Perfil Sugestivo de Demência (DA/DV) - Falhas em aprendizado/evocação e fluência');
    } else if (memoryDeficit) {
       findings.add('Déficit de Memória (Aprendizado < 7 ou Tardia < 6)');
    } else if (fluencyDeficit) {
       findings.add('Déficit de Fluência Verbal (Abaixo do esperado)');
    }
    
    // 3. Reconhecimento
    if (reconhecimento < 9) {
       findings.add('Reconhecimento Anormal (< 9)');
    }
    
    // 4. Relógio (Lewy/Executivo)
    if (relogio < 3) { // Using 2 or less as defective based on generic visual scale, usually <4/5 depending on criteria, user guideline implies clock is KEY for Lewy.
       findings.add('Desenho do Relógio Alterado (Atenção para Demência com Corpos de Lewy)');
    }

    if (findings.isEmpty) {
      return 'Desempenho dentro do esperado para a escolaridade.';
    } else {
      return findings.join('. ');
    }
  }


  int _calculateTotalScore() {
     // Note: Reconhecimento is adjusted by intrusions in interpretation, 
     // but usually Total Score sums raw correct items.
     // User guide says "Para o Reconhecimento, o escore final é obtido pela subtração".
     // Assuming Total Score implies summing these final scores.
     int recScore = _data.reconhecimentoScore - _data.reconhecimentoIntrusoes;
     if (recScore < 0) recScore = 0; // Clamp? Usually yes.
     
     return _data.nomeacaoScore + 
            _data.memoriaIncidentalScore + 
            _data.memoriaImediataScore + 
            _data.aprendizadoScore + 
            _data.fluenciaVerbalScore + 
            _data.desenhoRelogioScore + 
            _data.memoriaTardiaScore + 
            recScore;
  }
  
  Color _getStatusColor() {
      // Return color based on simple threshold for visual feedback
      return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    int currentTotal = _calculateTotalScore();

    return Scaffold(
      appBar: AppBar(title: const Text('Bateria Breve Nitrini (BBRC)'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
            // Demographic Inputs
            Card(
              elevation: 2,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Dados do Paciente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Idade (anos)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (val) {
                          setState(() {
                              _data.age = int.tryParse(val) ?? 0;
                          });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Escolaridade', border: OutlineInputBorder()),
                      value: _data.escolaridadeNivel, 
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Analfabeto')),
                        DropdownMenuItem(value: 1, child: Text('Baixa (1-7 anos)')),
                        DropdownMenuItem(value: 2, child: Text('Alta (≥ 8 anos)')),
                      ],
                      onChanged: (val) {
                         setState(() {
                            _data.escolaridadeNivel = val!;
                            _data.isLiterate = val > 0;
                         });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 1. Nomeação
            // ... (rest of sections)
            _buildChecklistSection('1. Nomeação', _data.nomeacaoScore, (v) => setState(() => _data.nomeacaoScore = v), showIntrusions: false, showImage: false, instructions: 'Mostre as figuras e peça para nomear. (Use a imagem impressa ou digital abaixo)'),
            Center(
              child: GestureDetector(
                onTap: () => _showImageDialog('assets/images/nitrini_test.png'),
                child: Hero(
                  tag: 'nitrini_main',
                  child: Image.asset('assets/images/nitrini_test.png', height: 150),
                ),
              ),
            ),
            const Center(child: Text('(Toque na imagem para ampliar)', style: TextStyle(fontSize: 10, color: Colors.grey))),
             const SizedBox(height: 12),
            
            // 2. Memória Incidental
            _buildChecklistSection('2. Memória Incidental', _data.memoriaIncidentalScore, (v) => setState(() => _data.memoriaIncidentalScore = v), intrusionController: _controllers['memoriaIncidentalIntrusoes']!, instructions: 'Ocultar figuras. "Quais figuras acabei de mostrar?"'),

            // 3. Memória Imediata
            _buildChecklistSection('3. Memória Imediata', _data.memoriaImediataScore, (v) => setState(() => _data.memoriaImediataScore = v), intrusionController: _controllers['memoriaImediataIntrusoes']!, showImage: true, timerSection: 'imediata', timerDuration: 30, instructions: 'Mostrar figuras por 30s. "Olhe bem e memorize". Ocultar e perguntar.', cutoffLabel: 'Espera-se ≥ 5'),

            // 4. Aprendizado
            _buildChecklistSection('4. Aprendizado', _data.aprendizadoScore, (v) => setState(() => _data.aprendizadoScore = v), intrusionController: _controllers['aprendizadoIntrusoes']!, showImage: true, timerSection: 'aprendizado', timerDuration: 30, instructions: 'Mostrar figuras novamente por 30s.', cutoffLabel: 'Espera-se ≥ 7'),

            // 5. Fluência Verbal
            _buildFluencySection(),

            // 6. Relógio (Shulman)
            Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const Text('6. Desenho do Relógio (Critérios de Shulman)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const Text('Desenhar círculo, números e ponteiros marcando 11:10.', style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.amber.shade50,
                                child: const Text('Dicas de Erro: \n• Ponteiro menor no 2 (Frequente)\n• Ponteiro maior entre 4 e 5 (Grave)\n• Números fora de posição (Muito Grave)\n⚠️ Muito útil para Demência Corpos de Lewy', style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                            ),
                            const SizedBox(height: 12),
                            ...[
                              {5: '5 - Desenho do relógio perfeito.'},
                              {4: '4 - Mínimo erro visuoespacial.'},
                              {3: '3 - Representação inadequada (11:10), sem grande erro visuoespacial.'},
                              {2: '2 - Erro visuoespacial moderado (impossível ver ponteiros).'},
                              {1: '1 - Grande desorganização visuoespacial.'},
                              {0: '0 - Incapacidade total.'},
                            ].map((option) {
                                int score = option.keys.first;
                                String text = option.values.first;
                                return RadioListTile<int>(
                                  title: Text(text, style: const TextStyle(fontSize: 13)),
                                  value: score,
                                  groupValue: _data.desenhoRelogioScore,
                                  dense: true,
                                  onChanged: (val) => setState(() => _data.desenhoRelogioScore = val!),
                                );
                            }).toList(),
                        ],
                    ),
                ),
            ),
            
            // 7. Memória Tardia
            _buildChecklistSection('7. Memória Tardia (5 min)', _data.memoriaTardiaScore, (v) => setState(() => _data.memoriaTardiaScore = v), intrusionController: _controllers['memoriaTardiaIntrusoes']!, instructions: '"Quais figuras lhe mostrei há 5 minutos?"', cutoffLabel: 'Espera-se ≥ 6'),

            // 8. Reconhecimento
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildChecklistSection('8. Reconhecimento', _data.reconhecimentoScore, (v) => setState(() => _data.reconhecimentoScore = v), intrusionController: _controllers['reconhecimentoIntrusoes']!, instructions: 'Mostrar folha de reconhecimento. "Quais já tinha visto?"', cutoffLabel: 'Espera-se ≥ 9'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Nota: Escore Final = Acertos (${_data.reconhecimentoScore}) - Intrusões (${_data.reconhecimentoIntrusoes}) = ${_data.reconhecimentoScore - _data.reconhecimentoIntrusoes}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showImageDialog('assets/images/nitrini_recognition.png'),
                      child: Imagewrapper(
                         child: Image.asset('assets/images/nitrini_recognition.png', height: 150),
                      ),
                    ),
                    const Text('(Toque para ampliar folha de reconhecimento)', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            
            // Live Score Card
            Card(
              color: Colors.green.shade50,
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Pontuação Parcial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                     const SizedBox(height: 8),
                    Text('$currentTotal Pontos', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(height: 4),
                    Text(
                      _data.isLiterate ? 'Critério: Alfabetizado' : 'Critério: Analfabeto',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            // Tabela de Referência (Marcador)
            Card(
              color: Colors.blueGrey.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: const [
                    Text('Tabela de Referência (Pontos de Corte)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 8),
                    Text('Escolaridade: Analfabetos | 1-7 anos | ≥ 8 anos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Divider(),
                    Text('Memória Tardia:  ≤5  |  ≤5  |  ≤5', style: TextStyle(fontSize: 12)),
                    Text('Fluência Verbal: ≤8  |  ≤11 |  ≤12', style: TextStyle(fontSize: 12)),
                    Text('Relógio (Shulman): <3  |  <3  |  <3 (Sugestivo de alteração)', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 4),
                    Text('*Pontuações abaixo destes valores sugerem comprometimento.', style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _salvarNitrini,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: const Text('Salvar Avaliação'),
            ),
        ],
      ),
    );
  }
  
  // Updated Helper: Wrap Timer Image with Zoom
  Widget _buildChecklistSection(String title, int currentScore, Function(int) onScoreChanged, {bool showIntrusions = true, TextEditingController? intrusionController, bool showImage = false, String? timerSection, int timerDuration = 0, String? instructions, String? cutoffLabel}) {
    // ...
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (instructions != null) ...[
                const SizedBox(height: 4),
                Text(instructions, style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
            ],
            if (cutoffLabel != null)
                Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(4)),
                    child: Text(cutoffLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.brown)),
                ),
            const SizedBox(height: 8),
            if (timerSection != null) 
              Row(
                children: [
                   ElevatedButton.icon(
                     onPressed: _isTimerRunning ? null : () => _startTimer(timerSection, timerDuration),
                     icon: const Icon(Icons.timer),
                     label: Text(_activeSectionTimer == timerSection ? '$_secondsRemaining s' : 'Iniciar Tempo (${timerDuration}s)'),
                     style: ElevatedButton.styleFrom(backgroundColor: _activeSectionTimer == timerSection ? Colors.red : Colors.blue),
                   ),
                ],
              ),
            const SizedBox(height: 8),
            if (showImage && (_activeSectionTimer == timerSection && _secondsRemaining > 0))
               GestureDetector(
                 onTap: () => _showImageDialog('assets/images/nitrini_test.png'),
                 child: Image.asset('assets/images/nitrini_test.png', height: 200, fit: BoxFit.contain),
               )
            else if (showImage)
               Container(height: 50, color: Colors.grey.shade200, alignment: Alignment.center, child: const Text('Imagem Oculta (Ative o Timer)')),

            // ... (rest is same)
            const SizedBox(height: 12),
            const Text('Itens Corretos:', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildScoreCounter('Total de Acertos', currentScore, onScoreChanged, max: 10),
            
            if (showIntrusions && intrusionController != null) ...[
                const SizedBox(height: 12),
                const Text('Intrusões (Palavras não listadas):', style: TextStyle(fontWeight: FontWeight.bold)),
                // Using a counter instead of text field for intrusions to ensure numeric value
                _buildIntrusionCounter(intrusionController),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildIntrusionCounter(TextEditingController controller) {
      int val = int.tryParse(controller.text) ?? 0;
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              const Text('Total de Intrusões'),
              Row(
                  children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: val > 0 ? () {
                            val--;
                            controller.text = val.toString();
                            _updateIntrusionData(controller, val);
                        } : null,
                      ),
                      Text('$val', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                            val++;
                            controller.text = val.toString();
                            _updateIntrusionData(controller, val);
                        },
                      ),
                  ],
              )
          ],
      );
  }

  void _updateIntrusionData(TextEditingController controller, int value) {
      setState(() {
          if (controller == _controllers['memoriaIncidentalIntrusoes']) _data.memoriaIncidentalIntrusoes = value;
          else if (controller == _controllers['memoriaImediataIntrusoes']) _data.memoriaImediataIntrusoes = value;
          else if (controller == _controllers['aprendizadoIntrusoes']) _data.aprendizadoIntrusoes = value;
          else if (controller == _controllers['memoriaTardiaIntrusoes']) _data.memoriaTardiaIntrusoes = value;
          else if (controller == _controllers['reconhecimentoIntrusoes']) _data.reconhecimentoIntrusoes = value;
      });
  }

  Widget _buildScoreCounter(String label, int value, ValueChanged<int> onChanged, {int max = 10}) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                  children: [
                      IconButton(onPressed: value > 0 ? () => onChanged(value - 1) : null, icon: const Icon(Icons.remove_circle_outline)),
                      Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: value < max ? () => onChanged(value + 1) : null, icon: const Icon(Icons.add_circle_outline)),
                  ],
              )
          ],
      );
  }
  
  Widget _buildFluencySection() {
      return Card(
        elevation: 2,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    const Text('Fluência Verbal (Animais)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Text('Falar nomes de animais durante 1 minuto.', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('Espera-se: ${_data.isLiterate ? '≥ 13 (Alfabetizado)' : '≥ 9 (Analfabeto)'}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                        onPressed: _isTimerRunning ? null : () => _startTimer('fluencia', 60),
                        icon: const Icon(Icons.timer),
                        label: Text(_activeSectionTimer == 'fluencia' ? '$_secondsRemaining s' : 'Iniciar 1 Minuto'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                        controller: _controllers['fluenciaScore'],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Total de Animais', border: OutlineInputBorder()),
                        onChanged: (val) {
                            setState(() {
                                _data.fluenciaVerbalScore = int.tryParse(val) ?? 0;
                            });
                        },
                    )
                ],
            ),
        ),
      );
  }

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
             SizedBox(
               width: double.infinity,
               height: 500, // Large height
               child: InteractiveViewer(
                 child: Image.asset(imagePath, fit: BoxFit.contain),
               ),
             ),
             IconButton(
               icon: const Icon(Icons.close, color: Colors.white),
               onPressed: () => Navigator.pop(context),
             ),
          ],
        ),
      ),
    );
  }
}

// Helper simple wrapper if needed, or just use Container. 
// Using basic widget for now.
class Imagewrapper extends StatelessWidget {
    final Widget child;
    const Imagewrapper({super.key, required this.child});
    @override
    Widget build(BuildContext context) { return child; }
}
