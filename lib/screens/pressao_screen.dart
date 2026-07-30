import 'package:flutter/material.dart';
import '../models/pressao_data.dart';
import 'nitroprussiato_screen.dart';

class PressaoScreen extends StatefulWidget {
  final double? pesoPaciente;
  final bool teveTrombolise;
  final int? nihssScore;
  final String? interpretacaoNIHSS;
  final bool elegivelTrombolise;
  final String? doseRtpa;

  const PressaoScreen({
    super.key,
    this.pesoPaciente,
    this.teveTrombolise = false,
    this.nihssScore,
    this.interpretacaoNIHSS,
    this.elegivelTrombolise = false,
    this.doseRtpa,
  });

  @override
  State<PressaoScreen> createState() => _PressaoScreenState();
}

class _PressaoScreenState extends State<PressaoScreen> {
  final TextEditingController _pasController = TextEditingController();
  final TextEditingController _padController = TextEditingController();
  late PressaoData _pressaoData;

  @override
  void initState() {
    super.initState();
    _pressaoData = PressaoData(
      pesoPaciente: widget.pesoPaciente,
      teveTrombolise: widget.teveTrombolise,
    );
  }

  void _calcularConduta() {
    final pas = int.tryParse(_pasController.text);
    final pad = int.tryParse(_padController.text);
    
    if (pas == null || pad == null || pas <= 0 || pad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha valores válidos para PAS e PAD'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _pressaoData.pas = pas;
      _pressaoData.pad = pad;
      // Limpar seleções anteriores
      _pressaoData.paBaixaAntesTrombolise = false;
      _pressaoData.paAltaConsiderarAntihipertensivo = false;
      _pressaoData.paMediaMonitorar = false;
      _pressaoData.paBaixaEvitarHipotensao = false;
      // Auto-detectar condições
      _pressaoData.autoDetectarCondicoes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Pressão - AVC Isquêmico'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Patient Info Card
            if (widget.pesoPaciente != null || widget.teveTrombolise)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: Colors.blue.shade700),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.pesoPaciente != null)
                            Text('Peso: ${widget.pesoPaciente!.toStringAsFixed(1)} kg', 
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                           const SizedBox(height: 4),
                          if (widget.teveTrombolise)
                            const Text('Trombólise: REALIZADA', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13))
                          else
                            const Text('Trombólise: NÃO REALIZADA', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // BP Input Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'AFERIÇÃO DA P.A.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('Sistólica (PAS)', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _pasController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: '000',
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                        child: Text('/', style: TextStyle(fontSize: 24, color: Colors.grey)),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Diastólica (PAD)', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _padController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: '00',
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _calcularConduta,
                      icon: const Icon(Icons.calculate_outlined),
                      label: const Text('CALCULAR CONDUTA'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00509D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Result/Conduct Card
            if (_pressaoData.pas != null && _pressaoData.pad != null)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _getCondutaColor(),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getCondutaColor().withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.assignment_turned_in_outlined, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _pressaoData.classificacaoPressao?.toUpperCase() ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'CONDUTA SUGERIDA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900, // Black/Heavy 
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _pressaoData.conduta,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
            const SizedBox(height: 24),

            // Next Step Button (Nitroprusside)
            if (_pressaoData.pas != null && _pressaoData.pad != null && widget.pesoPaciente != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NitroprussiatoScreen(
                          pesoPaciente: widget.pesoPaciente!,
                          nihssScore: widget.nihssScore,
                          interpretacaoNIHSS: widget.interpretacaoNIHSS,
                          elegivelTrombolise: widget.elegivelTrombolise,
                          doseRtpa: widget.doseRtpa,
                          pas: _pressaoData.pas,
                          pad: _pressaoData.pad,
                          condutaPressao: _pressaoData.conduta,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.medication_liquid),
                  label: const Text('PRESCREVER NITROPRUSSIATO'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

             const SizedBox(height: 24),

            // Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Voltar'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    icon: const Icon(Icons.home),
                    label: const Text('Início'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
              ],
            ),
             const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Color _getCondutaColor() {
    if (_pressaoData.pas == null || _pressaoData.pad == null) {
      return Colors.purple;
    }
    
    if (_pressaoData.pas! > 220 || _pressaoData.pad! > 120) {
      return Colors.red;
    } else if (_pressaoData.pas! >= 185 && _pressaoData.pas! <= 220 && 
               _pressaoData.pad! >= 110 && _pressaoData.pad! <= 120) {
      return Colors.orange;
    } else if (_pressaoData.pas! < 140 && _pressaoData.pad! < 90) {
      return Colors.blue;
    } else if (_pressaoData.pas! < 185 && _pressaoData.pad! < 110) {
      return Colors.green;
    }
    return Colors.purple;
  }

  @override
  void dispose() {
    _pasController.dispose();
    _padController.dispose();
    super.dispose();
  }
}

