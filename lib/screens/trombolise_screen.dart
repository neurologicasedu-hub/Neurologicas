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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card com informações do paciente
          if (widget.nihssScore != null || widget.pesoPaciente != null)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, color: Colors.blue.shade700),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paciente',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (widget.nihssScore != null)
                             Text(
                              'NIHSS: ${widget.nihssScore}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          if (widget.nihssScore != null && widget.pesoPaciente != null)
                            const SizedBox(width: 16),
                          if (widget.pesoPaciente != null)
                            Text(
                              'Peso: ${widget.pesoPaciente!.toStringAsFixed(1)} kg',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          
          const Text(
            'Critérios de Exclusão',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Marque todos os itens que se aplicam ao paciente.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('Histórico e Risco Hemorrágico', Icons.history),
          _buildCheckboxItem(
            'Hemorragia intracraniana prévia',
            _tromboliseData.hemorragiaIntracranianaPrevia,
            (val) => setState(() => _tromboliseData.hemorragiaIntracranianaPrevia = val),
            isCritical: true,
          ),
          _buildCheckboxItem(
            'Suspeita de AVC hemorrágico',
            _tromboliseData.suspeitaAvcHemorragico,
            (val) => setState(() => _tromboliseData.suspeitaAvcHemorragico = val),
            isCritical: true,
          ),
          _buildCheckboxItem(
            'Cirurgia intracraniana ou trauma grave (3 meses)',
            _tromboliseData.cirurgiaIntracraniana3Meses,
            (val) => setState(() => _tromboliseData.cirurgiaIntracraniana3Meses = val),
            isCritical: true,
          ),
          _buildCheckboxItem(
            'Sangramento ativo ou diátese hemorrágica',
            _tromboliseData.sangramentoAtivo,
            (val) => setState(() => _tromboliseData.sangramentoAtivo = val),
            isCritical: true,
          ),
          _buildCheckboxItem(
            'Neoplasia intracraniana / MAV / Aneurisma',
            _tromboliseData.neoplasiaIntracraniana,
            (val) => setState(() => _tromboliseData.neoplasiaIntracraniana = val),
            isCritical: true,
          ),
          _buildCheckboxItem(
            'Suspeita de Dissecção Aórtica',
            _tromboliseData.dissecacaoAortica,
            (val) => setState(() => _tromboliseData.dissecacaoAortica = val),
            isCritical: true,
          ),
          _buildCheckboxItem(
            'Hemorragia gastrointestinal recente (<21 dias)',
            _tromboliseData.hemorragiaGiRecente,
            (val) => setState(() => _tromboliseData.hemorragiaGiRecente = val),
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('Estado Clínico Atual', Icons.accessibility_new),
          _buildCheckboxItem(
            'PA > 185x110 mmHg não controlada',
            _tromboliseData.paAltaNaoControlada,
            (val) => setState(() => _tromboliseData.paAltaNaoControlada = val),
            isCritical: true,
          ),
          _buildCheckboxItem(
            'NIHSS > 25 (AVC muito extenso)',
            _tromboliseData.nihssAlto,
            (val) => setState(() => _tromboliseData.nihssAlto = val),
            enabled: false,
          ),
           _buildCheckboxItem(
            'Idade > 80 anos',
            _tromboliseData.idadeAvancada,
            (val) => setState(() => _tromboliseData.idadeAvancada = val),
          ),
          _buildCheckboxItem(
            'Gravidez',
            _tromboliseData.gravidez,
            (val) => setState(() => _tromboliseData.gravidez = val),
          ),
          _buildCheckboxItem(
            'IAM recente (<3 meses)',
            _tromboliseData.iamRecente,
            (val) => setState(() => _tromboliseData.iamRecente = val),
          ),
          _buildCheckboxItem(
            'Cirurgia maior recente (<14 dias)',
            _tromboliseData.cirurgiaMaiorRecente,
            (val) => setState(() => _tromboliseData.cirurgiaMaiorRecente = val),
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('Laboratorial e Medicamentoso', Icons.info_outline),
          _buildCheckboxItem(
            'Uso de Anticoagulantes (INR ≥ 1,7 / NOACs)',
            _tromboliseData.usoAnticoagulantes,
            (val) => setState(() => _tromboliseData.usoAnticoagulantes = val),
            isCritical: true,
          ),
           _buildCheckboxItem(
            'Uso de Heparina (<48h) com TTPa alargado',
            _tromboliseData.usoHeparina48h,
            (val) => setState(() => _tromboliseData.usoHeparina48h = val),
            isCritical: true,
          ),
          _buildCheckboxItem(
            'Plaquetas < 100.000/mm³',
            _tromboliseData.plaquetasBaixas,
            (val) => setState(() => _tromboliseData.plaquetasBaixas = val),
            isCritical: true,
          ),
          _buildCheckboxItem(
            'Glicemia < 50 ou > 400 mg/dL',
            _tromboliseData.glicemiaAnormal,
            (val) => setState(() => _tromboliseData.glicemiaAnormal = val),
          ),
          
          const SizedBox(height: 32),
          
          // Card de resultado
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: elegivel ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: elegivel ? Colors.green.shade200 : Colors.red.shade200,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (elegivel ? Colors.green : Colors.red).withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                  ),
                  child: Icon(
                    elegivel ? Icons.check_circle_outline : Icons.highlight_off,
                    color: elegivel ? Colors.green.shade600 : Colors.red.shade600,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _tromboliseData.recomendacao,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: elegivel ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                if (!elegivel && criterios.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CRITÉRIOS DE EXCLUSÃO:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade800,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...criterios.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                              Expanded(child: Text(item, style: TextStyle(color: Colors.red.shade900))),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
                
                if (elegivel && _tromboliseData.doseRtpa != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'DOSE RECOMENDADA (rtPA)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00509D),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                         Text(
                          _tromboliseData.doseRtpa!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Botão para prosseguir
          ElevatedButton(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C3E50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('PROSSEGUIR PARA CONTROLE DE PA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          TextButton.icon(
             onPressed: () => Navigator.pop(context),
             icon: const Icon(Icons.arrow_back, size: 18),
             label: const Text('Voltar para Resultados'),
             style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF00509D)),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF00509D),
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.0
            ),
          ),
          const Expanded(child: Divider(indent: 12, color: Color(0xFFE0E0E0))),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(
    String title,
    bool value,
    ValueChanged<bool> onChanged, {
    bool enabled = true,
    bool isCritical = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: value ? Colors.red.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? Colors.red.shade200 : Colors.grey.shade200,
          width: value ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? () => onChanged(!value) : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Custom Checkbox
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: value ? (isCritical ? Colors.red : Colors.orange) : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: value ? (isCritical ? Colors.red : Colors.orange) : Colors.grey.shade400,
                    ),
                  ),
                  child: value 
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: enabled ? Colors.black87 : Colors.grey,
                      fontWeight: value ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (isCritical && value)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
