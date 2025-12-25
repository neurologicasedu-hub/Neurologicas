import 'package:flutter/material.dart';
import '../models/aspects_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

class AspectsScreen extends StatefulWidget {
  const AspectsScreen({super.key});

  @override
  State<AspectsScreen> createState() => _AspectsScreenState();
}

class _AspectsScreenState extends State<AspectsScreen> with AutoSaveMixin {
  final AspectsData _data = AspectsData();

  @override
  String get scaleName => 'aspects';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'caudado': _data.caudado,
      'putamen': _data.putamen,
      'insula': _data.insula,
      'capsulaInterna': _data.capsulaInterna,
      'M1': _data.M1,
      'M2': _data.M2,
      'M3': _data.M3,
      'M4': _data.M4,
      'M5': _data.M5,
      'M6': _data.M6,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.caudado = data['caudado'] ?? false;
    _data.putamen = data['putamen'] ?? false;
    _data.insula = data['insula'] ?? false;
    _data.capsulaInterna = data['capsulaInterna'] ?? false;
    _data.M1 = data['M1'] ?? false;
    _data.M2 = data['M2'] ?? false;
    _data.M3 = data['M3'] ?? false;
    _data.M4 = data['M4'] ?? false;
    _data.M5 = data['M5'] ?? false;
    _data.M6 = data['M6'] ?? false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarASPECTS() async {
    try {
      final score = CompletedScore(
        scoreName: 'ASPECTS',
        scoreData: {
          'caudado': _data.caudado,
          'putamen': _data.putamen,
          'insula': _data.insula,
          'capsulaInterna': _data.capsulaInterna,
          'M1': _data.M1,
          'M2': _data.M2,
          'M3': _data.M3,
          'M4': _data.M4,
          'M5': _data.M5,
          'M6': _data.M6,
        },
        resultado: _data.interpretacao,
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ASPECTS salva com sucesso!'),
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
        title: const Text('ASPECTS'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Alberta Stroke Program Early CT Score\n(Marcar áreas afetadas)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _buildCheckbox('Núcleo Caudado', _data.caudado, (val) {
            setState(() => _data.caudado = val);
            onDataChanged();
          }),
          _buildCheckbox('Putamen', _data.putamen, (val) {
            setState(() => _data.putamen = val);
            onDataChanged();
          }),
          _buildCheckbox('Ínsula', _data.insula, (val) {
            setState(() => _data.insula = val);
            onDataChanged();
          }),
          _buildCheckbox('Cápsula Interna', _data.capsulaInterna, (val) {
            setState(() => _data.capsulaInterna = val);
            onDataChanged();
          }),
          _buildCheckbox('M1 (córtex anterior)', _data.M1, (val) {
            setState(() => _data.M1 = val);
            onDataChanged();
          }),
          _buildCheckbox('M2 (córtex lateral)', _data.M2, (val) {
            setState(() => _data.M2 = val);
            onDataChanged();
          }),
          _buildCheckbox('M3 (córtex posterior)', _data.M3, (val) {
            setState(() => _data.M3 = val);
            onDataChanged();
          }),
          _buildCheckbox('M4 (córtex superior anterior)', _data.M4, (val) {
            setState(() => _data.M4 = val);
            onDataChanged();
          }),
          _buildCheckbox('M5 (córtex superior lateral)', _data.M5, (val) {
            setState(() => _data.M5 = val);
            onDataChanged();
          }),
          _buildCheckbox('M6 (córtex superior posterior)', _data.M6, (val) {
            setState(() => _data.M6 = val);
            onDataChanged();
          }),
          const SizedBox(height: 16),
          Card(
            color: _getScoreColor(score),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Score ASPECTS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/10', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(interpretacao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarASPECTS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala ASPECTS'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, ValueChanged<bool> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: CheckboxListTile(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        value: value,
        onChanged: (val) => onChanged(val ?? false),
        activeColor: Colors.indigo,
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 8) return Colors.green;
    if (score >= 5) return Colors.orange;
    return Colors.red;
  }
}

