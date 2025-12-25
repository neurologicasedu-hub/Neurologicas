import 'package:flutter/material.dart';
import 'dart:async';
import '../models/moca_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

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

  // Transient state for Immediate Memory (not saved in score, just UI state)
  final List<bool> _memoriaImediata = List.filled(5, false);

  // Transient state for Subtraction (5 steps)
  final List<bool> _subtracoes = List.filled(5, false);

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

  void _updateSubtractionScore() {
    int correctCount = _subtracoes.where((b) => b).length;
    
    // Logic: 4-5 correct -> 3 pts
    //        2-3 correct -> 2 pts
    //        1   correct -> 1 pt
    
    setState(() {
      if (correctCount >= 4) {
        _data.subtracao1 = 1; 
        _data.subtracao2 = 1; 
        _data.subtracao3 = 1;
      } else if (correctCount >= 2) {
        _data.subtracao1 = 1; 
        _data.subtracao2 = 1; 
        _data.subtracao3 = 0;
      } else if (correctCount == 1) {
        _data.subtracao1 = 1; 
        _data.subtracao2 = 0; 
        _data.subtracao3 = 0;
      } else {
        _data.subtracao1 = 0; 
        _data.subtracao2 = 0; 
        _data.subtracao3 = 0;
      }
    });
    onDataChanged();
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

  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Container(
      width: double.infinity,
      color: Colors.deepPurple,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(top: 24, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.1,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInstructionBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 24, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade900,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(String title, String instruction, int value, ValueChanged<int> onChanged) {
    return Card(
      elevation: 0,
      color: value == 1 ? Colors.green.shade50 : Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: value == 1 ? Colors.green : Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: () {
          onChanged(value == 1 ? 0 : 1);
          onDataChanged();
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                value == 1 ? Icons.check_box : Icons.check_box_outline_blank,
                color: value == 1 ? Colors.green : Colors.grey,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(
                      fontSize: 15, 
                      fontWeight: value == 1 ? FontWeight.bold : FontWeight.normal,
                      color: value == 1 ? Colors.green.shade900 : Colors.black87
                    )),
                    if (instruction.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(instruction, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageInstruction(String imagePath, String instruction, {double height = 180}) {
    return Column(
      children: [
        if (instruction.isNotEmpty) _buildInstructionBox(instruction),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.zero,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 4,
                      child: Image.asset(imagePath, fit: BoxFit.contain),
                    ),
                    Positioned(
                      top: 40,
                      right: 20,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Container(
            height: height,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                    child: const Icon(Icons.zoom_in, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoCA Test'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
               // Confirm reset
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
      ),
      body: ListView(
        children: [
          // ESCOLARIDADE
          Card(
            margin: const EdgeInsets.all(12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, color: Colors.deepPurple),
                      SizedBox(width: 10),
                      Text('Dados do Paciente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple)),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('ESCOLARIDADE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedEscolaridade,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    hint: const Text("Selecione a escolaridade"),
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
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline, size: 16, color: Colors.orange.shade800),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Adicione 1 ponto ao total se escolaridade ≤ 12 anos.',
                            style: TextStyle(fontSize: 13, color: Colors.brown),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 1. FUNÇÕES EXECUTIVAS / VISOESPACIAL
          _buildSectionHeader('Funções Executivas / Visuoespacial', subtitle: 'Max: 5 pontos'),
          
          // Alternância
          const Padding(
             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             child: Text("1. Alternância em Trilha (1 ponto)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          _buildImageInstruction('assets/images/Sequencia.png', 'Instrução: "Ligue os números e letras em ordem crescente (1-A-2-B-3-C-4-D-5-E)."'),
          _buildCheckboxItem('Executou corretamente (sem erros)', 'O paciente ligou os pontos corretamente sem cruzar linhas.', _data.alternancia, (val) => setState(() => _data.alternancia = val)),
          
          const Divider(thickness: 1, height: 30),

          // Cubo
          const Padding(
             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             child: Text("2. Cópia do Cubo (1 ponto)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          _buildImageInstruction('assets/images/Cubo.png', 'Instrução: "Copie este desenho o mais precisamente possível no espaço abaixo."'),
          _buildCheckboxItem('Desenho correto', 'Tridimensional, todas as linhas presentes, linhas paralelas.', _data.cubo, (val) => setState(() => _data.cubo = val)),

          const Divider(thickness: 1, height: 30),

          // Relógio
          const Padding(
             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             child: Text("3. Desenho do Relógio (3 pontos)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          _buildInstructionBox('Instrução: "Desenhe um relógio, coloque todos os números e marque a hora 11:10."'),
          _buildCheckboxItem('Contorno', 'O contorno deve ser um círculo fechado.', _data.relogioContorno, (val) => setState(() => _data.relogioContorno = val)),
          _buildCheckboxItem('Números', 'Todos os 12 números presentes e na posição correta.', _data.relogioNumeros, (val) => setState(() => _data.relogioNumeros = val)),
          _buildCheckboxItem('Ponteiros', 'Dois ponteiros indicando hora correta (11:10).', _data.relogioPonteiros, (val) => setState(() => _data.relogioPonteiros = val)),

          // 2. NOMEAÇÃO
          _buildSectionHeader('Nomeação', subtitle: 'Max: 3 pontos'),
          _buildImageInstruction('assets/images/Animais.png', 'Instrução: "Diga o nome de cada animal, da esquerda para a direita."', height: 150),
          _buildCheckboxItem('1. Elefante', '', _data.nomeacao1, (val) => setState(() => _data.nomeacao1 = val)),
          _buildCheckboxItem('2. Rinoceronte', '', _data.nomeacao2, (val) => setState(() => _data.nomeacao2 = val)),
          _buildCheckboxItem('3. Leão', '', _data.nomeacao3, (val) => setState(() => _data.nomeacao3 = val)),

          // 3. MEMÓRIA
          _buildSectionHeader('Memória', subtitle: 'Sem pontuação imediata'),
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   _buildInstructionBox('Leia a lista. Peça repetição. Faça 2 tentativas.\n"Vou ler algumas palavras. Memorize-as pois perguntarei depois."'),
                   const SizedBox(height: 12),
                   const Text('ROSTO  -  VELUDO  -  IGREJA  -  MARGARIDA  -  VERMELHO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
                   const SizedBox(height: 12),
                   const Text('Marque as palavras recordadas (apenas para registro):', style: TextStyle(fontSize: 12, color: Colors.grey)),
                   Wrap(
                     spacing: 12,
                     runSpacing: 8,
                     children: [
                       _buildTransientCheck('Rosto', 0),
                       _buildTransientCheck('Veludo', 1),
                       _buildTransientCheck('Igreja', 2),
                       _buildTransientCheck('Margarida', 3),
                       _buildTransientCheck('Vermelho', 4),
                     ],
                   )
                ],
              ),
            ),
          ),

          // 4. ATENÇÃO
          _buildSectionHeader('Atenção', subtitle: '/6 pontos'),
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                const ListTile(title: Text("Dígitos", style: TextStyle(fontWeight: FontWeight.bold))),
                _buildCheckboxItem('Ordem Direta (2 1 8 5 4)', 'Repetiu corretamente', _data.sequenciaNumeros, (val) => setState(() => _data.sequenciaNumeros = val)),
                _buildCheckboxItem('Ordem Inversa (7 4 2)', 'Repetiu corretamente (2-4-7)', _data.aprendizado, (val) => setState(() => _data.aprendizado = val)),
                const Divider(),
                const ListTile(title: Text("Detecção de Letras", style: TextStyle(fontWeight: FontWeight.bold))),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Leia: F B A C M N A A J K L B A F A K D E A A A J A M O F A A B\nInstrução: "Bata na mesa toda vez que ouvir a letra A".', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                ),
                _buildCheckboxItem('≤ 2 erros', '', _data.deteccao, (val) => setState(() => _data.deteccao = val)),
                const Divider(),
                const ListTile(title: Text("Subtração (100 - 7)", style: TextStyle(fontWeight: FontWeight.bold))),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Instrução: "Comece de 100 e subtraia 7 sucessivamente."', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                ),
                _buildSubtractionItem('100 - 7 = 93', 0),
                _buildSubtractionItem('93 - 7 = 86', 1),
                _buildSubtractionItem('86 - 7 = 79', 2),
                _buildSubtractionItem('79 - 7 = 72', 3),
                _buildSubtractionItem('72 - 7 = 65', 4),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Pontuação Calculada: ${(_data.subtracao1 + _data.subtracao2 + _data.subtracao3)}/3',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
          ),

          // 5. LINGUAGEM
          _buildSectionHeader('Linguagem', subtitle: '/3 pontos'),
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildCheckboxItem('Repetir: "Eu somente sei que é João quem será ajudado hoje."', '', _data.repeticao1, (val) => setState(() => _data.repeticao1 = val)),
                _buildCheckboxItem('Repetir: "O gato sempre se esconde embaixo do sofá quando o cachorro está na sala."', '', _data.repeticao2, (val) => setState(() => _data.repeticao2 = val)),
                const Divider(),
                const Divider(),
                ListTile(
                  title: const Text("Fluência Verbal", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(_isFluenciaTimerRunning 
                      ? "Tempo restante: $_fluenciaSeconds s"
                      : "Duração: 1 minuto"),
                  trailing: ElevatedButton.icon(
                    onPressed: _isFluenciaTimerRunning ? _stopFluenciaTimer : _startFluenciaTimer,
                    icon: Icon(_isFluenciaTimerRunning ? Icons.stop : Icons.play_arrow, size: 16),
                    label: Text(_isFluenciaTimerRunning ? 'Parar' : 'Iniciar Timer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFluenciaTimerRunning ? Colors.red.shade100 : Colors.blue.shade100,
                      foregroundColor: _isFluenciaTimerRunning ? Colors.red : Colors.blue,
                      elevation: 0,
                    ),
                  ),
                ),
                _buildCheckboxItem('Letra F (≥ 11 palavras em 1 min)', '', _data.fluencia, (val) => setState(() => _data.fluencia = val)),
              ],
            ),
          ),

          // 6. ABSTRAÇÃO
          _buildSectionHeader('Abstração', subtitle: '/2 pontos'),
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildCheckboxItem('Trem - Bicicleta (Transporte/Veículo)', '', _data.abstracao1, (val) => setState(() => _data.abstracao1 = val)),
                _buildCheckboxItem('Relógio - Régua (Medida/Instrumento)', '', _data.abstracao2, (val) => setState(() => _data.abstracao2 = val)),
              ],
            ),
          ),

          // 7. EVOCAÇÃO TARDIA
          _buildSectionHeader('Evocação Tardia', subtitle: '/5 pontos'),
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Peça para lembrar das palavras sem pistas:", style: TextStyle(fontStyle: FontStyle.italic)),
                ),
                _buildCheckboxItem('Rosto', 'Sem pista', _data.recordacao1, (val) => setState(() => _data.recordacao1 = val)),
                _buildCheckboxItem('Veludo', 'Sem pista', _data.recordacao2, (val) => setState(() => _data.recordacao2 = val)),
                _buildCheckboxItem('Igreja', 'Sem pista', _data.recordacao3, (val) => setState(() => _data.recordacao3 = val)),
                _buildCheckboxItem('Margarida', 'Sem pista', _data.recordacao4, (val) => setState(() => _data.recordacao4 = val)),
                _buildCheckboxItem('Vermelho', 'Sem pista', _data.recordacao5, (val) => setState(() => _data.recordacao5 = val)),
              ],
            ),
          ),

          // 8. ORIENTAÇÃO
          _buildSectionHeader('Orientação', subtitle: '/6 pontos'),
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildCheckboxItem('Dia do Mês', '', _data.dataDia, (val) => setState(() => _data.dataDia = val)),
                _buildCheckboxItem('Mês', '', _data.dataMes, (val) => setState(() => _data.dataMes = val)),
                _buildCheckboxItem('Ano', '', _data.dataAno, (val) => setState(() => _data.dataAno = val)),
                _buildCheckboxItem('Dia da Semana', '', _data.diaSemana, (val) => setState(() => _data.diaSemana = val)),
                _buildCheckboxItem('Lugar', '', _data.local, (val) => setState(() => _data.local = val)),
                _buildCheckboxItem('Cidade', '', _data.cidade, (val) => setState(() => _data.cidade = val)),
              ],
            ),
          ),

          // TOTAL
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepPurple.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "PONTUAÇÃO TOTAL",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text(
                      "${_data.adjustedScore} / 30",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _data.interpretation,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await _salvarMoCA();
              },
              icon: const Icon(Icons.save),
              label: const Text('SALVAR RESULTADO'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTransientCheck(String label, int index) {
    return FilterChip(
      label: Text(label),
      selected: _memoriaImediata[index],
      onSelected: (bool value) {
        setState(() {
          _memoriaImediata[index] = value;
        });
      },
      selectedColor: Colors.deepPurple.shade100,
      checkmarkColor: Colors.deepPurple,
    );
  }

  Widget _buildSubtractionItem(String label, int index) {
    return CheckboxListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      value: _subtracoes[index],
      onChanged: (bool? value) {
        if (value != null) {
          setState(() {
            _subtracoes[index] = value;
          });
          _updateSubtractionScore();
        }
      },
      activeColor: Colors.green,
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
