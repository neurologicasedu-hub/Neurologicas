import 'package:flutter/material.dart';
import '../models/ichd_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../widgets/calculator_scaffold.dart';

class ICHDScreen extends StatefulWidget {
  const ICHDScreen({super.key});

  @override
  State<ICHDScreen> createState() => _ICHDScreenState();
}

class _ICHDScreenState extends State<ICHDScreen> {
  final ICHD3Data _data = ICHD3Data();

  final List<Map<String, String>> _tiposCefaleia = [
    {'code': '1.1', 'name': '1.1 Migrânea sem aura'},
    {'code': '1.2', 'name': '1.2 Migrânea com aura'},
    {'code': '2.1', 'name': '2.1 Cefaleia tensão episódica'},
    {'code': '2.3', 'name': '2.3 Cefaleia tensão crônica'},
    {'code': '3.1', 'name': '3.1 Cefaleia em salvas'},
    {'code': '3.2', 'name': '3.2 Hemicrania paroxística'},
  ];

  final TextEditingController _duracaoAtaqueController = TextEditingController();
  final TextEditingController _duracaoAuraController = TextEditingController();
  final TextEditingController _duracaoEpisodioTensaoController = TextEditingController();
  final TextEditingController _duracaoAtaqueSalvasController = TextEditingController();
  final TextEditingController _duracaoAtaqueHemicraniaController = TextEditingController();

  Future<void> _salvarICHD() async {
    try {
      final score = CompletedScore(
        scoreName: 'ICHD-3 - ${_data.classificacao}',
        scoreData: {'tipoCefaleia': _data.tipoCefaleia ?? ''},
        resultado: '${_data.classificacao} - ${_data.interpretation}',
        totalScore: 0,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ICHD-3 salva com sucesso!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ver Relatório',
              textColor: Colors.white,
              onPressed: () => Navigator.pushReplacementNamed(context, '/report'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Widget _buildCheckItem(String title, bool value, ValueChanged<bool?> onChanged, {String? subtitle}) {
     return CheckboxListTile(
       title: Text(title, style: const TextStyle(fontSize: 14)),
       subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
       value: value,
       onChanged: onChanged,
       activeColor: Colors.blue.shade900,
       contentPadding: EdgeInsets.zero,
       dense: true,
     );
  }

  Widget _buildSection(String title, List<Widget> children, {bool isMet = false}) {
     return Card(
       elevation: 2,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: isMet ? BorderSide(color: Colors.green.shade300, width: 2) : BorderSide.none),
       margin: const EdgeInsets.only(bottom: 12),
       child: Padding(
         padding: const EdgeInsets.all(16),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               children: [
                 Icon(isMet ? Icons.check_circle : Icons.circle_outlined, color: isMet ? Colors.green : Colors.grey, size: 20),
                 const SizedBox(width: 8),
                 Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isMet ? Colors.green.shade800 : Colors.black87))),
               ],
             ),
             const Divider(),
             ...children,
           ],
         ),
       ),
     );
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'ICHD-3 Cefaleias',
      body: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('Selecione o tipo de cefaleia para ver os critérios', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ),
          
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Tipo de Cefaleia', filled: true, fillColor: Colors.white),
            items: _tiposCefaleia.map((t) => DropdownMenuItem(value: t['code'], child: Text(t['name']!))).toList(),
            onChanged: (v) => setState(() => _data.tipoCefaleia = v),
          ),
          const SizedBox(height: 16),

          if (_data.tipoCefaleia == '1.1') ...[
             _buildSection('A. Número de Ataques (>=5)', [
                TextField(keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Qtde Ataques'), onChanged: (v) => setState(() => _data.numeroAtaquesMigranea = int.tryParse(v) ?? 0)),
             ], isMet: _data.numeroAtaquesMigranea >= 5),
             _buildSection('B. Duração (4-72h)', [
               TextField(controller: _duracaoAtaqueController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Horas'), onChanged: (v) => setState(() => _data.duracaoAtaque = int.tryParse(v) ?? 0)),
             ], isMet: _data.duracaoAtaque >= 4 && _data.duracaoAtaque <= 72),
             _buildSection('C. Características (>=2)', [
                _buildCheckItem('Unilateral', _data.unilateral, (v) => setState(() => _data.unilateral = v!)),
                _buildCheckItem('Pulsátil', _data.pulsatil, (v) => setState(() => _data.pulsatil = v!)),
                _buildCheckItem('Moderada/Severa', _data.intensidadeModeradaSevera, (v) => setState(() => _data.intensidadeModeradaSevera = v!)),
                _buildCheckItem('Agrava com atividade', _data.agravaAtividade, (v) => setState(() => _data.agravaAtividade = v!)),
             ], isMet: [_data.unilateral, _data.pulsatil, _data.intensidadeModeradaSevera, _data.agravaAtividade].where((e)=>e).length >= 2),
             _buildSection('D. Sintomas (>=1)', [
                _buildCheckItem('Náusea/Vômito', _data.nauseaVomito, (v) => setState(() => _data.nauseaVomito = v!)),
                _buildCheckItem('Foto/Fonofobia', _data.fotofobiaFonofobia, (v) => setState(() => _data.fotofobiaFonofobia = v!)),
             ], isMet: _data.nauseaVomito || _data.fotofobiaFonofobia),
          ],
          
          if (_data.tipoCefaleia == '1.2') ...[
               _buildSection('A. Número de Ataques (>=2)', [
                  TextField(keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Qtde Ataques'), onChanged: (v) => setState(() => _data.numeroAtaquesMigraneaAura = int.tryParse(v) ?? 0)),
               ], isMet: _data.numeroAtaquesMigraneaAura >= 2),
               _buildSection('B/C. Aura', [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Tipo de Aura'),
                    items: ['Visual', 'Sensorial', 'Fala', 'Motora', 'Tronco'].map((e)=>DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => _data.tipoAura = v),
                  ),
                  TextField(controller: _duracaoAuraController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Duração (min)'), onChanged: (v) => setState(() => _data.duracaoAura = int.tryParse(v) ?? 0)),
                  _buildCheckItem('Expansão gradual', _data.auraExpandida, (v) => setState(() => _data.auraExpandida = v!)),
                  _buildCheckItem('Unilateral', _data.auraUnilateral, (v) => setState(() => _data.auraUnilateral = v!)),
                  _buildCheckItem('Sintomas Positivos', _data.auraPositiva, (v) => setState(() => _data.auraPositiva = v!)),
               ], isMet: _data.tipoAura != null && _data.duracaoAura >= 5 && _data.duracaoAura <= 60),
          ],

          if (_data.tipoCefaleia != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _data.interpretation.contains('Preenche') ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text('Classificação', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarICHD,
        backgroundColor: Colors.blueGrey,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
