import 'package:flutter/material.dart';
import '../models/ace_iii_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class ACEIIIScreen extends StatefulWidget {
  const ACEIIIScreen({super.key});

  @override
  State<ACEIIIScreen> createState() => _ACEIIIScreenState();
}

class _ACEIIIScreenState extends State<ACEIIIScreen> with AutoSaveMixin {
  final ACEIIIData _data = ACEIIIData();

  @override
  String get scaleName => 'ace_iii';

  @override
  Map<String, dynamic> getDataToSave() {
    return _serializeACEIIIData();
  }

  Map<String, dynamic> _serializeACEIIIData() {
    return {
      'orientacaoTemporal1': _data.orientacaoTemporal1,
      'orientacaoTemporal2': _data.orientacaoTemporal2,
      'orientacaoTemporal3': _data.orientacaoTemporal3,
      'orientacaoEspacial1': _data.orientacaoEspacial1,
      'orientacaoEspacial2': _data.orientacaoEspacial2,
      'orientacaoEspacial3': _data.orientacaoEspacial3,
      'repeticaoNumeros': _data.repeticaoNumeros,
      'subtracaoSerial': _data.subtracaoSerial,
      // Nome e Endereço
      'nomeEndereco1': _data.nomeEndereco1,
      'nomeEndereco2': _data.nomeEndereco2,
      'nomeEndereco3': _data.nomeEndereco3,
      'nomeEndereco4': _data.nomeEndereco4,
      'nomeEndereco5': _data.nomeEndereco5,
      'nomeEndereco6': _data.nomeEndereco6,
      'nomeEndereco7': _data.nomeEndereco7,
      'nomeEndereco8': _data.nomeEndereco8,
      'nomeEndereco9': _data.nomeEndereco9,
      'nomeEndereco10': _data.nomeEndereco10,
      // Recordação Nome e Endereço
      'recordacaoNomeEndereco1': _data.recordacaoNomeEndereco1,
      'recordacaoNomeEndereco2': _data.recordacaoNomeEndereco2,
      'recordacaoNomeEndereco3': _data.recordacaoNomeEndereco3,
      'recordacaoNomeEndereco4': _data.recordacaoNomeEndereco4,
      'recordacaoNomeEndereco5': _data.recordacaoNomeEndereco5,
      'recordacaoNomeEndereco6': _data.recordacaoNomeEndereco6,
      'recordacaoNomeEndereco7': _data.recordacaoNomeEndereco7,
      'recordacaoNomeEndereco8': _data.recordacaoNomeEndereco8,
      'recordacaoNomeEndereco9': _data.recordacaoNomeEndereco9,
      'recordacaoNomeEndereco10': _data.recordacaoNomeEndereco10,
      // Recordação de Palavras
      'recordacaoPalavras1': _data.recordacaoPalavras1,
      'recordacaoPalavras2': _data.recordacaoPalavras2,
      'recordacaoPalavras3': _data.recordacaoPalavras3,
      'recordacaoPalavras4': _data.recordacaoPalavras4,
      'recordacaoPalavras5': _data.recordacaoPalavras5,
      'recordacaoPalavras6': _data.recordacaoPalavras6,
      // Fluência
      'fluenciaAnimal1': _data.fluenciaAnimal1,
      'fluenciaAnimal2': _data.fluenciaAnimal2,
      'fluenciaAnimal3': _data.fluenciaAnimal3,
      'fluenciaAnimal4': _data.fluenciaAnimal4,
      'fluenciaAnimal5': _data.fluenciaAnimal5,
      'fluenciaAnimal6': _data.fluenciaAnimal6,
      'fluenciaAnimal7': _data.fluenciaAnimal7,
      'fluenciaAnimal8': _data.fluenciaAnimal8,
      'fluenciaAnimal9': _data.fluenciaAnimal9,
      'fluenciaAnimal10': _data.fluenciaAnimal10,
      'fluenciaAnimal11': _data.fluenciaAnimal11,
      'fluenciaAnimal12': _data.fluenciaAnimal12,
      'fluenciaAnimal13': _data.fluenciaAnimal13,
      'fluenciaAnimal14': _data.fluenciaAnimal14,
      // Linguagem
      'nomeacaoObjetos1': _data.nomeacaoObjetos1,
      'nomeacaoObjetos2': _data.nomeacaoObjetos2,
      'nomeacaoObjetos3': _data.nomeacaoObjetos3,
      'nomeacaoObjetos4': _data.nomeacaoObjetos4,
      'nomeacaoObjetos5': _data.nomeacaoObjetos5,
      'nomeacaoObjetos6': _data.nomeacaoObjetos6,
      'nomeacaoObjetos7': _data.nomeacaoObjetos7,
      'nomeacaoObjetos8': _data.nomeacaoObjetos8,
      'nomeacaoObjetos9': _data.nomeacaoObjetos9,
      'nomeacaoObjetos10': _data.nomeacaoObjetos10,
      'nomeacaoObjetos11': _data.nomeacaoObjetos11,
      'nomeacaoObjetos12': _data.nomeacaoObjetos12,
      'repeticaoFrases1': _data.repeticaoFrases1,
      'repeticaoFrases2': _data.repeticaoFrases2,
      'repeticaoFrases3': _data.repeticaoFrases3,
      'compreensaoComandos1': _data.compreensaoComandos1,
      'compreensaoComandos2': _data.compreensaoComandos2,
      'compreensaoComandos3': _data.compreensaoComandos3,
      'compreensaoComandos4': _data.compreensaoComandos4,
      'leitura1': _data.leitura1,
      'leitura2': _data.leitura2,
      'leitura3': _data.leitura3,
      'leitura4': _data.leitura4,
      'leitura5': _data.leitura5,
      'leitura6': _data.leitura6,
      'leitura7': _data.leitura7,
      // Visuoespacial
      'copiaFigura1': _data.copiaFigura1,
      'copiaFigura2': _data.copiaFigura2,
      'copiaFigura3': _data.copiaFigura3,
      'copiaFigura4': _data.copiaFigura4,
      'copiaFigura5': _data.copiaFigura5,
      'copiaFigura6': _data.copiaFigura6,
      'copiaFigura7': _data.copiaFigura7,
      'copiaFigura8': _data.copiaFigura8,
      'desenhoRelogio1': _data.desenhoRelogio1,
      'desenhoRelogio2': _data.desenhoRelogio2,
      'desenhoRelogio3': _data.desenhoRelogio3,
      'desenhoRelogio4': _data.desenhoRelogio4,
      'desenhoRelogio5': _data.desenhoRelogio5,
      'desenhoRelogio6': _data.desenhoRelogio6,
      'desenhoRelogio7': _data.desenhoRelogio7,
      'desenhoRelogio8': _data.desenhoRelogio8,
    };
  }

