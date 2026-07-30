import 'package:flutter/material.dart';
import 'dart:async';
import '../models/nitrini_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

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

  final TextEditingController _ageController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _controllers['memoriaIncidentalIntrusoes'] = TextEditingController(text: '0');
    _controllers['memoriaImediataIntrusoes'] = TextEditingController(text: '0');
    _controllers['aprendizadoIntrusoes'] = TextEditingController(text: '0');
    _controllers['memoriaTardiaIntrusoes'] = TextEditingController(text: '0');
    _controllers['reconhecimentoIntrusoes'] = TextEditingController(text: '0');
    _controllers['fluenciaScore'] = TextEditingController(text: '0');
    _controllers['relogioScore'] = TextEditingController(text: '0');
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
       findings.add('Perfil Sugestivo de Demência (DA/DV)');
    } else if (memoryDeficit) {
       findings.add('Déficit de Memória');
    } else if (fluencyDeficit) {
       findings.add('Déficit de Fluência Verbal');
    }
    
    // 3. Reconhecimento
    if (reconhecimento < 9) {
       findings.add('Reconhecimento Anormal');
    }
    
    // 4. Relógio (Lewy/Executivo)
    if (relogio < 3) {
       findings.add('Desenho do Relógio Alterado');
    }

    if (findings.isEmpty) {
      return 'Desempenho dentro do esperado.';
    } else {
      return findings.join('. ');
    }
  }

  int _calculateTotalScore() {
     int recScore = _data.reconhecimentoScore - _data.reconhecimentoIntrusoes;
     if (recScore < 0) recScore = 0;
     
     return _data.nomeacaoScore + 
            _data.memoriaIncidentalScore + 
            _data.memoriaImediataScore + 
            _data.aprendizadoScore + 
            _data.fluenciaVerbalScore + 
            _data.desenhoRelogioScore + 
            _data.memoriaTardiaScore + 
            recScore;
  }
  
  @override
  Widget build(BuildContext context) {
    int currentTotal = _calculateTotalScore();

    return CalculatorScaffold(
      title: 'Bateria Nitrini (BBRC)',
      body: [
            // Demographic Inputs
            Container(
               padding: const EdgeInsets.all(20),
               margin: const EdgeInsets.only(bottom: 24),
               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
               child: Column(
                  children: [
                    TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Idade (anos)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      onChanged: (val) => setState(() => _data.age = int.tryParse(val) ?? 0),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: 'Escolaridade', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
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
            
            // 1. Nomeação
             _buildSectionCard('1. Nomeação', _data.nomeacaoScore, (v) => setState(() => _data.nomeacaoScore = v), showImage: true, imagePath: 'assets/images/nitrini_test.png', instructions: 'Mostre as figuras e peça para nomear.'),

            // 2. Memória Incidental
            _buildSectionCard('2. Memória Incidental', _data.memoriaIncidentalScore, (v) => setState(() => _data.memoriaIncidentalScore = v), intrusionController: _controllers['memoriaIncidentalIntrusoes']!, instructions: 'Ocultar figuras. "Quais figuras acabei de mostrar?"'),

            // 3. Memória Imediata
            _buildSectionCard('3. Memória Imediata', _data.memoriaImediataScore, (v) => setState(() => _data.memoriaImediataScore = v), intrusionController: _controllers['memoriaImediataIntrusoes']!, showImage: true, imagePath: 'assets/images/nitrini_test.png', timerSection: 'imediata', timerDuration: 30, instructions: 'Mostrar figuras por 30s. Ocultar e perguntar.', cutoffLabel: 'Espera-se ≥ 5'),

            // 4. Aprendizado
            _buildSectionCard('4. Aprendizado', _data.aprendizadoScore, (v) => setState(() => _data.aprendizadoScore = v), intrusionController: _controllers['aprendizadoIntrusoes']!, showImage: true, imagePath: 'assets/images/nitrini_test.png', timerSection: 'aprendizado', timerDuration: 30, instructions: 'Mostrar figuras novamente por 30s.', cutoffLabel: 'Espera-se ≥ 7'),

            // 5. Fluência Verbal
            _buildFluencySection(),

            // 6. Relógio (Shulman)
            QuestionCard<int>(
               title: "6. Desenho do Relógio (Shulman)",
               subtitle: "Critérios de avaliação",
               value: _data.desenhoRelogioScore,
               options: const [
                 QuestionOption(label: '5 - Perfeito', value: 5),
                 QuestionOption(label: '4 - Mínimo erro', value: 4),
                 QuestionOption(label: '3 - Repr. inadequada (11:10)', value: 3),
                 QuestionOption(label: '2 - Erro moderado', value: 2),
                 QuestionOption(label: '1 - Grande desorg.', value: 1),
                 QuestionOption(label: '0 - Incapacidade', value: 0),
               ],
               onChanged: (val) => setState(() => _data.desenhoRelogioScore = val),
            ),
            
            // 7. Memória Tardia
            _buildSectionCard('7. Memória Tardia (5 min)', _data.memoriaTardiaScore, (v) => setState(() => _data.memoriaTardiaScore = v), intrusionController: _controllers['memoriaTardiaIntrusoes']!, instructions: '"Quais figuras lhe mostrei há 5 minutos?"', cutoffLabel: 'Espera-se ≥ 6'),

            // 8. Reconhecimento
            _buildSectionCard('8. Reconhecimento', _data.reconhecimentoScore, (v) => setState(() => _data.reconhecimentoScore = v), intrusionController: _controllers['reconhecimentoIntrusoes']!, showImage: true, imagePath: 'assets/images/nitrini_recognition.png', instructions: 'Mostrar folha de reconhecimento.', cutoffLabel: 'Espera-se ≥ 9'),

            // Live Score Card
            Container(
               margin: const EdgeInsets.only(top: 16, bottom: 32),
               padding: const EdgeInsets.all(24),
               decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(24)),
               child: Column(
                  children: [
                     const Text('PONTUAÇÃO TOTAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                     Text('$currentTotal', style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold)),
                     Text(
                       _data.isLiterate ? 'Critério: Alfabetizado' : 'Critério: Analfabeto',
                       style: const TextStyle(color: Colors.white70),
                     ),
                  ],
               ),
            ),
      ],
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _salvarNitrini,
          backgroundColor: Colors.green,
          icon: const Icon(Icons.save, color: Colors.white),
          label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white)),
      ),
    );
  }
  
  Widget _buildSectionCard(String title, int currentScore, Function(int) onScoreChanged, {TextEditingController? intrusionController, bool showImage = false, String? imagePath, String? timerSection, int timerDuration = 0, String? instructions, String? cutoffLabel}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              if (cutoffLabel != null) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)), child: Text(cutoffLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange.shade900))),
            ],
          ),
          if (instructions != null) ...[const SizedBox(height: 8), Text(instructions, style: TextStyle(fontSize: 13, color: Colors.grey[600]))],
          const SizedBox(height: 16),
          
          if (timerSection != null) 
             Center(
               child: ElevatedButton.icon(
                 onPressed: _isTimerRunning ? null : () => _startTimer(timerSection, timerDuration),
                 icon: const Icon(Icons.timer),
                 label: Text(_activeSectionTimer == timerSection ? '$_secondsRemaining s' : 'Iniciar Timer ($timerDuration s)'),
                 style: ElevatedButton.styleFrom(
                   backgroundColor: _activeSectionTimer == timerSection ? Colors.red.shade100 : Colors.blue.shade50,
                   foregroundColor: _activeSectionTimer == timerSection ? Colors.red : Colors.blue,
                   elevation: 0,
                 ),
               ),
             ),

          if (showImage && imagePath != null) ...[
             const SizedBox(height: 16),
             if (_activeSectionTimer == timerSection && _secondsRemaining > 0 || timerSection == null)
                GestureDetector(
                  onTap: () => _showImageDialog(imagePath),
                  child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(imagePath, height: 150, fit: BoxFit.contain)),
                )
             else
                Container(height: 100, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)), child: const Center(child: Text('Imagem Oculta', style: TextStyle(color: Colors.grey)))),
          ],

          const SizedBox(height: 20),
          _buildCounterRow('Acertos', currentScore, onScoreChanged, 10),
          if (intrusionController != null) ...[
              const Divider(height: 24),
              _buildCounterRow('Intrusões', int.tryParse(intrusionController.text) ?? 0, (v) {
                 intrusionController.text = v.toString();
                 _updateIntrusionData(intrusionController, v);
              }, 100),
          ]
        ],
      ),
    );
  }

  Widget _buildCounterRow(String label, int value, Function(int) onChanged, int max) {
      return Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Row(
               children: [
                  _buildCircleBtn(Icons.remove, () => value > 0 ? onChanged(value - 1) : null),
                  SizedBox(width: 40, child: Center(child: Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
                  _buildCircleBtn(Icons.add, () => value < max ? onChanged(value + 1) : null),
               ],
            )
         ],
      );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback? onPressed) {
     return Container(
       width: 32, height: 32,
       decoration: BoxDecoration(color: onPressed != null ? const Color(0xFF00509D).withOpacity(0.1) : Colors.grey[100], shape: BoxShape.circle),
       child: IconButton(icon: Icon(icon, size: 16, color: onPressed != null ? const Color(0xFF00509D) : Colors.grey), onPressed: onPressed, padding: EdgeInsets.zero),
     );
  }

  void _updateIntrusionData(TextEditingController controller, int value) {
      // Helper to update specific data field based on controller instance
      setState(() {
          if (controller == _controllers['memoriaIncidentalIntrusoes']) _data.memoriaIncidentalIntrusoes = value;
          else if (controller == _controllers['memoriaImediataIntrusoes']) _data.memoriaImediataIntrusoes = value;
          else if (controller == _controllers['aprendizadoIntrusoes']) _data.aprendizadoIntrusoes = value;
          else if (controller == _controllers['memoriaTardiaIntrusoes']) _data.memoriaTardiaIntrusoes = value;
          else if (controller == _controllers['reconhecimentoIntrusoes']) _data.reconhecimentoIntrusoes = value;
      });
  }

  Widget _buildFluencySection() {
     return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
              const Text('5. Fluência Verbal (Animais)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Falar nomes de animais durante 1 minuto.', style: TextStyle(fontSize: 13, color: Colors.grey)),
               const SizedBox(height: 16),
               Center(
                 child: ElevatedButton.icon(
                   onPressed: _isTimerRunning ? null : () => _startTimer('fluencia', 60),
                   icon: const Icon(Icons.timer),
                   label: Text(_activeSectionTimer == 'fluencia' ? '$_secondsRemaining s' : 'Iniciar 1 Minuto'),
                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade50, foregroundColor: Colors.blue, elevation: 0),
                 ),
               ),
               const SizedBox(height: 16),
               TextField(
                   controller: _controllers['fluenciaScore'],
                   keyboardType: TextInputType.number,
                   decoration: InputDecoration(labelText: 'Total de Animais', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                   onChanged: (val) => setState(() => _data.fluenciaVerbalScore = int.tryParse(val) ?? 0),
               )
           ],
        ),
     );
  }

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))]),
             ),
             Container(
               height: 400,
               child: InteractiveViewer(child: Image.asset(imagePath, fit: BoxFit.contain)),
             ),
          ],
        ),
      ),
    );
  }
}
