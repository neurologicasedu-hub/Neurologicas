import 'package:flutter/material.dart';
import '../models/aspects_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';

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

    return CalculatorScaffold(
      title: 'ASPECTS',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Alberta Stroke Program Early CT Score\n(Marcar áreas afetadas)',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          
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
          
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(score),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(score).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('ASPECTS SCORE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                 const Text(
                  '/ 10',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                   child: Text(
                    interpretacao,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarASPECTS,
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: value ? Colors.indigo : Colors.transparent, width: 2),
         boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: CheckboxListTile(
        title: Text(title, style: TextStyle(
          fontSize: 16, 
          fontWeight: value ? FontWeight.bold : FontWeight.w500,
          color: const Color(0xFF2D3748),
        )),
        value: value,
        onChanged: (val) => onChanged(val ?? false),
        activeColor: Colors.indigo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 8) return Colors.green;
    if (score >= 5) return Colors.orange;
    return Colors.red;
  }
}
