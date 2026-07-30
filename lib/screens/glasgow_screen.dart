import 'package:flutter/material.dart';
import '../models/glasgow_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class GlasgowsScreen extends StatefulWidget {
  const GlasgowsScreen({super.key});

  @override
  State<GlasgowsScreen> createState() => _GlasgowsScreenState();
}

class _GlasgowsScreenState extends State<GlasgowsScreen> with AutoSaveMixin {
  final GlasgowData _glasgowData = GlasgowData();

  @override
  String get scaleName => 'glasgow';

  @override
  Map<String, dynamic> getDataToSave() {
    return _glasgowData.toJson();
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _glasgowData.ocular = data['ocular'];
    _glasgowData.verbal = data['verbal'];
    _glasgowData.motora = data['motora'];
    _glasgowData.pupilar = data['pupilar'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarGlasgow() async {
    try {
      final score = CompletedScore(
        scoreName: 'Glasgow Coma Scale (GCS-P)',
        scoreData: _glasgowData.toJson(),
        resultado: '${_glasgowData.classificacao} - ${_glasgowData.interpretacaoClinica} (GCS-P: ${_glasgowData.total})',
        totalScore: _glasgowData.total,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Glasgow salva com sucesso!'),
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
      title: 'Escala de Coma de Glasgow',
      body: [
        _buildInfoCard(),
        _buildQuestion(
          title: "Abertura Ocular",
          icon: Icons.remove_red_eye,
          iconColor: Colors.blue.shade400,
          value: _glasgowData.ocular,
          onChanged: (v) => setState(() => _glasgowData.ocular = v),
          options: [
            {"label": "Espontânea", "value": 4},
            {"label": "Ao estímulo verbal", "value": 3},
            {"label": "Ao estímulo doloroso", "value": 2},
            {"label": "Ausente", "value": 1},
          ],
        ),
        _buildQuestion(
          title: "Resposta Verbal",
          icon: Icons.mic,
          iconColor: Colors.red.shade300,
          value: _glasgowData.verbal,
          onChanged: (v) => setState(() => _glasgowData.verbal = v),
          options: [
            {"label": "Orientado", "value": 5},
            {"label": "Confuso", "value": 4},
            {"label": "Palavras inapropriadas", "value": 3},
            {"label": "Sons incompreensíveis", "value": 2},
            {"label": "Ausente", "value": 1},
          ],
        ),
        _buildQuestion(
          title: "Resposta Motora",
          icon: Icons.front_hand,
          iconColor: Colors.orange.shade400,
          value: _glasgowData.motora,
          onChanged: (v) => setState(() => _glasgowData.motora = v),
          options: [
            {"label": "Obedece a comandos", "value": 6},
            {"label": "Localiza a dor", "value": 5},
            {"label": "Movimentos de retirada", "value": 4},
            {"label": "Flexão anormal (decorticação)", "value": 3},
            {"label": "Extensão anormal (descerebração)", "value": 2},
            {"label": "Ausência total", "value": 1},
          ],
        ),
        _buildQuestion(
          title: "Reatividade Pupilar (GCS-P)",
          subtitle: "Penalidade a ser subtraída do total",
          icon: Icons.remove_red_eye_outlined,
          iconColor: Colors.green.shade400,
          value: _glasgowData.pupilar,
          onChanged: (v) => setState(() => _glasgowData.pupilar = v),
          options: [
            {"label": "Ambas reagem (0)", "value": 0},
            {"label": "Apenas uma reage (-1)", "value": 1},
            {"label": "Nenhuma reage (-2)", "value": 2},
          ],
        ),
        _buildTotalCard(),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarGlasgow,
        backgroundColor: _getTotalColor(_glasgowData.total),
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildInfoCard() {
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
            decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          ),
          title: const Text('Descrição da Escala', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          children: const [
             Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  "A escala avalia três parâmetros: abertura ocular, resposta verbal e resposta motora. O Glasgow com Pupilas (GCS-P) subtrai a reatividade pupilar do total.\n\n"
                  "Pontuação máxima: 15 (Consciente)\nPontuação mínima: 1 (Coma profundo + pupilas não reativas)",
                  style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion({
    required String title,
    String? subtitle,
    required IconData icon,
    required Color iconColor,
    required int? value,
    required List<Map<String, dynamic>> options,
    required ValueChanged<int> onChanged,
  }) {
    List<QuestionOption<int>> optionObjects = options.map((op) {
      return QuestionOption<int>(label: op['label'], value: op['value']);
    }).toList();

    return QuestionCard<int?>(
      title: title,
      subtitle: subtitle,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.2), shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      value: value,
      options: optionObjects,
      onChanged: (val) {
        if (val != null) {
          onChanged(val);
          onDataChanged();
        }
      },
    );
  }

  Widget _buildTotalCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, top: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _getTotalColor(_glasgowData.total).withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getTotalColor(_glasgowData.total).withOpacity(0.3), 
            blurRadius: 15, 
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Pontuação Total (GCS-P)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            "${_glasgowData.total}",
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
          const Text(
            "/ 15",
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _glasgowData.classificacao,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _glasgowData.interpretacaoClinica,
            style: const TextStyle(fontSize: 14, color: Colors.white, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                     setState(() {
                        _glasgowData.ocular = null;
                        _glasgowData.verbal = null;
                        _glasgowData.motora = null;
                        _glasgowData.pupilar = null;
                      });
                      clearTemporaryData();
                }, 
                icon: const Icon(Icons.refresh, color: Colors.white70), 
                label: const Text('Limpar', style: TextStyle(color: Colors.white))
              ),
            ],
          )
        ],
      ),
    );
  }

  Color _getTotalColor(int total) {
    if (total >= 13) return Colors.green;
    if (total >= 9) return Colors.orange;
    if (total >= 3) return Colors.red;
    return Colors.grey; 
  }
}
