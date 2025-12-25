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
      // Se veio da lista (para edição ou novo), volta para a lista?
      // Ou vai para o Home (como o botão diz "Salvar e Continuar")?
      // O fluxo original era "Salvar e Continuar para Escalas" -> Home.
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados do Paciente'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Informações do Paciente',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Preencha os dados principais do paciente',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Paciente',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _prontuarioController,
              decoration: const InputDecoration(
                labelText: 'Prontuário',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _idadeController,
                    decoration: const InputDecoration(
                      labelText: 'Idade (anos) *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedSexo,
                    decoration: const InputDecoration(
                      labelText: 'Sexo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _pesoController,
                    decoration: const InputDecoration(
                      labelText: 'Peso (kg) *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monitor_weight),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _alturaController,
                    decoration: const InputDecoration(
                      labelText: 'Altura (cm) *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.height),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            if (_patient.peso != null && _patient.altura != null && _patient.altura! > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'IMC: ${_patient.imcFormatado ?? "N/A"}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveAndContinue,
              icon: const Icon(Icons.save),
              label: const Text('Salvar e Continuar para Escalas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
