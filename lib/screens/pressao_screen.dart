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
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card com informações do paciente
          if (widget.pesoPaciente != null || widget.teveTrombolise)
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
                    if (widget.pesoPaciente != null)
                      Text('Peso: ${widget.pesoPaciente!.toStringAsFixed(1)} kg'),
                    if (widget.teveTrombolise)
                      const Text(
                        'Trombólise: Realizada',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      const Text(
                        'Trombólise: Não realizada',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
          
          // Card para inserir pressão arterial
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pressão Arterial',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _pasController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'PAS (mmHg)',
                            border: OutlineInputBorder(),
                            hintText: 'Ex: 180',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        '/',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _padController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'PAD (mmHg)',
                            border: OutlineInputBorder(),
                            hintText: 'Ex: 110',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _calcularConduta,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calcular Conduta'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Exibir classificação se houver valores
          if (_pressaoData.pas != null && _pressaoData.pad != null)
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Classificação',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _pressaoData.classificacaoPressao ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Card de conduta
          if (_pressaoData.pas != null && _pressaoData.pad != null)
            Card(
              color: _getCondutaColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.medical_information,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _pressaoData.conduta,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 20),
          
          // Botão para prosseguir para prescrição de nitroprussiato
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
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Prosseguir para Prescrição de Nitroprussiato'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          
          if (_pressaoData.pas != null && _pressaoData.pad != null && widget.pesoPaciente != null)
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

