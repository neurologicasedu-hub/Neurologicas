import 'package:flutter/material.dart';
import 'dart:async';
import '../models/moca_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';
import '../widgets/expandable_image.dart';

class MoCAScreen extends StatefulWidget {
  const MoCAScreen({super.key});

  @override
  State<MoCAScreen> createState() => _MoCAScreenState();
}

class _MoCAScreenState extends State<MoCAScreen> with AutoSaveMixin {
  final MoCAData _data = MoCAData();
  String? _selectedEscolaridade;

  @override
  String get scaleName => 'moca';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'data': _serializeMoCAData(),
      'selectedEscolaridade': _selectedEscolaridade,
    };
  }

  Map<String, dynamic> _serializeMoCAData() {
    return {
      'escolaridadeAnos': _data.escolaridadeAnos,
      'dataAno': _data.dataAno,
      'dataMes': _data.dataMes,
      'dataDia': _data.dataDia,
      'diaSemana': _data.diaSemana,
      'local': _data.local,
      'cidade': _data.cidade,
      'memoria1': _data.memoria1,
      'memoria2': _data.memoria2,
      'memoria3': _data.memoria3,
      'memoria4': _data.memoria4,
      'memoria5': _data.memoria5,
      'sequenciaNumeros': _data.sequenciaNumeros,
      'aprendizado': _data.aprendizado,
      'subtracao1': _data.subtracao1,
      'subtracao2': _data.subtracao2,
      'subtracao3': _data.subtracao3,
      'deteccao': _data.deteccao,
      'nomeacao1': _data.nomeacao1,
      'nomeacao2': _data.nomeacao2,
      'nomeacao3': _data.nomeacao3,
      'repeticao1': _data.repeticao1,
      'repeticao2': _data.repeticao2,
      'fluencia': _data.fluencia,
      'abstracao1': _data.abstracao1,
      'abstracao2': _data.abstracao2,
      'recordacao1': _data.recordacao1,
      'recordacao2': _data.recordacao2,
      'recordacao3': _data.recordacao3,
      'recordacao4': _data.recordacao4,
      'recordacao5': _data.recordacao5,
      'orientacao1': _data.orientacao1,
      'orientacao2': _data.orientacao2,
      'orientacao3': _data.orientacao3,
      'alternancia': _data.alternancia,
      'cubo': _data.cubo,
      'relogioContorno': _data.relogioContorno,
      'relogioNumeros': _data.relogioNumeros,
      'relogioPonteiros': _data.relogioPonteiros,
    };
  }

  void _deserializeMoCAData(Map<String, dynamic> data) {
    _data.escolaridadeAnos = data['escolaridadeAnos'] ?? 0;
    _data.dataAno = data['dataAno'] ?? 0;
    _data.dataMes = data['dataMes'] ?? 0;
    _data.dataDia = data['dataDia'] ?? 0;
    _data.diaSemana = data['diaSemana'] ?? 0;
    _data.local = data['local'] ?? 0;
    _data.cidade = data['cidade'] ?? 0;
    _data.memoria1 = data['memoria1'] ?? 0;
    _data.memoria2 = data['memoria2'] ?? 0;
    _data.memoria3 = data['memoria3'] ?? 0;
    _data.memoria4 = data['memoria4'] ?? 0;
    _data.memoria5 = data['memoria5'] ?? 0;
    _data.sequenciaNumeros = data['sequenciaNumeros'] ?? 0;
    _data.aprendizado = data['aprendizado'] ?? 0;
    _data.subtracao1 = data['subtracao1'] ?? 0;
    _data.subtracao2 = data['subtracao2'] ?? 0;
    _data.subtracao3 = data['subtracao3'] ?? 0;
    _data.deteccao = data['deteccao'] ?? 0;
    _data.nomeacao1 = data['nomeacao1'] ?? 0;
    _data.nomeacao2 = data['nomeacao2'] ?? 0;
    _data.nomeacao3 = data['nomeacao3'] ?? 0;
    _data.repeticao1 = data['repeticao1'] ?? 0;
    _data.repeticao2 = data['repeticao2'] ?? 0;
    _data.fluencia = data['fluencia'] ?? 0;
    _data.abstracao1 = data['abstracao1'] ?? 0;
    _data.abstracao2 = data['abstracao2'] ?? 0;
    _data.recordacao1 = data['recordacao1'] ?? 0;
    _data.recordacao2 = data['recordacao2'] ?? 0;
    _data.recordacao3 = data['recordacao3'] ?? 0;
    _data.recordacao4 = data['recordacao4'] ?? 0;
    _data.recordacao5 = data['recordacao5'] ?? 0;
    _data.orientacao1 = data['orientacao1'] ?? 0;
    _data.orientacao2 = data['orientacao2'] ?? 0;
    _data.orientacao3 = data['orientacao3'] ?? 0;
    _data.alternancia = data['alternancia'] ?? 0;
    _data.cubo = data['cubo'] ?? 0;
    _data.relogioContorno = data['relogioContorno'] ?? 0;
    _data.relogioNumeros = data['relogioNumeros'] ?? 0;
    _data.relogioPonteiros = data['relogioPonteiros'] ?? 0;
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    if (data.containsKey('data')) {
      _deserializeMoCAData(data['data'] as Map<String, dynamic>);
    }
    if (data.containsKey('selectedEscolaridade')) {
      _selectedEscolaridade = data['selectedEscolaridade'];
      if (_selectedEscolaridade != null && _escolaridadeMap.containsKey(_selectedEscolaridade)) {
        _data.escolaridadeAnos = _escolaridadeMap[_selectedEscolaridade] ?? 12;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Carregar escolaridade salva se existir
    if (_data.escolaridadeAnos > 0) {
      _selectedEscolaridade = _escolaridadeMap.entries
          .firstWhere((entry) => entry.value == _data.escolaridadeAnos, 
                     orElse: () => const MapEntry('Ensino Médio Completo (12 anos)', 12))
          .key;
    }
    loadTemporaryData();
  }

  // Timer for Fluency
  Timer? _fluenciaTimer;
  int _fluenciaSeconds = 60;
  bool _isFluenciaTimerRunning = false;

  @override
  void dispose() {
    _fluenciaTimer?.cancel();
    super.dispose();
  }

  void _startFluenciaTimer() {
    if (_isFluenciaTimerRunning) return;
    setState(() {
      _isFluenciaTimerRunning = true;
      _fluenciaSeconds = 60;
    });
    _fluenciaTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_fluenciaSeconds > 0) {
          _fluenciaSeconds--;
        } else {
          _fluenciaTimer?.cancel();
          _isFluenciaTimerRunning = false;
        }
      });
    });
  }

  void _stopFluenciaTimer() {
    _fluenciaTimer?.cancel();
    setState(() {
      _isFluenciaTimerRunning = false;
      _fluenciaSeconds = 60;
    });
  }
  
  // Mapeamento de escolaridade para anos
  final Map<String, int> _escolaridadeMap = {
    'Analfabeto (0 anos)': 0,
    'Ensino Fundamental Incompleto (1-4 anos)': 4,
    'Ensino Fundamental Completo (5-8 anos)': 8,
    'Ensino Médio Incompleto (9-11 anos)': 11,
    'Ensino Médio Completo (12 anos)': 12,
    'Ensino Superior Incompleto (13-15 anos)': 15,
    'Ensino Superior Completo (16 anos)': 16,
    'Pós-graduação (17+ anos)': 17,
  };

  Future<void> _salvarMoCA() async {
    try {
      final score = CompletedScore(
        scoreName: 'Montreal Cognitive Assessment (MoCA)',
        scoreData: {
          'totalScore': _data.totalScore,
          'adjustedScore': _data.adjustedScore,
          'escolaridadeAnos': _data.escolaridadeAnos,
          'escolaridade': _selectedEscolaridade ?? 'Não informado',
        },
        resultado: '${_data.adjustedScore}/30 - ${_data.interpretation}${_data.escolaridadeAnos <= 12 && _data.escolaridadeAnos > 0 ? " (Ajustado)" : ""}',
        totalScore: _data.adjustedScore,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala MoCA salva com sucesso!'),
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

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'MoCA Test',
      actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF00509D)),
            onPressed: () {
               showDialog(
                 context: context,
                 builder: (context) => AlertDialog(
                   title: const Text('Reiniciar Teste?'),
                   content: const Text('Isso apagará todos os campos preenchidos.'),
                   actions: [
                     TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                     TextButton(onPressed: () {
                       clearTemporaryData();
                       setState(() {
                         _data.escolaridadeAnos = 0;
                         _selectedEscolaridade = null;
                         _deserializeMoCAData({});
                       });
                       Navigator.pop(context);
                     }, child: const Text('Reiniciar')),
                   ],
                 ),
               );
            },
          )
        ],
      body: [
          // ESCOLARIDADE
          Container(
             margin: const EdgeInsets.only(bottom: 24),
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
                const Row(
                    children: [
                      Icon(Icons.school, color: Color(0xFF00509D)),
                      SizedBox(width: 10),
                      Text('Socioeconômico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedEscolaridade,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Escolaridade",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  items: _escolaridadeMap.keys.map((String key) {
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Text(key, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedEscolaridade = value;
                      if (value != null) {
                        _data.escolaridadeAnos = _escolaridadeMap[value] ?? 12;
                      }
                    });
                    onDataChanged();
                  },
                ),
                 if (_data.escolaridadeAnos <= 12 && _data.escolaridadeAnos > 0)
                   Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(Icons.lightbulb_outline, size: 16, color: Colors.orange.shade800),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '+1 ponto adicionado automaticamente (escolaridade ≤ 12 anos).',
                              style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
                            ),
                          ),
                        ],
                      ),
                   ),
              ],
            ),
          ),

          _buildSectionHeader('Funções Executivas'),

          QuestionCard<int>(
            title: "1. Alternância em Trilha (1 ponto)",
            subtitle: "Ligue os números e letras (1-A-2-B-3-C...)",
            value: _data.alternancia,
            content: const ExpandableImage(imagePath: 'assets/images/Sequencia.png'),
            options: const [QuestionOption(label: 'Executou corretamente', value: 1)],
            onChanged: (val) {
               setState(() => _data.alternancia = (_data.alternancia == 1 ? 0 : 1));
               onDataChanged();
            }
          ),

          QuestionCard<int>(
            title: "2. Cópia do Cubo (1 ponto)",
            subtitle: "Copiar o desenho tridimensional",
            value: _data.cubo,
            content: const ExpandableImage(imagePath: 'assets/images/Cubo.png'),
            options: const [QuestionOption(label: 'Desenho correto (tridimensional, linhas paralelas)', value: 1)],
            onChanged: (val) {
               setState(() => _data.cubo = (_data.cubo == 1 ? 0 : 1));
               onDataChanged();
            }
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("3. Desenho do Relógio (3 pontos)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                const Text('Instrução: "Desenhe um relógio, coloque todos os números e marque a hora 11:10."', style: TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic)),
                const SizedBox(height: 12),
                _buildSwitchTile('Contorno', _data.relogioContorno == 1, (v) => setState(() { _data.relogioContorno = v ? 1 : 0; onDataChanged(); })),
                _buildSwitchTile('Números (todos presentes)', _data.relogioNumeros == 1, (v) => setState(() { _data.relogioNumeros = v ? 1 : 0; onDataChanged(); })),
                _buildSwitchTile('Ponteiros (11:10 correto)', _data.relogioPonteiros == 1, (v) => setState(() { _data.relogioPonteiros = v ? 1 : 0; onDataChanged(); })),
              ]
            )
          ),

          _buildSectionHeader('Nomeação (3 pontos)'),
          
          QuestionCard<int>(
             title: "Nomeação de Animais",
             value: -1, // Not used for selection here
             content: Column(children: [
                const ExpandableImage(imagePath: 'assets/images/Animais.png', height: 120),
                const SizedBox(height: 12),
                _buildSwitchTile('1. Leão', _data.nomeacao3 == 1, (v) => setState(() { _data.nomeacao3 = v ? 1 : 0; onDataChanged(); })), // Changed order to match standard MoCA usually Lion/Rhino/Camel or similar
                _buildSwitchTile('2. Rinoceronte', _data.nomeacao2 == 1, (v) => setState(() { _data.nomeacao2 = v ? 1 : 0; onDataChanged(); })),
                _buildSwitchTile('3. Camelo/Dromedário', _data.nomeacao1 == 1, (v) => setState(() { _data.nomeacao1 = v ? 1 : 0; onDataChanged(); })),
             ]),
             options: const [],
             onChanged: (_) {}
          ),

          _buildSectionHeader('Memória (Imediata)'),
           Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.shade100)),
            child: const Text('ROSTO  -  VELUDO  -  IGREJA  -  MARGARIDA  -  VERMELHO\n\n(Leia 2x. Não pontue agora. Apenas registre que foi feito.)', 
              textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00509D))),
          ),

          _buildSectionHeader('Atenção'),
          
          QuestionCard<int>(
            title: "Dígitos",
            value: -1,
            content: Column(children: [
               _buildSwitchTile('Ordem Direta (2 1 8 5 4)', _data.sequenciaNumeros == 1, (v) => setState(() { _data.sequenciaNumeros = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Ordem Inversa (7 4 2 -> 2 4 7)', _data.aprendizado == 1, (v) => setState(() { _data.aprendizado = v ? 1 : 0; onDataChanged(); })),
            ]),
            options: const [], onChanged: (_) {}
          ),
          
          QuestionCard<int>(
            title: "Detecção de Letras",
            subtitle: "Bata palma na letra A",
            value: _data.deteccao,
            content: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
              child: const Text('F B A C M N A A J K L B A F A K D E A A A J A M O F A A B', style: TextStyle(letterSpacing: 2, fontFamily: 'monospace')),
            ),
            options: const [QuestionOption(label: '≤ 2 erros', value: 1)],
            onChanged: (val) {
               setState(() => _data.deteccao = (_data.deteccao == 1 ? 0 : 1));
               onDataChanged();
            }
          ),

          QuestionCard<int>(
            title: "Subtração (100 - 7)",
            subtitle: "93 - 86 - 79 - 72 - 65",
            value: -1,
            options: const [], // Using custom content
            content: Column(
              children: [
                _buildSubtractionStep('100 - 7 = 93', 0),
                _buildSubtractionStep('93 - 7 = 86', 1),
                _buildSubtractionStep('86 - 7 = 79', 2),
                _buildSubtractionStep('79 - 7 = 72', 3),
                _buildSubtractionStep('72 - 7 = 65', 4),
                 Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'Pontuação: ${(_data.subtracao1 + _data.subtracao2 + _data.subtracao3)}/3',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00509D)),
                  ),
                ),
              ],
            ),
            onChanged: (_) {}
          ),

           _buildSectionHeader('Linguagem'),

           QuestionCard<int>(
             title: "Repetição de Frases",
             value: -1,
             content: Column(children: [
               _buildSwitchTile('Eu somente sei que é João quem será ajudado hoje.', _data.repeticao1 == 1, (v) => setState(() { _data.repeticao1 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('O gato sempre se esconde embaixo do sofá...', _data.repeticao2 == 1, (v) => setState(() { _data.repeticao2 = v ? 1 : 0; onDataChanged(); })),
             ]),
             options: const [], onChanged: (_) {}
           ),

           QuestionCard<int>(
             title: "Fluência Verbal (Letra F)",
             subtitle: "≥ 11 palavras em 1 minuto",
             value: _data.fluencia,
             content: Row(
               children: [
                 Expanded(
                   child: ElevatedButton.icon(
                      onPressed: _isFluenciaTimerRunning ? _stopFluenciaTimer : _startFluenciaTimer,
                      icon: Icon(_isFluenciaTimerRunning ? Icons.stop : Icons.play_arrow),
                      label: Text(_isFluenciaTimerRunning ? '${_fluenciaSeconds}s' : 'Iniciar Timer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFluenciaTimerRunning ? Colors.red.shade50 : Colors.blue.shade50,
                        foregroundColor: _isFluenciaTimerRunning ? Colors.red : Colors.blue,
                        elevation: 0,
                      )
                   ),
                 ),
               ],
             ),
             options: const [QuestionOption(label: 'Conseguiu ≥ 11 palavras', value: 1)],
             onChanged: (val) {
                setState(() => _data.fluencia = (_data.fluencia == 1 ? 0 : 1));
                onDataChanged();
             }
           ),
           
           _buildSectionHeader('Abstração'),
           QuestionCard<int>(
             title: "Semelhanças",
             value: -1,
             content: Column(children: [
               _buildSwitchTile('Trem - Bicicleta (Transporte)', _data.abstracao1 == 1, (v) => setState(() { _data.abstracao1 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Relógio - Régua (Medida)', _data.abstracao2 == 1, (v) => setState(() { _data.abstracao2 = v ? 1 : 0; onDataChanged(); })),
             ]),
             options: const [], onChanged: (_) {}
           ),

           _buildSectionHeader('Evocação Tardia (Memória)'),
           
           QuestionCard<int>(
             title: "Recordação sem Pistas",
             value: -1,
             content: Column(children: [
               _buildSwitchTile('ROSTO', _data.recordacao1 == 1, (v) => setState(() { _data.recordacao1 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('VELUDO', _data.recordacao2 == 1, (v) => setState(() { _data.recordacao2 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('IGREJA', _data.recordacao3 == 1, (v) => setState(() { _data.recordacao3 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('MARGARIDA', _data.recordacao4 == 1, (v) => setState(() { _data.recordacao4 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('VERMELHO', _data.recordacao5 == 1, (v) => setState(() { _data.recordacao5 = v ? 1 : 0; onDataChanged(); })),
             ]),
             options: const [], onChanged: (_) {}
           ),

           _buildSectionHeader('Orientação'),

            QuestionCard<int>(
             title: "Orientação Têmporo-Espacial",
             value: -1,
             content: Column(children: [
               _buildSwitchTile('Dia do Mês', _data.dataDia == 1, (v) => setState(() { _data.dataDia = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Mês', _data.dataMes == 1, (v) => setState(() { _data.dataMes = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Ano', _data.dataAno == 1, (v) => setState(() { _data.dataAno = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Dia da Semana', _data.diaSemana == 1, (v) => setState(() { _data.diaSemana = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Lugar', _data.local == 1, (v) => setState(() { _data.local = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Cidade', _data.cidade == 1, (v) => setState(() { _data.cidade = v ? 1 : 0; onDataChanged(); })),
             ]),
             options: const [], onChanged: (_) {}
           ),

          // Result Card
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(_data.adjustedScore),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(_data.adjustedScore).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('PONTUAÇÃO TOTAL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '${_data.adjustedScore}',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                Text(
                  '/ 30',
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                   child: Text(
                    _data.interpretation,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarMoCA,
        backgroundColor: _getScoreColor(_data.adjustedScore),
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12, top: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF00509D),
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.0,
        ),
      ),
    );
  }



  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: value ? const Color(0xFF00A896).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: value ? const Color(0xFF00A896) : Colors.grey.withOpacity(0.2)),
      ),
      child: SwitchListTile(
        title: Text(title, style: TextStyle(fontSize: 14, fontWeight: value ? FontWeight.bold : FontWeight.normal)),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF00A896),
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Helper for 5-step subtraction
  final List<bool> _subtracoes = List.filled(5, false);
  
  Widget _buildSubtractionStep(String label, int index) {
      // Logic from original file to map boolean steps to score (0-3)
      // This helper needs to integrate with the state properly, but since the original used _data fields directly for final calculation 
      // and a separate transient list for checkboxes, I will simplify to just use local state + update logic.
      // However, to keep it stateless in build, I'll rely on checking the _data fields if possible, or recreate the logic.
      // THE ORIGINAL LOGIC used _subtracoes list. I need to restore that variable in state.
      
      return _buildSwitchTile(label, _subtracoes[index], (val) {
          setState(() {
             _subtracoes[index] = val;
             _updateSubtractionScore();
          });
      });
  }

  void _updateSubtractionScore() {
    int correctCount = _subtracoes.where((b) => b).length;
    setState(() {
      if (correctCount >= 4) {
        _data.subtracao1 = 1; _data.subtracao2 = 1; _data.subtracao3 = 1;
      } else if (correctCount >= 2) {
        _data.subtracao1 = 1; _data.subtracao2 = 1; _data.subtracao3 = 0;
      } else if (correctCount == 1) {
        _data.subtracao1 = 1; _data.subtracao2 = 0; _data.subtracao3 = 0;
      } else {
        _data.subtracao1 = 0; _data.subtracao2 = 0; _data.subtracao3 = 0;
      }
    });
    onDataChanged();
  }

  Color _getScoreColor(int score) {
    if (score >= 26) return Colors.green;
    if (score >= 18) return Colors.orange;
    return Colors.red;
  }
}
