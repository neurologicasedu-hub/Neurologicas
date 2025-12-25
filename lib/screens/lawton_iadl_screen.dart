import 'package:flutter/material.dart';
import '../models/lawton_iadl_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class LawtonIADLScreen extends StatefulWidget {
  const LawtonIADLScreen({super.key});

  @override
  State<LawtonIADLScreen> createState() => _LawtonIADLScreenState();
}

class _LawtonIADLScreenState extends State<LawtonIADLScreen> {
  final LawtonIADLData _data = LawtonIADLData();

  final List<String> _activities = [
    'Usar o telefone',
    'Fazer compras',
    'Preparar comida',
    'Cuidar da casa',
    'Lavar roupa',
    'Usar transporte',
    'Tomar medicamentos',
    'Administrar finanças',
  ];

  Future<void> _salvarLawtonIADL() async {
    try {
      final score = CompletedScore(
        scoreName: 'Lawton IADL Scale',
        scoreData: {
          'telefone': _data.telefone,
          'compras': _data.compras,
          'prepararComida': _data.prepararComida,
          'cuidadosCasa': _data.cuidadosCasa,
          'lavarRoupa': _data.lavarRoupa,
          'transporte': _data.transporte,
          'medicamentos': _data.medicamentos,
          'financas': _data.financas,
        },
        resultado: '${_data.totalScore}/8 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala Lawton IADL salva com sucesso!'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildActivityItem(int index, String activity, int value, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index + 1}. $activity', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            RadioListTile<int>(
              title: const Text('Independente (1 ponto)', style: TextStyle(fontSize: 12)),
              value: 1,
              groupValue: value,
              onChanged: (val) => onChanged(val ?? 0),
              activeColor: Colors.green,
              dense: true,
            ),
            RadioListTile<int>(
              title: const Text('Dependente/Precisa de ajuda (0 pontos)', style: TextStyle(fontSize: 12)),
              value: 0,
              groupValue: value,
              onChanged: (val) => onChanged(val ?? 0),
              activeColor: Colors.green,
              dense: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawton IADL Scale'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Lawton Instrumental Activities of Daily Living Scale\nAvalia a capacidade funcional para atividades instrumentais',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildActivityItem(0, _activities[0], _data.telefone, (v) => setState(() => _data.telefone = v)),
          _buildActivityItem(1, _activities[1], _data.compras, (v) => setState(() => _data.compras = v)),
          _buildActivityItem(2, _activities[2], _data.prepararComida, (v) => setState(() => _data.prepararComida = v)),
          _buildActivityItem(3, _activities[3], _data.cuidadosCasa, (v) => setState(() => _data.cuidadosCasa = v)),
          _buildActivityItem(4, _activities[4], _data.lavarRoupa, (v) => setState(() => _data.lavarRoupa = v)),
          _buildActivityItem(5, _activities[5], _data.transporte, (v) => setState(() => _data.transporte = v)),
          _buildActivityItem(6, _activities[6], _data.medicamentos, (v) => setState(() => _data.medicamentos = v)),
          _buildActivityItem(7, _activities[7], _data.financas, (v) => setState(() => _data.financas = v)),
          const SizedBox(height: 16),
          Card(
            color: score >= 6 ? Colors.green : score >= 4 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Lawton IADL Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/8', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarLawtonIADL,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala Lawton IADL'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}