  void _deserializeACEIIIData(Map<String, dynamic> data) {
    _data.orientacaoTemporal1 = data['orientacaoTemporal1'] ?? 0;
    _data.orientacaoTemporal2 = data['orientacaoTemporal2'] ?? 0;
    _data.orientacaoTemporal3 = data['orientacaoTemporal3'] ?? 0;
    _data.orientacaoEspacial1 = data['orientacaoEspacial1'] ?? 0;
    _data.orientacaoEspacial2 = data['orientacaoEspacial2'] ?? 0;
    _data.orientacaoEspacial3 = data['orientacaoEspacial3'] ?? 0;
    _data.repeticaoNumeros = data['repeticaoNumeros'] ?? 0;
    _data.subtracaoSerial = data['subtracaoSerial'] ?? 0;
    
    _data.nomeEndereco1 = data['nomeEndereco1'] ?? 0;
    _data.nomeEndereco2 = data['nomeEndereco2'] ?? 0;
    _data.nomeEndereco3 = data['nomeEndereco3'] ?? 0;
    _data.nomeEndereco4 = data['nomeEndereco4'] ?? 0;
    _data.nomeEndereco5 = data['nomeEndereco5'] ?? 0;
    _data.nomeEndereco6 = data['nomeEndereco6'] ?? 0;
    _data.nomeEndereco7 = data['nomeEndereco7'] ?? 0;
    _data.nomeEndereco8 = data['nomeEndereco8'] ?? 0;
    _data.nomeEndereco9 = data['nomeEndereco9'] ?? 0;
    _data.nomeEndereco10 = data['nomeEndereco10'] ?? 0;

    _data.recordacaoNomeEndereco1 = data['recordacaoNomeEndereco1'] ?? 0;
    _data.recordacaoNomeEndereco2 = data['recordacaoNomeEndereco2'] ?? 0;
    _data.recordacaoNomeEndereco3 = data['recordacaoNomeEndereco3'] ?? 0;
    _data.recordacaoNomeEndereco4 = data['recordacaoNomeEndereco4'] ?? 0;
    _data.recordacaoNomeEndereco5 = data['recordacaoNomeEndereco5'] ?? 0;
    _data.recordacaoNomeEndereco6 = data['recordacaoNomeEndereco6'] ?? 0;
    _data.recordacaoNomeEndereco7 = data['recordacaoNomeEndereco7'] ?? 0;
    _data.recordacaoNomeEndereco8 = data['recordacaoNomeEndereco8'] ?? 0;
    _data.recordacaoNomeEndereco9 = data['recordacaoNomeEndereco9'] ?? 0;
    _data.recordacaoNomeEndereco10 = data['recordacaoNomeEndereco10'] ?? 0;

    _data.recordacaoPalavras1 = data['recordacaoPalavras1'] ?? 0;
    _data.recordacaoPalavras2 = data['recordacaoPalavras2'] ?? 0;
    _data.recordacaoPalavras3 = data['recordacaoPalavras3'] ?? 0;
    _data.recordacaoPalavras4 = data['recordacaoPalavras4'] ?? 0;
    _data.recordacaoPalavras5 = data['recordacaoPalavras5'] ?? 0;
    _data.recordacaoPalavras6 = data['recordacaoPalavras6'] ?? 0;

    _data.fluenciaAnimal1 = data['fluenciaAnimal1'] ?? 0;
    _data.fluenciaAnimal2 = data['fluenciaAnimal2'] ?? 0;
    _data.fluenciaAnimal3 = data['fluenciaAnimal3'] ?? 0;
    _data.fluenciaAnimal4 = data['fluenciaAnimal4'] ?? 0;
    _data.fluenciaAnimal5 = data['fluenciaAnimal5'] ?? 0;
    _data.fluenciaAnimal6 = data['fluenciaAnimal6'] ?? 0;
    _data.fluenciaAnimal7 = data['fluenciaAnimal7'] ?? 0;
    _data.fluenciaAnimal8 = data['fluenciaAnimal8'] ?? 0;
    _data.fluenciaAnimal9 = data['fluenciaAnimal9'] ?? 0;
    _data.fluenciaAnimal10 = data['fluenciaAnimal10'] ?? 0;
    _data.fluenciaAnimal11 = data['fluenciaAnimal11'] ?? 0;
    _data.fluenciaAnimal12 = data['fluenciaAnimal12'] ?? 0;
    _data.fluenciaAnimal13 = data['fluenciaAnimal13'] ?? 0;
    _data.fluenciaAnimal14 = data['fluenciaAnimal14'] ?? 0;

    _data.nomeacaoObjetos1 = data['nomeacaoObjetos1'] ?? 0;
    _data.nomeacaoObjetos2 = data['nomeacaoObjetos2'] ?? 0;
    _data.nomeacaoObjetos3 = data['nomeacaoObjetos3'] ?? 0;
    _data.nomeacaoObjetos4 = data['nomeacaoObjetos4'] ?? 0;
    _data.nomeacaoObjetos5 = data['nomeacaoObjetos5'] ?? 0;
    _data.nomeacaoObjetos6 = data['nomeacaoObjetos6'] ?? 0;
    _data.nomeacaoObjetos7 = data['nomeacaoObjetos7'] ?? 0;
    _data.nomeacaoObjetos8 = data['nomeacaoObjetos8'] ?? 0;
    _data.nomeacaoObjetos9 = data['nomeacaoObjetos9'] ?? 0;
    _data.nomeacaoObjetos10 = data['nomeacaoObjetos10'] ?? 0;
    _data.nomeacaoObjetos11 = data['nomeacaoObjetos11'] ?? 0;
    _data.nomeacaoObjetos12 = data['nomeacaoObjetos12'] ?? 0;

    _data.repeticaoFrases1 = data['repeticaoFrases1'] ?? 0;
    _data.repeticaoFrases2 = data['repeticaoFrases2'] ?? 0;
    _data.repeticaoFrases3 = data['repeticaoFrases3'] ?? 0;

    _data.compreensaoComandos1 = data['compreensaoComandos1'] ?? 0;
    _data.compreensaoComandos2 = data['compreensaoComandos2'] ?? 0;
    _data.compreensaoComandos3 = data['compreensaoComandos3'] ?? 0;
    _data.compreensaoComandos4 = data['compreensaoComandos4'] ?? 0;

    _data.leitura1 = data['leitura1'] ?? 0;
    _data.leitura2 = data['leitura2'] ?? 0;
    _data.leitura3 = data['leitura3'] ?? 0;
    _data.leitura4 = data['leitura4'] ?? 0;
    _data.leitura5 = data['leitura5'] ?? 0;
    _data.leitura6 = data['leitura6'] ?? 0;
    _data.leitura7 = data['leitura7'] ?? 0;

    _data.copiaFigura1 = data['copiaFigura1'] ?? 0;
    _data.copiaFigura2 = data['copiaFigura2'] ?? 0;
    _data.copiaFigura3 = data['copiaFigura3'] ?? 0;
    _data.copiaFigura4 = data['copiaFigura4'] ?? 0;
    _data.copiaFigura5 = data['copiaFigura5'] ?? 0;
    _data.copiaFigura6 = data['copiaFigura6'] ?? 0;
    _data.copiaFigura7 = data['copiaFigura7'] ?? 0;
    _data.copiaFigura8 = data['copiaFigura8'] ?? 0;

    _data.desenhoRelogio1 = data['desenhoRelogio1'] ?? 0;
    _data.desenhoRelogio2 = data['desenhoRelogio2'] ?? 0;
    _data.desenhoRelogio3 = data['desenhoRelogio3'] ?? 0;
    _data.desenhoRelogio4 = data['desenhoRelogio4'] ?? 0;
    _data.desenhoRelogio5 = data['desenhoRelogio5'] ?? 0;
    _data.desenhoRelogio6 = data['desenhoRelogio6'] ?? 0;
    _data.desenhoRelogio7 = data['desenhoRelogio7'] ?? 0;
    _data.desenhoRelogio8 = data['desenhoRelogio8'] ?? 0;
  }


  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _deserializeACEIIIData(data);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarACEIII() async {
    try {
      final score = CompletedScore(
        scoreName: 'ACE-III (Addenbrooke\'s Cognitive Examination)',
        scoreData: {'totalScore': _data.totalScore},
        resultado: '${_data.totalScore}/100 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData(); // Limpa dados temporários ao salvar permanentemente
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ACE-III salva com sucesso!'),
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

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'ACE-III',
      body: [
          Container(
             margin: const EdgeInsets.only(bottom: 24),
             padding: const EdgeInsets.all(20),
             decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(20)),
             child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text(
                     'Avaliação Cognitiva Abrangente',
                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                   ),
                   const SizedBox(height: 8),
                   const Text(
                     'Escala de 0 a 100 pontos que avalia 5 domínios cognitivos.\nPreencha com atenção.',
                     style: TextStyle(fontSize: 14, color: Colors.teal),
                   ),
                   const SizedBox(height: 12),
                   Text(
                    'Score Total: ${_data.totalScore}/100',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal.shade700),
                   ),
                ],
             ),
          ),

