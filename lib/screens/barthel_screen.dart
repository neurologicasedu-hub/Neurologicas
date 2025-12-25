import 'package:flutter/material.dart';
import '../models/barthel_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

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
        resultado: _data.interpretacao,
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
    final score = _data.totalScore;
    final interpretacao = _data.interpretacao;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barthel Index'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Avaliação de Atividades de Vida Diária (0-100 pontos)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildScoreItem('Alimentação', _data.alimentacao, 10, (val) {
            setState(() => _data.alimentacao = val);
            onDataChanged();
          }, 'Independente: 10 | Precisa ajuda: 5 | Dependente: 0'),
          _buildScoreItem('Banho', _data.banho, 5, (val) {
            setState(() => _data.banho = val);
            onDataChanged();
          }, 'Independente: 5 | Dependente: 0'),
          _buildScoreItem('Higiene Pessoal', _data.higienePessoal, 5, (val) {
            setState(() => _data.higienePessoal = val);
            onDataChanged();
          }, 'Independente: 5 | Dependente: 0'),
          _buildScoreItem('Vestir-se', _data.vestir, 10, (val) {
            setState(() => _data.vestir = val);
            onDataChanged();
          }, 'Independente: 10 | Precisa ajuda: 5 | Dependente: 0'),
          _buildScoreItem('Controle Urinário', _data.controleUrinario, 10, (val) {
            setState(() => _data.controleUrinario = val);
            onDataChanged();
          }, 'Continente: 10 | Acidentes ocasionais: 5 | Incontinente: 0'),
          _buildScoreItem('Controle Intestinal', _data.controleIntestinal, 10, (val) {
            setState(() => _data.controleIntestinal = val);
            onDataChanged();
          }, 'Continente: 10 | Acidentes ocasionais: 5 | Incontinente: 0'),
          _buildScoreItem('Usar Banheiro', _data.usarBanheiro, 10, (val) {
            setState(() => _data.usarBanheiro = val);
            onDataChanged();
          }, 'Independente: 10 | Precisa ajuda: 5 | Dependente: 0'),
          _buildScoreItem('Transferir Cama/Cadeira', _data.transferirCamaCadeira, 15, (val) {
            setState(() => _data.transferirCamaCadeira = val);
            onDataChanged();
          }, 'Independente: 15 | Mínima ajuda: 10 | Moderada: 5 | Dependente: 0'),
          _buildScoreItem('Caminhar', _data.caminhar, 15, (val) {
            setState(() => _data.caminhar = val);
            onDataChanged();
          }, 'Independente: 15 | Com ajuda: 10 | Cadeira: 5 | Imóvel: 0'),
          _buildScoreItem('Subir Escadas', _data.subirEscadas, 10, (val) {
            setState(() => _data.subirEscadas = val);
            onDataChanged();
          }, 'Independente: 10 | Precisa ajuda: 5 | Incapaz: 0'),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(score),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Pontuação Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/100', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarBarthel();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Barthel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String title, int value, int max, ValueChanged<int> onChanged, String descricao) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(descricao, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(max ~/ 5 + 1, (index) {
                int score = index * 5;
                if (score > max) score = max;
                bool selected = value == score;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: ElevatedButton(
                      onPressed: () => onChanged(score),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selected ? Colors.teal : Colors.grey.shade300,
                        foregroundColor: selected ? Colors.white : Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text('$score', style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}

