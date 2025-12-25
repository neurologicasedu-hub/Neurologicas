import 'package:flutter/material.dart';
import '../models/glasgow_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escala de Coma de Glasgow'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExpansionTile(
            title: const Text(
              "Descrição da Escala",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  "A escala é composta por três parâmetros independentes: abertura ocular, resposta verbal e resposta motora. Cada um desses itens possui uma pontuação específica, e o valor final do Glasgow corresponde à soma das pontuações obtidas em cada categoria.\n\n"
                  "A abertura ocular avalia a capacidade do paciente de abrir os olhos. Ela pode ocorrer de forma espontânea, ao estímulo verbal, ao estímulo doloroso ou pode estar ausente, recebendo pontuações que variam de 4 a 1, respectivamente.\n\n"
                  "A resposta verbal analisa a capacidade de comunicação e orientação do paciente. O indivíduo pode estar orientado, confuso, emitir palavras inapropriadas, produzir apenas sons incompreensíveis ou não apresentar resposta verbal, com pontuação variando de 5 a 1.\n\n"
                  "A resposta motora avalia a reação do paciente a comandos ou estímulos dolorosos. Ela pode ir desde obedecer comandos até ausência total de resposta motora, com pontuação de 6 a 1.\n\n"
                  "Somando-se os três componentes, a pontuação total da Escala de Glasgow varia de 3 a 15 pontos, sendo 15 o nível máximo de consciência possível e 3 o nível mínimo, correspondente à ausência completa de respostas ocular, verbal e motora. Quando o paciente recebe a menor pontuação em todos os três itens (primeira opção de cada categoria), ele totaliza 3 pontos.\n\n"
                  "Além da pontuação clássica, pode-se associar a avaliação pupilar, que considera a reatividade das pupilas à luz. Cada pupila não reativa recebe 1 ponto de penalidade, podendo totalizar até 2 pontos. Essa pontuação pupilar não é somada, mas subtraída do valor total do Glasgow, resultando no chamado Glasgow com pupilas (GCS-P). Por exemplo, um paciente com Glasgow 10 e ambas as pupilas não reativas terá pontuação final de 8.",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSection(
            title: "Abertura Ocular",
            color: Colors.blue.shade400,
            icon: Icons.remove_red_eye,
            options: const [
              {"label": "Espontânea", "value": 4},
              {"label": "Ao estímulo verbal", "value": 3},
              {"label": "Ao estímulo doloroso", "value": 2},
              {"label": "Ausente", "value": 1},
            ],
            selectedValue: _glasgowData.ocular,
            onChanged: (v) {
              setState(() => _glasgowData.ocular = v);
              onDataChanged();
            },
          ),
          const SizedBox(height: 12),
          _buildSection(
            title: "Resposta Verbal",
            color: Colors.red.shade300,
            icon: Icons.mic,
            options: const [
              {"label": "Orientado", "value": 5},
              {"label": "Confuso", "value": 4},
              {"label": "Palavras inapropriadas", "value": 3},
              {"label": "Sons incompreensíveis", "value": 2},
              {"label": "Ausente (sem resposta verbal)", "value": 1},
            ],
            selectedValue: _glasgowData.verbal,
            onChanged: (v) {
              setState(() => _glasgowData.verbal = v);
              onDataChanged();
            },
          ),
          const SizedBox(height: 12),
          _buildSection(
            title: "Resposta Motora",
            color: Colors.orange.shade400,
            icon: Icons.front_hand,
            options: const [
              {"label": "Obedece a comandos", "value": 6},
              {"label": "Localiza a dor", "value": 5},
              {"label": "Movimentos de retirada", "value": 4},
              {"label": "Flexão anormal (decorticação)", "value": 3},
              {"label": "Extensão anormal (descerebração)", "value": 2},
              {"label": "Ausência total de resposta motora", "value": 1},
            ],
            selectedValue: _glasgowData.motora,
            onChanged: (v) {
              setState(() => _glasgowData.motora = v);
              onDataChanged();
            },
          ),
          const SizedBox(height: 12),
          _buildSection(
            title: "Reatividade Pupilar (Penalidade GCS-P)",
            color: Colors.green.shade400,
            icon: Icons.remove_red_eye_outlined,
            options: const [
              {"label": "Ambas as pupilas reagem (0 de penalidade)", "value": 0},
              {"label": "Apenas uma pupila reage (1 de penalidade)", "value": 1},
              {"label": "Nenhuma pupila reage (2 de penalidade)", "value": 2},
            ],
            selectedValue: _glasgowData.pupilar,
            onChanged: (v) {
              setState(() => _glasgowData.pupilar = v);
              onDataChanged();
            },
          ),
          const SizedBox(height: 30),
          _buildTotalCard(),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Color color,
    required IconData icon,
    required List<Map<String, dynamic>> options,
    required int? selectedValue,
    required Function(int) onChanged,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.1),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  child: Icon(icon, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(),
            ...options.map((op) {
              return RadioListTile<int>(
                title: Text(op["label"]),
                value: op["value"],
                groupValue: selectedValue,
                activeColor: color,
                onChanged: (v) => onChanged(v!),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard() {
    return Card(
      color: _getTotalColor(_glasgowData.total),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Pontuação Total (GCS-P)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "${_glasgowData.total} / 15",
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _glasgowData.classificacao,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 6),
            Text(
              _glasgowData.interpretacaoClinica,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _salvarGlasgow();
                },
                icon: const Icon(Icons.save),
                label: const Text('Salvar Escala Glasgow'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _glasgowData.ocular = null;
                        _glasgowData.verbal = null;
                        _glasgowData.motora = null;
                        _glasgowData.pupilar = null;
                      });
                      clearTemporaryData();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Limpar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Voltar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTotalColor(int total) {
    if (total >= 13) return Colors.green.shade50;
    if (total >= 9) return Colors.orange.shade50;
    if (total > 0) return Colors.red.shade50;
    return Colors.grey.shade200;
  }
}