          _buildGroupCard(
            title: 'Atenção/Orientação (${_data.scoreAtencao}/18)',
            subtitle: 'Orientações Temporal e Espacial + Atenção',
            children: [
               const Text('Tempo', style: TextStyle(fontWeight: FontWeight.bold)),
               _buildSwitchTile('Ano', _data.orientacaoTemporal1 == 1, (v) => setState(() => _data.orientacaoTemporal1 = v ? 1 : 0)),
               _buildSwitchTile('Mês', _data.orientacaoTemporal2 == 1, (v) => setState(() => _data.orientacaoTemporal2 = v ? 1 : 0)),
               _buildSwitchTile('Dia', _data.orientacaoTemporal3 == 1, (v) => setState(() => _data.orientacaoTemporal3 = v ? 1 : 0)),
               const SizedBox(height: 8),
               const Text('Espaço', style: TextStyle(fontWeight: FontWeight.bold)),
               _buildSwitchTile('Cidade', _data.orientacaoEspacial1 == 1, (v) => setState(() => _data.orientacaoEspacial1 = v ? 1 : 0)),
               _buildSwitchTile('Estado', _data.orientacaoEspacial2 == 1, (v) => setState(() => _data.orientacaoEspacial2 = v ? 1 : 0)),
               _buildSwitchTile('Lugar', _data.orientacaoEspacial3 == 1, (v) => setState(() => _data.orientacaoEspacial3 = v ? 1 : 0)),
               const SizedBox(height: 8),
               const Text('Repetição de Números', style: TextStyle(fontWeight: FontWeight.bold)),
               _buildSwitchTile('Repetiu Sequência', _data.repeticaoNumeros == 1, (v) => setState(() => _data.repeticaoNumeros = v ? 1 : 0)),
               _buildSwitchTile('Subtração Serial (100-7) ≥ 2 acertos', _data.subtracaoSerial == 1, (v) => setState(() => _data.subtracaoSerial = v ? 1 : 0)),
            ]
          ),

