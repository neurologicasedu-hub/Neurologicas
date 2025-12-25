import 'package:flutter/material.dart';
import '../models/trombolise_data.dart';
import 'pressao_screen.dart';

class TromboliseScreen extends StatefulWidget {
  final int? nihssScore;
  final double? pesoPaciente;
  final String? interpretacaoNIHSS;

  const TromboliseScreen({
    super.key,
    this.nihssScore,
    this.pesoPaciente,
    this.interpretacaoNIHSS,
  });

  @override
  State<TromboliseScreen> createState() => _TromboliseScreenState();
}

class _TromboliseScreenState extends State<TromboliseScreen> {
  late TromboliseData _tromboliseData;

  @override
  void initState() {
    super.initState();
    _tromboliseData = TromboliseData(
      nihssScore: widget.nihssScore,
      pesoPaciente: widget.pesoPaciente,
    );
    // Verificar automaticamente se NIHSS > 25
    if (widget.nihssScore != null && widget.nihssScore! > 25) {
      _tromboliseData.nihssAlto = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final criterios = _tromboliseData.criteriosExclusao;
    final elegivel = _tromboliseData.elegivel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Critérios de Exclusão - Trombólise'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card com informações do paciente
          if (widget.nihssScore != null || widget.pesoPaciente != null)
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
                    if (widget.nihssScore != null)
                      Text('NIHSS: ${widget.nihssScore}'),
                    if (widget.pesoPaciente != null)
                      Text('Peso: ${widget.pesoPaciente!.toStringAsFixed(1)} kg'),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          
          const Text(
            'Selecione os critérios de exclusão presentes:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildCheckboxItem(
            'Hemorragia intracraniana prévia',
            _tromboliseData.hemorragiaIntracranianaPrevia,
            (val) => setState(() => _tromboliseData.hemorragiaIntracranianaPrevia = val),
            color: Colors.red.shade700,
          ),
          _buildCheckboxItem(
            'Suspeita de AVC hemorrágico',
            _tromboliseData.suspeitaAvcHemorragico,
            (val) => setState(() => _tromboliseData.suspeitaAvcHemorragico = val),
            color: Colors.red.shade700,
          ),
          _buildCheckboxItem(
            'PA > 185x110 mmHg não controlada',
            _tromboliseData.paAltaNaoControlada,
            (val) => setState(() => _tromboliseData.paAltaNaoControlada = val),
            color: Colors.orange.shade700,
          ),
          _buildCheckboxItem(
            'Uso atual de anticoagulantes (INR ≥ 1,7 ou TTPa > 40s)',
            _tromboliseData.usoAnticoagulantes,
            (val) => setState(() => _tromboliseData.usoAnticoagulantes = val),
            color: Colors.red.shade700,
          ),
          _buildCheckboxItem(
            'Cirurgia intracraniana ou trauma grave nos últimos 3 meses',
            _tromboliseData.cirurgiaIntracraniana3Meses,
            (val) => setState(() => _tromboliseData.cirurgiaIntracraniana3Meses = val),
            color: Colors.red.shade700,
          ),
          _buildCheckboxItem(
            'Sangramento ativo ou distúrbio hemorrágico',
            _tromboliseData.sangramentoAtivo,
            (val) => setState(() => _tromboliseData.sangramentoAtivo = val),
            color: Colors.red.shade700,
          ),
          _buildCheckboxItem(
            'Plaquetas < 100.000/mm³',
            _tromboliseData.plaquetasBaixas,
            (val) => setState(() => _tromboliseData.plaquetasBaixas = val),
            color: Colors.red.shade700,
          ),
          _buildCheckboxItem(
            'Glicemia < 50 ou > 400 mg/dL',
            _tromboliseData.glicemiaAnormal,
            (val) => setState(() => _tromboliseData.glicemiaAnormal = val),
            color: Colors.orange.shade700,
          ),
          _buildCheckboxItem(
            'Neoplasia intracraniana conhecida',
            _tromboliseData.neoplasiaIntracraniana,
            (val) => setState(() => _tromboliseData.neoplasiaIntracraniana = val),
            color: Colors.red.shade700,
          ),
          _buildCheckboxItem(
            'Dissecção aórtica suspeita',
            _tromboliseData.dissecacaoAortica,
            (val) => setState(() => _tromboliseData.dissecacaoAortica = val),
            color: Colors.red.shade700,
          ),
          _buildCheckboxItem(
            'Idade > 80 anos',
            _tromboliseData.idadeAvancada,
            (val) => setState(() => _tromboliseData.idadeAvancada = val),
            color: Colors.orange.shade700,
          ),
          _buildCheckboxItem(
            'NIHSS > 25 (AVC extenso)',
            _tromboliseData.nihssAlto,
            (val) => setState(() => _tromboliseData.nihssAlto = val),
            color: Colors.red.shade700,
            enabled: false, // Já é preenchido automaticamente
          ),
          _buildCheckboxItem(
            'Gravidez',
            _tromboliseData.gravidez,
            (val) => setState(() => _tromboliseData.gravidez = val),
            color: Colors.red.shade700,
          ),
          _buildCheckboxItem(
            'Uso recente de heparina (<48h)',
            _tromboliseData.usoHeparina48h,
            (val) => setState(() => _tromboliseData.usoHeparina48h = val),
            color: Colors.red.shade700,
          ),
          _buildCheckboxItem(
            'Cirurgia maior recente',
            _tromboliseData.cirurgiaMaiorRecente,
            (val) => setState(() => _tromboliseData.cirurgiaMaiorRecente = val),
            color: Colors.orange.shade700,
          ),
          _buildCheckboxItem(
            'IAM recente (<3 meses)',
            _tromboliseData.iamRecente,
            (val) => setState(() => _tromboliseData.iamRecente = val),
            color: Colors.orange.shade700,
          ),
          _buildCheckboxItem(
            'Histórico de hemorragia gastrointestinal recente',
            _tromboliseData.hemorragiaGiRecente,
            (val) => setState(() => _tromboliseData.hemorragiaGiRecente = val),
            color: Colors.orange.shade700,
          ),
          
          const SizedBox(height: 24),
          
          // Card de resultado
          Card(
            color: elegivel ? Colors.green.shade50 : Colors.red.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    elegivel ? Icons.check_circle : Icons.cancel,
                    color: elegivel ? Colors.green : Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _tromboliseData.recomendacao,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: elegivel ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  if (!elegivel && criterios.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Critérios de Exclusão Detectados:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...criterios.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(color: Colors.red)),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    )),
                  ],
                  
                  if (elegivel && _tromboliseData.doseRtpa != null) ...[
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dose Recomendada de rtPA:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _tromboliseData.doseRtpa!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Botão para prosseguir para controle de pressão
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PressaoScreen(
                      pesoPaciente: widget.pesoPaciente,
                      teveTrombolise: elegivel,
                      nihssScore: widget.nihssScore,
                      interpretacaoNIHSS: widget.interpretacaoNIHSS,
                      elegivelTrombolise: elegivel,
                      doseRtpa: _tromboliseData.doseRtpa,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Prosseguir para Controle de Pressão'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
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

  Widget _buildCheckboxItem(
    String title,
    bool value,
    ValueChanged<bool> onChanged, {
    Color? color,
    bool enabled = true,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: enabled ? null : Colors.grey,
          ),
        ),
        value: value,
        onChanged: enabled ? (val) => onChanged(val ?? false) : null,
        activeColor: color ?? Colors.blue,
        dense: true,
      ),
    );
  }
}
