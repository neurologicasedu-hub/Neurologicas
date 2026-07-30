import 'package:flutter/material.dart';
import '../models/mmse_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class MMSEScreen extends StatefulWidget {
  const MMSEScreen({super.key});

  @override
  State<MMSEScreen> createState() => _MMSEScreenState();
}

class _MMSEScreenState extends State<MMSEScreen> with AutoSaveMixin {
  final MMSEData _data = MMSEData();

  @override
  String get scaleName => 'mmse';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'educationLevel': _data.educationLevel,
      'ano': _data.ano,
      'estacao': _data.estacao,
      'mes': _data.mes,
      'dia': _data.dia,
      'diaSemana': _data.diaSemana,
      'pais': _data.pais,
      'estado': _data.estado,
      'cidade': _data.cidade,
      'hospital': _data.hospital,
      'andar': _data.andar,
      'palavra1': _data.palavra1,
      'palavra2': _data.palavra2,
      'palavra3': _data.palavra3,
      'subtracao1': _data.subtracao1,
      'subtracao2': _data.subtracao2,
      'subtracao3': _data.subtracao3,
      'subtracao4': _data.subtracao4,
      'subtracao5': _data.subtracao5,
      'recordacao1': _data.recordacao1,
      'recordacao2': _data.recordacao2,
      'recordacao3': _data.recordacao3,
      'lapis': _data.lapis,
      'relogio': _data.relogio,
      'repeticao': _data.repeticao,
      'comando1': _data.comando1,
      'comando2': _data.comando2,
      'comando3': _data.comando3,
      'leitura': _data.leitura,
      'escrita': _data.escrita,
      'desenho': _data.desenho,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.educationLevel = data['educationLevel'] ?? 0;
    _data.ano = data['ano'] ?? 0;
    _data.estacao = data['estacao'] ?? 0;
    _data.mes = data['mes'] ?? 0;
    _data.dia = data['dia'] ?? 0;
    _data.diaSemana = data['diaSemana'] ?? 0;
    _data.pais = data['pais'] ?? 0;
    _data.estado = data['estado'] ?? 0;
    _data.cidade = data['cidade'] ?? 0;
    _data.hospital = data['hospital'] ?? 0;
    _data.andar = data['andar'] ?? 0;
    _data.palavra1 = data['palavra1'] ?? 0;
    _data.palavra2 = data['palavra2'] ?? 0;
    _data.palavra3 = data['palavra3'] ?? 0;
    _data.subtracao1 = data['subtracao1'] ?? 0;
    _data.subtracao2 = data['subtracao2'] ?? 0;
    _data.subtracao3 = data['subtracao3'] ?? 0;
    _data.subtracao4 = data['subtracao4'] ?? 0;
    _data.subtracao5 = data['subtracao5'] ?? 0;
    _data.recordacao1 = data['recordacao1'] ?? 0;
    _data.recordacao2 = data['recordacao2'] ?? 0;
    _data.recordacao3 = data['recordacao3'] ?? 0;
    _data.lapis = data['lapis'] ?? 0;
    _data.relogio = data['relogio'] ?? 0;
    _data.repeticao = data['repeticao'] ?? 0;
    _data.comando1 = data['comando1'] ?? 0;
    _data.comando2 = data['comando2'] ?? 0;
    _data.comando3 = data['comando3'] ?? 0;
    _data.leitura = data['leitura'] ?? 0;
    _data.escrita = data['escrita'] ?? 0;
    _data.desenho = data['desenho'] ?? 0;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarMMSE() async {
    try {
      final score = CompletedScore(
        scoreName: 'Mini-Mental State Examination (MMSE)',
        scoreData: {
          'ano': _data.ano,
          'estacao': _data.estacao,
          'mes': _data.mes,
          'dia': _data.dia,
          'diaSemana': _data.diaSemana,
          'pais': _data.pais,
          'estado': _data.estado,
          'cidade': _data.cidade,
          'hospital': _data.hospital,
          'andar': _data.andar,
        },
        resultado: '${_data.totalScore}/30 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Sucesso!'),
              ],
            ),
            content: const Text(
              'A avaliação MMSE foi salva com sucesso no histórico do paciente.',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o dialog
                },
                child: const Text('Continuar Avaliando'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o dialog
                  Navigator.pushReplacementNamed(context, '/report');
                },
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF00509D)),
                child: const Text('Ver Relatório'),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
      title: 'Mini-Mental (MMSE)',
      body: [

          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.school, color: Colors.blue.shade800),
                    const SizedBox(width: 8),
                    Text(
                      'Escolaridade (Brucki et al. 2003)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: _data.educationLevel,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Analfabeto')),
                    DropdownMenuItem(value: 1, child: Text('1 a 4 anos')),
                    DropdownMenuItem(value: 2, child: Text('5 a 8 anos')),
                    DropdownMenuItem(value: 3, child: Text('9 a 11 anos')),
                    DropdownMenuItem(value: 4, child: Text('Mais de 11 anos')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                         _data.educationLevel = value;
                         onDataChanged();
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          _buildSectionHeader('1. Orientação Temporal (5 pontos)'),
          _buildGroupCard(
            title: "Pergunte ao paciente:",
            subtitle: "Marque as respostas corretas.",
            children: [
               _buildSwitchTile('Dia da semana', _data.diaSemana == 1, (v) => setState(() { _data.diaSemana = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Dia do mês', _data.dia == 1, (v) => setState(() { _data.dia = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Mês', _data.mes == 1, (v) => setState(() { _data.mes = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Ano', _data.ano == 1, (v) => setState(() { _data.ano = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Hora aproximada', _data.estacao == 1, (v) => setState(() { _data.estacao = v ? 1 : 0; onDataChanged(); })),
            ]
          ),

          _buildSectionHeader('2. Orientação Espacial (5 pontos)'),
          _buildGroupCard(
            title: "Onde estamos?",
            subtitle: "Aceite nomes comuns do local.",
            children: [
               _buildSwitchTile('Local', _data.hospital == 1, (v) => setState(() { _data.hospital = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Instituição (casa, rua)', _data.andar == 1, (v) => setState(() { _data.andar = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Bairro', _data.cidade == 1, (v) => setState(() { _data.cidade = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Cidade', _data.estado == 1, (v) => setState(() { _data.estado = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Estado', _data.pais == 1, (v) => setState(() { _data.pais = v ? 1 : 0; onDataChanged(); })),
            ]
          ),

          _buildSectionHeader('3. Registro (3 pontos)'),
          _buildGroupCard(
             title: 'Repetição de Palavras',
             subtitle: 'Diga: "VASO, CARRO, TIJOLO". Peça para repetir.',
             children: [
               _buildSwitchTile('Vaso', _data.palavra1 == 1, (v) => setState(() { _data.palavra1 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Carro', _data.palavra2 == 1, (v) => setState(() { _data.palavra2 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Tijolo', _data.palavra3 == 1, (v) => setState(() { _data.palavra3 = v ? 1 : 0; onDataChanged(); })),
             ]
          ),

          _buildSectionHeader('4. Atenção e Cálculo (5 pontos)'),
          _buildGroupCard(
             title: 'Subtração Serial (100 - 7)',
             subtitle: '100 - 7 = 93 ... continue subtraindo 7.',
             children: [
               _buildSwitchTile('93', _data.subtracao1 == 1, (v) => setState(() { _data.subtracao1 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('86', _data.subtracao2 == 1, (v) => setState(() { _data.subtracao2 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('79', _data.subtracao3 == 1, (v) => setState(() { _data.subtracao3 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('72', _data.subtracao4 == 1, (v) => setState(() { _data.subtracao4 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('65', _data.subtracao5 == 1, (v) => setState(() { _data.subtracao5 = v ? 1 : 0; onDataChanged(); })),
             ]
          ),

          _buildSectionHeader('5. Recordação (3 pontos)'),
          _buildGroupCard(
             title: 'Evocação das Palavras',
             subtitle: '"Quais eram as 3 palavras aprendidas?"',
             children: [
               _buildSwitchTile('Vaso', _data.recordacao1 == 1, (v) => setState(() { _data.recordacao1 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Carro', _data.recordacao2 == 1, (v) => setState(() { _data.recordacao2 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Tijolo', _data.recordacao3 == 1, (v) => setState(() { _data.recordacao3 = v ? 1 : 0; onDataChanged(); })),
             ]
          ),

          _buildSectionHeader('6. Linguagem (Nomeação)'),
          QuestionCard<int>(
             title: "Nomeação de Objetos",
             subtitle: "Mostre os objetos e pergunte o nome.",
             value: -1,
             content: Column(
               children: [
                 _buildSwitchTile('Lápis', _data.lapis == 1, (v) => setState(() { _data.lapis = v ? 1 : 0; onDataChanged(); })),
                 _buildSwitchTile('Relógio', _data.relogio == 1, (v) => setState(() { _data.relogio = v ? 1 : 0; onDataChanged(); })),
               ],
             ),
             options: const [], onChanged: (_) {}
          ),

          _buildSectionHeader('7. Linguagem (Outros)'),
          _buildGroupCard(
             title: 'Comandos Verbais e Escritos',
             children: [
               _buildSwitchTile('Repetição ("Nem aqui, nem ali, nem lá")', _data.repeticao == 1, (v) => setState(() { _data.repeticao = v ? 1 : 0; onDataChanged(); })),
               
               const SizedBox(height: 12),
               InkWell(
                 onTap: () {
                   showDialog(
                     context: context,
                     builder: (context) => Dialog(
                       child: Container(
                         padding: const EdgeInsets.all(32),
                         child: const Text(
                           "FECHE OS OLHOS",
                           style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                           textAlign: TextAlign.center,
                         ),
                       ),
                     ),
                   );
                 },
                 child: Container(
                   padding: const EdgeInsets.all(12),
                   decoration: BoxDecoration(
                     color: Colors.blue.shade50,
                     borderRadius: BorderRadius.circular(8),
                     border: Border.all(color: Colors.blue),
                   ),
                   child: const Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(Icons.visibility_off, color: Colors.blue),
                       SizedBox(width: 8),
                       Text("Mostrar comando: FECHE OS OLHOS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                     ],
                   ),
                 ),
               ),
               _buildSwitchTile('Paciente obedeceu ("Feche os olhos")', _data.leitura == 1, (v) => setState(() { _data.leitura = v ? 1 : 0; onDataChanged(); })),
               const Divider(),

               _buildSwitchTile('Comando: Pegar papel c/ mão direita', _data.comando1 == 1, (v) => setState(() { _data.comando1 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Comando: Dobrar ao meio', _data.comando2 == 1, (v) => setState(() { _data.comando2 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Comando: Colocar no chão (ou mesa)', _data.comando3 == 1, (v) => setState(() { _data.comando3 = v ? 1 : 0; onDataChanged(); })),
               _buildSwitchTile('Escrita (Frase completa)', _data.escrita == 1, (v) => setState(() { _data.escrita = v ? 1 : 0; onDataChanged(); })),
               
               const SizedBox(height: 12),
               GestureDetector(
                 onTap: () {
                    showDialog(
                     context: context,
                     builder: (context) => Dialog(
                       child: InteractiveViewer(
                         minScale: 1.0,
                         maxScale: 4.0,
                         child: Image.asset('assets/images/pentagonos.png'),
                       ),
                     ),
                   );
                 },
                 child: Center(
                   child: Container(
                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.grey.shade300),
                       borderRadius: BorderRadius.circular(8)
                     ),
                     child: Image.asset('assets/images/pentagonos.png', height: 100)
                   )
                 ),
               ),
               const SizedBox(height: 4),
               const Center(child: Text("(Toque na imagem para ampliar)", style: TextStyle(fontSize: 12, color: Colors.grey))),
               const SizedBox(height: 8),

               _buildSwitchTile('Desenho (Copiar pentágonos)', _data.desenho == 1, (v) => setState(() { _data.desenho = v ? 1 : 0; onDataChanged(); })),
             ]
          ),

           // Result Container
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(_data.totalScore),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(_data.totalScore).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('PONTUAÇÃO TOTAL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '${_data.totalScore}',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const Text(
                  '/ 30',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
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
        onPressed: _salvarMMSE,
        backgroundColor: _getScoreColor(_data.totalScore),
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

  Widget _buildGroupCard({required String title, String? subtitle, required List<Widget> children}) {
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (subtitle != null) ...[
                 const SizedBox(height: 4),
                 Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
              const SizedBox(height: 12),
              ...children,
           ],
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

  Color _getScoreColor(int score) {
    if (score >= 24) return Colors.green;
    if (score >= 18) return Colors.orange;
    return Colors.red;
  }
}
