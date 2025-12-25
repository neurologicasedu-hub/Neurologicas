import 'package:flutter/material.dart';
import '../models/nitroprussiato_data.dart';
import 'relatorio_final_screen.dart';

class NitroprussiatoScreen extends StatelessWidget {
  final double pesoPaciente;
  final int? nihssScore;
  final String? interpretacaoNIHSS;
  final bool elegivelTrombolise;
  final String? doseRtpa;
  final int? pas;
  final int? pad;
  final String? condutaPressao;

  const NitroprussiatoScreen({
    super.key,
    required this.pesoPaciente,
    this.nihssScore,
    this.interpretacaoNIHSS,
    this.elegivelTrombolise = false,
    this.doseRtpa,
    this.pas,
    this.pad,
    this.condutaPressao,
  });

  @override
  Widget build(BuildContext context) {
    final nitroprussiatoData = NitroprussiatoData(pesoPaciente: pesoPaciente);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescrição de Nitroprussiato'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card com informações do paciente
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informações do Paciente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Peso: ${pesoPaciente.toStringAsFixed(1)} kg'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Card com a prescrição
          Card(
            color: Colors.teal.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.medication_liquid,
                        size: 40,
                        color: Colors.teal.shade700,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Prescrição de Nitroprussiato',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Dose:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${nitroprussiatoData.dose.toStringAsFixed(2)} µg/kg/min',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Taxa de infusão:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${nitroprussiatoData.taxaInfusao.toStringAsFixed(2)} ml/h',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.amber.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            nitroprussiatoData.orientacoes,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Informações adicionais
          Card(
            color: Colors.grey.shade100,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informações Técnicas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Nitroprussiato de sódio diluído em solução de glicose a 5%\n'
                    '• Preparação: 50 mg em 250 ml de SF (concentração: 200 µg/ml)\n'
                    '• Administração via bomba de infusão\n'
                    '• Monitoramento contínuo da PA a cada 5-15 minutos\n'
                    '• Dose máxima: 10 µg/kg/min',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Botão para prosseguir para relatório final
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RelatorioFinalScreen(
                      nihssScore: nihssScore,
                      interpretacaoNIHSS: interpretacaoNIHSS,
                      elegivelTrombolise: elegivelTrombolise,
                      doseRtpa: doseRtpa,
                      pas: pas,
                      pad: pad,
                      condutaPressao: condutaPressao,
                      pesoPaciente: pesoPaciente,
                      doseNitroprussiato: nitroprussiatoData.dose,
                      taxaNitroprussiato: nitroprussiatoData.taxaInfusao,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.description),
              label: const Text('Ver Relatório Final'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Botões
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Início'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

