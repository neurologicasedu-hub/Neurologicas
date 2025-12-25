import 'package:flutter/material.dart';
import '../models/edss_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class EDSSScreen extends StatefulWidget {
  const EDSSScreen({super.key});

  @override
  State<EDSSScreen> createState() => _EDSSScreenState();
}

class _EDSSScreenState extends State<EDSSScreen> {
  final EDSSData _data = EDSSData();
  final List<Map<String, dynamic>> _edssOptions = [
    {'value': 0.0, 'description': 'Exame neurológico normal'},
    {'value': 1.0, 'description': 'Sem incapacidade, sinais neurológicos mínimos'},
    {'value': 1.5, 'description': 'Sem incapacidade, sinais neurológicos mínimos (mais de um FS)'},
    {'value': 2.0, 'description': 'Incapacidade mínima em um FS'},
    {'value': 2.5, 'description': 'Incapacidade leve em um FS ou incapacidade mínima em dois FS'},
    {'value': 3.0, 'description': 'Incapacidade moderada em um FS ou incapacidade leve em 3-4 FS; totalmente ambulatorial'},
    {'value': 3.5, 'description': 'Totalmente ambulatorial; incapacidade moderada em um FS e mais de 1,5-2,0 em vários outros FS'},
    {'value': 4.0, 'description': 'Totalmente ambulatorial sem ajuda; autocuidado; capaz de caminhar sem ajuda ou descanso por aproximadamente 500 m'},
    {'value': 4.5, 'description': 'Totalmente ambulatorial sem ajuda; autocuidado; capaz de trabalhar dia inteiro; pode ter limitações físicas ou necessitar mínimo assistência; capaz de caminhar sem ajuda ou descanso por aproximadamente 300 m'},
    {'value': 5.0, 'description': 'Capaz de caminhar sem ajuda ou descanso por aproximadamente 200 m; incapacidade suficientemente severa para impedir atividades diárias'},
    {'value': 5.5, 'description': 'Capaz de caminhar sem ajuda ou descanso por aproximadamente 100 m; incapacidade suficientemente severa para impedir atividades diárias'},
    {'value': 6.0, 'description': 'Requer ajuda intermitente ou unilateral para caminhar aproximadamente 100 m com ou sem descanso'},
    {'value': 6.5, 'description': 'Requer ajuda bilateral constante para caminhar aproximadamente 20 m sem descanso'},
    {'value': 7.0, 'description': 'Incapaz de caminhar além de aproximadamente 5 m mesmo com ajuda; essencialmente restrito à cadeira de rodas; usa cadeira de rodas independentemente'},
    {'value': 7.5, 'description': 'Incapaz de caminhar mais de alguns passos; restrito à cadeira de rodas; pode precisar cadeira de rodas motorizada; geralmente pode transferir-se sozinho'},
    {'value': 8.0, 'description': 'Essencialmente restrito à cama, cadeira ou cadeira de rodas, ou pode estar no leito a maior parte do dia; retém muitas funções de autocuidado; geralmente usa braços efetivamente'},
    {'value': 8.5, 'description': 'Essencialmente restrito ao leito a maior parte do dia; tem algumas funções úteis de braços; retém algumas funções de autocuidado'},
    {'value': 9.0, 'description': 'Acamado; ainda pode comunicar e comer'},
    {'value': 9.5, 'description': 'Acamado; incapaz de comunicar efetivamente ou comer/deglutir'},
    {'value': 10.0, 'description': 'Morte devido a EM'},
  ];

  Future<void> _salvarEDSS() async {
    try {
      final score = CompletedScore(
        scoreName: 'EDSS (Expanded Disability Status Scale)',
        scoreData: {'edssScore': _data.edssScore},
        resultado: 'EDSS: ${_data.edssScore} - ${_data.edssDescription} - ${_data.interpretation}',
        totalScore: (_data.edssScore * 10).round(),
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala EDSS salva com sucesso!'),
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
        title: const Text('EDSS - Expanded Disability Status Scale'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'EDSS - Escala Expandida do Status de Incapacidade',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Selecione a descrição que melhor representa o estado do paciente:',
            style: TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ..._edssOptions.map((option) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: _data.edssScore == option['value'] ? 4 : 1,
            color: _data.edssScore == option['value'] ? Colors.indigo.shade50 : null,
            child: RadioListTile<double>(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EDSS ${(option['value'] as double).toStringAsFixed((option['value'] as double) == (option['value'] as double).roundToDouble() ? 0 : 1)}',
                    style: TextStyle(
                      fontWeight: _data.edssScore == option['value'] ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option['description'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: _data.edssScore == option['value'] ? Colors.indigo.shade700 : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              value: option['value'] as double,
              groupValue: _data.edssScore,
              onChanged: (val) => setState(() => _data.edssScore = val ?? 0.0),
              activeColor: Colors.indigo,
            ),
          )),
          const SizedBox(height: 16),
          if (_data.edssScore >= 0)
            Card(
              color: Colors.indigo.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EDSS ${_data.edssScore.toStringAsFixed(_data.edssScore == _data.edssScore.roundToDouble() ? 0 : 1)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _data.edssDescription,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _data.interpretation,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.indigo.shade700),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarEDSS();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala EDSS'),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}