          _buildGroupCard(
            title: 'Memória (${_data.scoreMemoria}/26)',
            subtitle: 'Nome e Endereço + Recordação',
            children: [
               const Text('Aprendizado (Nome e Endereço)', style: TextStyle(fontWeight: FontWeight.bold)),
               _buildSwitchTile('João', _data.nomeEndereco1 == 1, (v) => setState(() => _data.nomeEndereco1 = v ? 1 : 0)),
               _buildSwitchTile('Silva', _data.nomeEndereco2 == 1, (v) => setState(() => _data.nomeEndereco2 = v ? 1 : 0)),
               _buildSwitchTile('Rua das Flores', _data.nomeEndereco3 == 1, (v) => setState(() => _data.nomeEndereco3 = v ? 1 : 0)),
               _buildSwitchTile('42', _data.nomeEndereco4 == 1, (v) => setState(() => _data.nomeEndereco4 = v ? 1 : 0)),
               _buildSwitchTile('Centro', _data.nomeEndereco5 == 1, (v) => setState(() => _data.nomeEndereco5 = v ? 1 : 0)),
               _buildSwitchTile('São Paulo', _data.nomeEndereco6 == 1, (v) => setState(() => _data.nomeEndereco6 = v ? 1 : 0)),
               _buildSwitchTile('Repetição 2 (Nome)', _data.nomeEndereco7 == 1, (v) => setState(() => _data.nomeEndereco7 = v ? 1 : 0)),
               _buildSwitchTile('Repetição 2 (Endereço)', _data.nomeEndereco8 == 1, (v) => setState(() => _data.nomeEndereco8 = v ? 1 : 0)),
               _buildSwitchTile('Repetição 3 (Nome)', _data.nomeEndereco9 == 1, (v) => setState(() => _data.nomeEndereco9 = v ? 1 : 0)),
               _buildSwitchTile('Repetição 3 (Endereço)', _data.nomeEndereco10 == 1, (v) => setState(() => _data.nomeEndereco10 = v ? 1 : 0)),
               
               const SizedBox(height: 8),
               const Text('Recordação Tardia', style: TextStyle(fontWeight: FontWeight.bold)),
               _buildSwitchTile('Jodão (Rec)', _data.recordacaoNomeEndereco1 == 1, (v) => setState(() => _data.recordacaoNomeEndereco1 = v ? 1 : 0)),
               _buildSwitchTile('Silva (Rec)', _data.recordacaoNomeEndereco2 == 1, (v) => setState(() => _data.recordacaoNomeEndereco2 = v ? 1 : 0)),
               _buildSwitchTile('R. das Flores (Rec)', _data.recordacaoNomeEndereco3 == 1, (v) => setState(() => _data.recordacaoNomeEndereco3 = v ? 1 : 0)),
               _buildSwitchTile('42 (Rec)', _data.recordacaoNomeEndereco4 == 1, (v) => setState(() => _data.recordacaoNomeEndereco4 = v ? 1 : 0)),
               _buildSwitchTile('Centro (Rec)', _data.recordacaoNomeEndereco5 == 1, (v) => setState(() => _data.recordacaoNomeEndereco5 = v ? 1 : 0)),
               _buildSwitchTile('S. Paulo (Rec)', _data.recordacaoNomeEndereco6 == 1, (v) => setState(() => _data.recordacaoNomeEndereco6 = v ? 1 : 0)),
             
               const SizedBox(height: 8),
               const Text('Recordação de Palavras', style: TextStyle(fontWeight: FontWeight.bold)),
               _buildSwitchTile('CASA', _data.recordacaoPalavras1 == 1, (v) => setState(() => _data.recordacaoPalavras1 = v ? 1 : 0)),
               _buildSwitchTile('MESA', _data.recordacaoPalavras2 == 1, (v) => setState(() => _data.recordacaoPalavras2 = v ? 1 : 0)),
               _buildSwitchTile('GATO', _data.recordacaoPalavras3 == 1, (v) => setState(() => _data.recordacaoPalavras3 = v ? 1 : 0)),
               _buildSwitchTile('CARRO', _data.recordacaoPalavras4 == 1, (v) => setState(() => _data.recordacaoPalavras4 = v ? 1 : 0)),
               _buildSwitchTile('ÁRVORE', _data.recordacaoPalavras5 == 1, (v) => setState(() => _data.recordacaoPalavras5 = v ? 1 : 0)),
               _buildSwitchTile('SOL', _data.recordacaoPalavras6 == 1, (v) => setState(() => _data.recordacaoPalavras6 = v ? 1 : 0)),
            ]
          ),
          
