import 'package:flutter/material.dart';

class RelatorioFinalScreen extends StatelessWidget {
  final int? nihssScore;
  final String? interpretacaoNIHSS;
  final bool elegivelTrombolise;
  final String? doseRtpa;
  final int? pas;
  final int? pad;
  final String? condutaPressao;
  final double? pesoPaciente;
  final double? doseNitroprussiato;
  final double? taxaNitroprussiato;

  const RelatorioFinalScreen({
    super.key,
    this.nihssScore,
    this.interpretacaoNIHSS,
    this.elegivelTrombolise = false,
    this.doseRtpa,
    this.pas,
    this.pad,
    this.condutaPressao,
    this.pesoPaciente,
    this.doseNitroprussiato,
    this.taxaNitroprussiato,
  });

  void _capturarTela(BuildContext context, GlobalKey key) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Use a função de screenshot do dispositivo (Power + Volume Down no Android ou AssistiveTouch no iOS) para capturar o relatório.'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey repaintKey = GlobalKey();
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    const bottomBarHeight = 80.0;
    final availableHeight = screenHeight - appBarHeight - bottomBarHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório Final'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _capturarTela(context, repaintKey),
            tooltip: 'Capturar Tela',
          ),
        ],
      ),
      body: RepaintBoundary(
        key: repaintKey,
        child: Container(
          padding: const EdgeInsets.all(12),
          height: availableHeight,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabeçalho
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.indigo.shade200),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'RELATÓRIO CLÍNICO - AVALIAÇÃO DE AVC',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Calculadora Neurológica',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Informações do Paciente
                if (pesoPaciente != null)
                  _buildSection(
                    title: 'INFORMAÇÕES DO PACIENTE',
                    children: [
                      _buildRow('Peso', '${pesoPaciente!.toStringAsFixed(1)} kg'),
                    ],
                  ),

                // NIHSS
                if (nihssScore != null)
                  _buildSection(
                    title: 'NIHSS - ESCALA DE AVC',
                    children: [
                      _buildRow('Pontuação Total', '$nihssScore'),
                      if (interpretacaoNIHSS != null)
                        _buildRow('Interpretação', interpretacaoNIHSS!),
                    ],
                  ),

                // Critérios de Exclusão de Trombólise
                _buildSection(
                  title: 'CRITÉRIOS DE EXCLUSÃO - TROMBÓLISE',
                  children: [
                    _buildRow(
                      'Elegibilidade',
                      elegivelTrombolise
                          ? 'ELEGÍVEL para trombólise'
                          : 'NÃO ELEGÍVEL para trombólise',
                      valueColor: elegivelTrombolise ? Colors.green : Colors.red,
                    ),
                    if (elegivelTrombolise && doseRtpa != null)
                      _buildRow('Dose de rtPA', doseRtpa!),
                  ],
                ),

                // Controle de Pressão
                if (pas != null && pad != null)
                  _buildSection(
                    title: 'CONTROLE DE PRESSÃO ARTERIAL',
                    children: [
                      _buildRow('PA', '$pas/$pad mmHg'),
                      if (condutaPressao != null)
                        _buildRow('Conduta', condutaPressao!),
                    ],
                  ),

                // Prescrição de Nitroprussiato
                if (doseNitroprussiato != null && taxaNitroprussiato != null)
                  _buildSection(
                    title: 'PRESCRIÇÃO DE NITROPRUSSIATO',
                    children: [
                      _buildRow(
                        'Dose',
                        '${doseNitroprussiato!.toStringAsFixed(2)} µg/kg/min',
                      ),
                      _buildRow(
                        'Taxa de Infusão',
                        '${taxaNitroprussiato!.toStringAsFixed(2)} ml/h',
                      ),
                      _buildRow(
                        'Orientação',
                        'Monitorar PA e ajustar a dose para redução gradual de 10–15% da PA',
                      ),
                    ],
                  ),

                // Rodapé
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Ferramenta de apoio à decisão clínica. Consulte diretrizes oficiais.',
                    style: TextStyle(
                      fontSize: 9,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
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
                  _capturarTela(context, repaintKey);
                },
                icon: const Icon(Icons.print),
                label: const Text('Capturar Tela'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
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
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const Divider(height: 8, thickness: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

