import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/patient_data.dart';
import '../services/patient_service.dart';

class PatientDataScreen extends StatefulWidget {
  const PatientDataScreen({super.key});

  @override
  State<PatientDataScreen> createState() => _PatientDataScreenState();
}

class _PatientDataScreenState extends State<PatientDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final PatientData _patient = PatientData();
  
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _prontuarioController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  String? _selectedSexo;

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    final existing = await PatientService.loadPatientData();
    if (existing != null) {
      setState(() {
        _patient.id = existing.id; // IMPORTANTE: Manter o ID para atualização
        _patient.nome = existing.nome;
        _patient.prontuario = existing.prontuario;
        _patient.idade = existing.idade;
        _patient.sexo = existing.sexo;
        _patient.peso = existing.peso;
        _patient.altura = existing.altura;
        
        _nomeController.text = existing.nome ?? '';
        _prontuarioController.text = existing.prontuario ?? '';
        _idadeController.text = existing.idade?.toString() ?? '';
        _pesoController.text = existing.peso?.toStringAsFixed(1) ?? '';
        _alturaController.text = existing.altura?.toStringAsFixed(0) ?? '';
        _selectedSexo = existing.sexo;
      });
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _prontuarioController.dispose();
    _idadeController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _patient.nome = _nomeController.text.isEmpty ? null : _nomeController.text;
      _patient.prontuario = _prontuarioController.text.isEmpty ? null : _prontuarioController.text;
      _patient.idade = _idadeController.text.isEmpty ? null : int.tryParse(_idadeController.text);
      _patient.sexo = _selectedSexo;
      _patient.peso = _pesoController.text.isEmpty ? null : double.tryParse(_pesoController.text.replaceAll(',', '.'));
      _patient.altura = _alturaController.text.isEmpty ? null : double.tryParse(_alturaController.text.replaceAll(',', '.'));
    });

    await PatientService.savePatient(_patient);
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  InputDecoration _buildInputDecoration({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.blueGrey, fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF00509D)),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF00509D), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildImcCard() {
    final weight = double.tryParse(_pesoController.text.replaceAll(',', '.'));
    final height = double.tryParse(_alturaController.text.replaceAll(',', '.'));
    
    if (weight == null || height == null || height <= 0) {
      return const SizedBox.shrink();
    }

    final heightMeters = height / 100;
    final imcValue = weight / (heightMeters * heightMeters);

    Color statusColor = Colors.green;
    String statusText = 'Normal';
    if (imcValue < 18.5) {
      statusColor = Colors.orange;
      statusText = 'Abaixo do peso';
    } else if (imcValue >= 25 && imcValue < 30) {
      statusColor = Colors.orange;
      statusText = 'Sobrepeso';
    } else if (imcValue >= 30) {
      statusColor = Colors.red;
      statusText = 'Obesidade';
    }

    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.speed_rounded, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Índice de Massa Corporal (IMC) Estimado',
                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      imcValue.toStringAsFixed(1),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: statusColor),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: AppBar(
        title: const Text(
          'Dados do Paciente',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00509D)),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.assignment_ind_outlined,
                    size: 48,
                    color: Color(0xFF00509D),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Identificação do Paciente',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00509D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Insira os dados clínicos essenciais para prosseguir com o cálculo das escalas neurológicas.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  
                  // Campo Nome
                  TextFormField(
                    controller: _nomeController,
                    decoration: _buildInputDecoration(
                      label: 'Nome Completo',
                      icon: Icons.person_outline,
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo Prontuário
                  TextFormField(
                    controller: _prontuarioController,
                    decoration: _buildInputDecoration(
                      label: 'Número do Prontuário',
                      icon: Icons.badge_outlined,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Linha Idade & Gênero
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _idadeController,
                          decoration: _buildInputDecoration(
                            label: 'Idade (anos)',
                            icon: Icons.calendar_today_outlined,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final age = int.tryParse(value);
                              if (age == null || age < 0 || age > 130) {
                                return 'Idade inválida';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedSexo,
                          isExpanded: true,
                          decoration: _buildInputDecoration(
                            label: 'Gênero',
                            icon: Icons.wc_outlined,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'M', child: Text('Masculino')),
                            DropdownMenuItem(value: 'F', child: Text('Feminino')),
                            DropdownMenuItem(value: 'Outro', child: Text('Outro')),
                          ],
                          onChanged: (value) => setState(() => _selectedSexo = value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Linha Peso & Altura
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _pesoController,
                          decoration: _buildInputDecoration(
                            label: 'Peso (kg)',
                            icon: Icons.monitor_weight_outlined,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final weight = double.tryParse(value.replaceAll(',', '.'));
                              if (weight == null || weight <= 0 || weight > 500) {
                                return 'Peso inválido';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          controller: _alturaController,
                          decoration: _buildInputDecoration(
                            label: 'Altura (cm)',
                            icon: Icons.height_outlined,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final height = double.tryParse(value.replaceAll(',', '.'));
                              if (height == null || height <= 0 || height > 300) {
                                return 'Altura inválida';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  // Exibição do IMC
                  _buildImcCard(),
                  
                  const SizedBox(height: 28),
                  
                  // Botão Salvar
                  SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _saveAndContinue,
                      icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                      label: const Text(
                        'Salvar e Continuar',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00509D),
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: const Color(0xFF00509D).withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