          _buildGroupCard(
              title: 'Fluência Verbal (${_data.scoreFluencia}/14)',
              children: List.generate(14, (index) => _buildSwitchTile('Animal ${index + 1}', 
                  _data.checkFluencia(index), 
                  (v) => setState(() => _data.setFluencia(index, v ? 1 : 0))
              )),
          ),

          _buildGroupCard(
              title: 'Linguagem (${_data.scoreLinguagem}/26)',
              children: [
                  const Text('Nomeação (12 itens)', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...List.generate(12, (index) => _buildSwitchTile('Objeto ${index + 1}', _data.checkNomeacao(index), (v) => setState(() => _data.setNomeacao(index, v ? 1 : 0)))),
                  const SizedBox(height: 8),
                  const Text('Repetição', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildSwitchTile('Frase 1', _data.repeticaoFrases1 == 1, (v) => setState(() => _data.repeticaoFrases1 = v ? 1 : 0)),
                  _buildSwitchTile('Frase 2', _data.repeticaoFrases2 == 1, (v) => setState(() => _data.repeticaoFrases2 = v ? 1 : 0)),
                  _buildSwitchTile('Frase 3', _data.repeticaoFrases3 == 1, (v) => setState(() => _data.repeticaoFrases3 = v ? 1 : 0)),
                  const SizedBox(height: 8),
                  const Text('Comandos', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildSwitchTile('C1 (Olhos)', _data.compreensaoComandos1 == 1, (v) => setState(() => _data.compreensaoComandos1 = v ? 1 : 0)),
                  _buildSwitchTile('C2 (Nariz)', _data.compreensaoComandos2 == 1, (v) => setState(() => _data.compreensaoComandos2 = v ? 1 : 0)),
                  _buildSwitchTile('C3 (Ombro)', _data.compreensaoComandos3 == 1, (v) => setState(() => _data.compreensaoComandos3 = v ? 1 : 0)),
                  _buildSwitchTile('C4 (Porta/Janela)', _data.compreensaoComandos4 == 1, (v) => setState(() => _data.compreensaoComandos4 = v ? 1 : 0)),
                  const SizedBox(height: 8),
                  const Text('Leitura', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...List.generate(7, (index) => _buildSwitchTile('Frase ${index + 1}', _data.checkLeitura(index), (v) => setState(() => _data.setLeitura(index, v ? 1 : 0)))),
              ]
          ),
          
          _buildGroupCard(
              title: 'Visuoespacial (${_data.scoreVisuoespacial}/16)',
              children: [
                   const Text('Cópia (8 figuras)', style: TextStyle(fontWeight: FontWeight.bold)),
                   ...List.generate(8, (index) => _buildSwitchTile('Figura ${index + 1}', _data.checkCopia(index), (v) => setState(() => _data.setCopia(index, v ? 1 : 0)))),
                   const SizedBox(height: 8),
                   const Text('Relógio (8 critérios)', style: TextStyle(fontWeight: FontWeight.bold)),
                   ...List.generate(8, (index) => _buildSwitchTile('Critério ${index + 1}', _data.checkRelogio(index), (v) => setState(() => _data.setRelogio(index, v ? 1 : 0)))),
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
                  '/ 100',
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
        onPressed: _salvarACEIII,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 88) return Colors.green;
    if (score >= 82) return Colors.orange.shade300;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }
}

// Extension helpers to clean up duplicate map logic
extension ACEDataHelpers on ACEIIIData {
    bool checkFluencia(int index) {
        switch(index) {
            case 0: return fluenciaAnimal1 == 1;
            case 1: return fluenciaAnimal2 == 1;
            case 2: return fluenciaAnimal3 == 1;
            case 3: return fluenciaAnimal4 == 1;
            case 4: return fluenciaAnimal5 == 1;
            case 5: return fluenciaAnimal6 == 1;
            case 6: return fluenciaAnimal7 == 1;
            case 7: return fluenciaAnimal8 == 1;
            case 8: return fluenciaAnimal9 == 1;
            case 9: return fluenciaAnimal10 == 1;
            case 10: return fluenciaAnimal11 == 1;
            case 11: return fluenciaAnimal12 == 1;
            case 12: return fluenciaAnimal13 == 1;
            case 13: return fluenciaAnimal14 == 1;
            default: return false;
        }
    }
    void setFluencia(int index, int val) {
        switch(index) {
            case 0: fluenciaAnimal1 = val; break;
            case 1: fluenciaAnimal2 = val; break;
            case 2: fluenciaAnimal3 = val; break;
            case 3: fluenciaAnimal4 = val; break;
            case 4: fluenciaAnimal5 = val; break;
            case 5: fluenciaAnimal6 = val; break;
            case 6: fluenciaAnimal7 = val; break;
            case 7: fluenciaAnimal8 = val; break;
            case 8: fluenciaAnimal9 = val; break;
            case 9: fluenciaAnimal10 = val; break;
            case 10: fluenciaAnimal11 = val; break;
            case 11: fluenciaAnimal12 = val; break;
            case 12: fluenciaAnimal13 = val; break;
            case 13: fluenciaAnimal14 = val; break;
        }
    }
    
    // ... helpers for others can be similar or inline map. kept simpler for now to avoid massive file growth if not strictly needed.
    // Actually implementing them inline is cleaner than giant case statement manually in View.
    
    bool checkNomeacao(int index) {
        List<int> vals = [nomeacaoObjetos1, nomeacaoObjetos2, nomeacaoObjetos3, nomeacaoObjetos4, nomeacaoObjetos5, nomeacaoObjetos6, nomeacaoObjetos7, nomeacaoObjetos8, nomeacaoObjetos9, nomeacaoObjetos10, nomeacaoObjetos11, nomeacaoObjetos12];
        return vals[index] == 1;
    }
    void setNomeacao(int index, int val) {
        if(index==0) nomeacaoObjetos1=val; else if(index==1) nomeacaoObjetos2=val; else if(index==2) nomeacaoObjetos3=val;
        else if(index==3) nomeacaoObjetos4=val; else if(index==4) nomeacaoObjetos5=val; else if(index==5) nomeacaoObjetos6=val;
        else if(index==6) nomeacaoObjetos7=val; else if(index==7) nomeacaoObjetos8=val; else if(index==8) nomeacaoObjetos9=val;
        else if(index==9) nomeacaoObjetos10=val; else if(index==10) nomeacaoObjetos11=val; else if(index==11) nomeacaoObjetos12=val;
    }

    bool checkLeitura(int index) {
        List<int> vals = [leitura1, leitura2, leitura3, leitura4, leitura5, leitura6, leitura7];
        return vals[index] == 1;
    }
    void setLeitura(int index, int val) {
         if(index==0) leitura1=val; else if(index==1) leitura2=val; else if(index==2) leitura3=val; else if(index==3) leitura4=val;
         else if(index==4) leitura5=val; else if(index==5) leitura6=val; else if(index==6) leitura7=val;
    }

    bool checkCopia(int index) {
         List<int> vals = [copiaFigura1, copiaFigura2, copiaFigura3, copiaFigura4, copiaFigura5, copiaFigura6, copiaFigura7, copiaFigura8];
         return vals[index] == 1;
    }
    void setCopia(int index, int val) {
         if(index==0) copiaFigura1=val; else if(index==1) copiaFigura2=val; else if(index==2) copiaFigura3=val; else if(index==3) copiaFigura4=val;
         else if(index==4) copiaFigura5=val; else if(index==5) copiaFigura6=val; else if(index==6) copiaFigura7=val; else if(index==7) copiaFigura8=val;
    }

    bool checkRelogio(int index) {
         List<int> vals = [desenhoRelogio1, desenhoRelogio2, desenhoRelogio3, desenhoRelogio4, desenhoRelogio5, desenhoRelogio6, desenhoRelogio7, desenhoRelogio8];
         return vals[index] == 1;
    }
    void setRelogio(int index, int val) {
         if(index==0) desenhoRelogio1=val; else if(index==1) desenhoRelogio2=val; else if(index==2) desenhoRelogio3=val; else if(index==3) desenhoRelogio4=val;
         else if(index==4) desenhoRelogio5=val; else if(index==5) desenhoRelogio6=val; else if(index==6) desenhoRelogio7=val; else if(index==7) desenhoRelogio8=val;
    }
}
