import 'package:flutter/material.dart';
import '../models/marshall_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';
import '../widgets/calculator_scaffold.dart';
import '../widgets/question_card.dart';

class MarshallScreen extends StatefulWidget {
  const MarshallScreen({super.key});

  @override
  State<MarshallScreen> createState() => _MarshallScreenState();
}

class _MarshallScreenState extends State<MarshallScreen> with AutoSaveMixin {
  final MarshallData _data = MarshallData();

  @override
  String get scaleName => 'marshall';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'compressao': _data.compressao,
      'cisternaBasilar': _data.cisternaBasilar,
      'desvio': _data.desvio,
      'lesaoMassa': _data.lesaoMassa,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.compressao = data['compressao'] ?? 0;
    _data.cisternaBasilar = data['cisternaBasilar'] ?? false;
    _data.desvio = data['desvio'] ?? 0;
    _data.lesaoMassa = data['lesaoMassa'] ?? false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarMarshall() async {
    try {
      final score = CompletedScore(
        scoreName: 'Marshall Classification',
        scoreData: {
          'compressao': _data.compressao,
          'cisternaBasilar': _data.cisternaBasilar,
          'desvio': _data.desvio,
          'lesaoMassa': _data.lesaoMassa,
        },
        resultado: 'Classe ${_data.classificacao} - ${_data.interpretacao}',
        totalScore: _data.classificacao,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Marshall salva com sucesso!'),
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
    final classificacao = _data.classificacao;
    final interpretacao = _data.interpretacao;

    return CalculatorScaffold(
      title: 'Marshall Classification',
      body: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Classificação de Marshall (Baseada em TC)',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          
          QuestionCard<int>(
            title: 'Compressão do Sistema Ventricular',
            value: _data.compressao,
            onChanged: (v) {
              setState(() => _data.compressao = v);
              onDataChanged();
            },
            options: const [
              QuestionOption(label: 'Normal', value: 0),
              QuestionOption(label: 'Ausente/Comprimida', value: 1),
            ],
          ),

          _buildCheckbox('Cisterna Basilar Ausente', !_data.cisternaBasilar, (val) {
               // Logic inverted in original: "Cisterna Basilar Visivel/Normal" is boolean.
               // If visible/normal is true (default?), then it's good.
               // The question here is to toggle the state.
               setState(() => _data.cisternaBasilar = !val);
               onDataChanged();
          }, subtitle: 'Marque se a cisterna estiver ausente ou comprimida'),

          QuestionCard<int>(
            title: 'Desvio da Linha Média',
            value: _data.desvio,
            onChanged: (v) {
              setState(() => _data.desvio = v);
              onDataChanged();
            },
            options: const [
              QuestionOption(label: 'Sem desvio', value: 0),
              QuestionOption(label: '0-5 mm', value: 1),
              QuestionOption(label: '> 5 mm', value: 2),
            ],
          ),

          _buildCheckbox('Lesão de Massa > 25cc', _data.lesaoMassa, (val) {
            setState(() => _data.lesaoMassa = val);
            onDataChanged();
          }, subtitle: 'Não evacuada cirurgicamente'),

          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getScoreColor(classificacao),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: _getScoreColor(classificacao).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                const Text('MARSHALL CLASS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  '$classificacao',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                ),
                const SizedBox(height: 12),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                   child: Text(
                      _data.descricao,
                      style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                 ),
                 const SizedBox(height: 8),
                 Text(
                  interpretacao,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarMarshall,
        backgroundColor: Colors.brown,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Salvar Resultado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, ValueChanged<bool> onChanged, {String? subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: value ? Colors.brown : Colors.transparent, width: 2),
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
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])) : null,
        value: value,
        onChanged: (val) => onChanged(val ?? false),
        activeColor: Colors.brown,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Color _getScoreColor(int classificacao) {
    if (classificacao <= 2) return Colors.green;
    if (classificacao == 3) return Colors.orange;
    return Colors.red;
  }
}
