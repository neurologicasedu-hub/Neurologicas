import 'package:flutter/material.dart';
import '../models/barthel_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class BarthelScreen extends StatefulWidget {
  const BarthelScreen({super.key});

  @override
  State<BarthelScreen> createState() => _BarthelScreenState();
}

class _BarthelScreenState extends State<BarthelScreen> with AutoSaveMixin {
  final BarthelData _data = BarthelData();

  @override
  String get scaleName => 'barthel';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'alimentacao': _data.alimentacao,
      'banho': _data.banho,
      'higienePessoal': _data.higienePessoal,
      'vestir': _data.vestir,
      'controleUrinario': _data.controleUrinario,
      'controleIntestinal': _data.controleIntestinal,
      'usarBanheiro': _data.usarBanheiro,
      'transferirCamaCadeira': _data.transferirCamaCadeira,
      'caminhar': _data.caminhar,
      'subirEscadas': _data.subirEscadas,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.alimentacao = data['alimentacao'] ?? 0;
    _data.banho = data['banho'] ?? 0;
    _data.higienePessoal = data['higienePessoal'] ?? 0;
    _data.vestir = data['vestir'] ?? 0;
    _data.controleUrinario = data['controleUrinario'] ?? 0;
    _data.controleIntestinal = data['controleIntestinal'] ?? 0;
    _data.usarBanheiro = data['usarBanheiro'] ?? 0;
    _data.transferirCamaCadeira = data['transferirCamaCadeira'] ?? 0;
    _data.caminhar = data['caminhar'] ?? 0;
    _data.subirEscadas = data['subirEscadas'] ?? 0;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarBarthel() async {
    try {
      final score = CompletedScore(
        scoreName: 'Barthel Index',
        scoreData: {
          'alimentacao': _data.alimentacao,
          'banho': _data.banho,
          'higienePessoal': _data.higienePessoal,
          'vestir': _data.vestir,
          'controleUrinario': _data.controleUrinario,
          'controleIntestinal': _data.controleIntestinal,
          'usarBanheiro': _data.usarBanheiro,
          'transferirCamaCadeira': _data.transferirCamaCadeira,
          'caminhar': _data.caminhar,
          'subirEscadas': _data.subirEscadas,
        },
        resultado: '${_data.totalScore}/100 - ${_data.interpretacao}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Barthel salva com sucesso!'),
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
      title: 'Índice de Barthel',
      body: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Avaliação da independência funcional nas atividades de vida diária.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        
        QuestionCard<int>(
          title: 'Alimentação',
          subtitle: 'Capacidade de se alimentar.',
          value: _data.alimentacao,
          onChanged: (v) => setState(() { _data.alimentacao = v; onDataChanged(); }),
          options: const [
            QuestionOption(label: 'Independente (10)', value: 10),
            QuestionOption(label: 'Precisa de ajuda (5)', value: 5),
            QuestionOption(label: 'Dependente (0)', value: 0),
          ],
        ),

        QuestionCard<int>(
          title: 'Banho',
          subtitle: 'Capacidade de tomar banho.',
          value: _data.banho,
          onChanged: (v) => setState(() { _data.banho = v; onDataChanged(); }),
          options: const [
            QuestionOption(label: 'Independente (5)', value: 5),
            QuestionOption(label: 'Dependente (0)', value: 0),
          ],
        ),

        QuestionCard<int>(
          title: 'Higiene Pessoal',
          subtitle: 'Lavar rosto, pentear, barbear, dentes.',
          value: _data.higienePessoal,
          onChanged: (v) => setState(() { _data.higienePessoal = v; onDataChanged(); }),
          options: const [
            QuestionOption(label: 'Independente (5)', value: 5),
            QuestionOption(label: 'Dependente (0)', value: 0),
          ],
        ),

        QuestionCard<int>(
          title: 'Vestir-se',
          subtitle: 'Inclui amarrar sapatos, fecheclair.',
          value: _data.vestir,
          onChanged: (v) => setState(() { _data.vestir = v; onDataChanged(); }),
          options: const [
            QuestionOption(label: 'Independente (10)', value: 10),
            QuestionOption(label: 'Precisa de ajuda (5)', value: 5),
            QuestionOption(label: 'Dependente (0)', value: 0),
          ],
        ),

        QuestionCard<int>(
          title: 'Controle Intestinal',
          subtitle: 'Continência fecal.',
          value: _data.controleIntestinal,
          onChanged: (v) => setState(() { _data.controleIntestinal = v; onDataChanged(); }),
          options: const [
            QuestionOption(label: 'Continente (10)', value: 10),
            QuestionOption(label: 'Acidentes ocasionais (5)', value: 5),
            QuestionOption(label: 'Incontinente (0)', value: 0),
          ],
        ),

        QuestionCard<int>(
          title: 'Controle Urinário',
          subtitle: 'Continência urinária.',
          value: _data.controleUrinario,
          onChanged: (v) => setState(() { _data.controleUrinario = v; onDataChanged(); }),
          options: const [
            QuestionOption(label: 'Continente (10)', value: 10),
            QuestionOption(label: 'Acidentes ocasionais (5)', value: 5),
            QuestionOption(label: 'Incontinente (0)', value: 0),
          ],
        ),

        QuestionCard<int>(
          title: 'Usar Banheiro',
          subtitle: 'Ir ao banheiro, se limpar, ajeitar roupa.',
          value: _data.usarBanheiro,
          onChanged: (v) => setState(() { _data.usarBanheiro = v; onDataChanged(); }),
          options: const [
            QuestionOption(label: 'Independente (10)', value: 10),
            QuestionOption(label: 'Precisa de ajuda (5)', value: 5),
            QuestionOption(label: 'Dependente (0)', value: 0),
          ],
        ),

        QuestionCard<int>(
          title: 'Transferência',
          subtitle: 'Cama para cadeira e vice-versa.',
          value: _data.transferirCamaCadeira,
          onChanged: (v) => setState(() { _data.transferirCamaCadeira = v; onDataChanged(); }),
          options: const [
            QuestionOption(label: 'Independente (15)', value: 15),
            QuestionOption(label: 'Mínima ajuda (10)', value: 10),
            QuestionOption(label: 'Grande ajuda (5)', value: 5),
            QuestionOption(label: 'Dependente (0)', value: 0),
          ],
        ),

        QuestionCard<int>(
          title: 'Mobilidade',
          subtitle: 'Caminhar no plano.',
          value: _data.caminhar,
          onChanged: (v) => setState(() { _data.caminhar = v; onDataChanged(); }),
          options: const [
            QuestionOption(label: 'Independente > 50m (15)', value: 15),
            QuestionOption(label: 'Com ajuda (10)', value: 10),
            QuestionOption(label: 'Cadeira de rodas (5)', value: 5),
            QuestionOption(label: 'Imóvel (0)', value: 0),
          ],
        ),

        QuestionCard<int>(
          title: 'Escadas',
          subtitle: 'Subir e descer escadas.',
          value: _data.subirEscadas,
          onChanged: (v) => setState(() { _data.subirEscadas = v; onDataChanged(); }),
          options: const [
            QuestionOption(label: 'Independente (10)', value: 10),
            QuestionOption(label: 'Precisa de ajuda (5)', value: 5),
            QuestionOption(label: 'Incapaz (0)', value: 0),
          ],
        ),

        // Result Card
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
                    _data.interpretacao,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarBarthel,
        backgroundColor: _getScoreColor(_data.totalScore),
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green; // Independência total ou leve dependência
    if (score >= 60) return Colors.orange; // Dependência moderada
    if (score >= 20) return Colors.deepOrange; // Dependência severa
    return Colors.red; // Dependência total
  }
}
