import 'package:flutter/material.dart';
import '../models/patient_data.dart';
import '../services/patient_service.dart';
import '../services/auth_service.dart';
import 'final_report_screen.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<PatientData> _patients = [];
  bool _isLoading = true;
  PatientData? _activePatient;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() => _isLoading = true);
    final patients = await PatientService.getPatients();
    final active = await PatientService.loadPatientData();

    setState(() {
      _patients = patients;
      _activePatient = active;
      _isLoading = false;
    });
  }

  Future<void> _selectPatient(PatientData patient) async {
    await PatientService.setActivePatient(patient);
    if (!mounted) return;
    Navigator.pushNamed(context, '/home');
  }

  void _viewReport(PatientData patient) async {
    await PatientService.setActivePatient(patient);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FinalReportScreen()),
    ).then((_) => _loadPatients());
  }

  Future<void> _deletePatient(PatientData patient) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Paciente'),
        content: Text('Tem certeza que deseja excluir ${patient.nome ?? "este paciente"}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await PatientService.deletePatient(patient.id);
      _loadPatients();
    }
  }

  void _addNewPatient() {
    PatientService.clearActivePatient();
    Navigator.pushNamed(context, '/patient').then((_) => _loadPatients());
  }

  void _editPatient(PatientData patient) async {
    await PatientService.setActivePatient(patient);
    if (!mounted) return;
    Navigator.pushNamed(context, '/patient').then((_) => _loadPatients());
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Logout'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await AuthService().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        centerTitle: true,
        backgroundColor: const Color(0xFF00509D), 
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _patients.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Nenhum paciente cadastrado',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _addNewPatient,
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar Paciente'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00509D),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _patients.length,
                  itemBuilder: (context, index) {
                    final patient = _patients[index];
                    final isActive = _activePatient?.id == patient.id;

                    return Card(
                      elevation: isActive ? 4 : 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: isActive 
                            ? const BorderSide(color: Color(0xFF00A896), width: 2) 
                            : BorderSide.none,
                      ),
                      child: InkWell(
                        onTap: () => _selectPatient(patient),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                               Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isActive ? const Color(0xFF00A896).withOpacity(0.2) : Colors.blue.shade100,
                                    radius: 24,
                                    child: Text(
                                      patient.nome?.isNotEmpty == true
                                          ? patient.nome![0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        color: isActive ? const Color(0xFF00A896) : Colors.blue.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  if (isActive)
                                    const Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xFF00A896),
                                        radius: 8,
                                        child: Icon(Icons.check, size: 12, color: Colors.white),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            patient.nome ?? 'Sem Nome',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isActive ? const Color(0xFF00509D) : Colors.black87,
                                            ),
                                          ),
                                        ),
                                        if (isActive)
                                          Container(
                                            margin: const EdgeInsets.only(left: 8),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF00A896),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Text('ATIVO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Idade: ${patient.idade ?? "-"} anos  •  Prontuário: ${patient.prontuario ?? "-"}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) {
                                  if (value == 'report') {
                                    _viewReport(patient);
                                  } else if (value == 'edit') {
                                    _editPatient(patient);
                                  } else if (value == 'delete') {
                                    _deletePatient(patient);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'report',
                                    child: Row(
                                      children: [
                                        Icon(Icons.assignment, size: 20),
                                        SizedBox(width: 8),
                                        Text('Relatório'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 20),
                                        SizedBox(width: 8),
                                        Text('Editar'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red, size: 20),
                                        SizedBox(width: 8),
                                        Text('Excluir', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: _patients.isNotEmpty
          ? FloatingActionButton(
              onPressed: _addNewPatient,
               backgroundColor: const Color(0xFF00A896),
               foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
