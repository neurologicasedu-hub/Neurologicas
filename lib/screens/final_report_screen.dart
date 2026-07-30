import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/patient_data.dart';
import '../models/completed_score.dart';
import '../services/patient_service.dart';
import '../services/pdf_service.dart';

class FinalReportScreen extends StatefulWidget {
  const FinalReportScreen({super.key});

  @override
  State<FinalReportScreen> createState() => _FinalReportScreenState();
}

class _FinalReportScreenState extends State<FinalReportScreen> {
  PatientData? _patient;
  List<CompletedScore> _scores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _patient = await PatientService.loadPatientData();
    _scores = await PatientService.getCompletedScores();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFECEFF1),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Element
           Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF00A896).withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00A896).withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPatientSection(),
                        const SizedBox(height: 24),
                        _buildScoresHeader(),
                        const SizedBox(height: 12),
                        _buildScoresList(),
                        const SizedBox(height: 20),
                        _buildClearDataButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportPDF,
        backgroundColor: const Color(0xFF00509D),
        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
        label: const Text('Exportar PDF', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF00509D)),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const Text(
            'Relatório Final',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00509D),
            ),
          ),
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh, color: Color(0xFF00509D)),
             style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientSection() {
    if (_patient == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.person_off_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Nenhum paciente selecionado',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/patient'),
              child: const Text('Selecionar Paciente'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF00A896).withOpacity(0.1),
                child: const Icon(Icons.person, size: 30, color: Color(0xFF00A896)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _patient!.nome ?? 'Nome não informado',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00509D),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Prontuário: ${_patient!.prontuario ?? "N/A"}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildInfoItem(Icons.calendar_today_outlined, 'Idade', '${_patient!.idade ?? "-"} anos'),
              _buildInfoItem(Icons.accessibility_new, 'Sexo', _patient!.sexo ?? "-"),
              _buildInfoItem(Icons.monitor_weight_outlined, 'Peso', _patient!.peso != null ? '${_patient!.peso!.toStringAsFixed(1)} kg' : "-"),
              _buildInfoItem(Icons.height, 'Altura', _patient!.altura != null ? '${_patient!.altura!.toStringAsFixed(0)} cm' : "-"),
            ],
          ),
          if (_patient!.diagnosticoPrincipal != null && _patient!.diagnosticoPrincipal!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF00509D).withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00509D).withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.medical_services_outlined, size: 18, color: Color(0xFF00509D)),
                      const SizedBox(width: 8),
                      Text(
                        'Diagnóstico Principal',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _patient!.diagnosticoPrincipal!,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF00509D), fontWeight: FontWeight.w500),
                    softWrap: true, // Allow wrapping
                  ),
                ],
              ),
            ),
          ],
           if (_patient!.alergias != null && _patient!.alergias!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withOpacity(0.1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 20, color: Colors.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alergias',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red[800]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _patient!.alergias!,
                          style: TextStyle(fontSize: 14, color: Colors.red[700]),
                          softWrap: true, // Allow wrapping
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return SizedBox(
      width: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[400]),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF263238)),
          ),
        ],
      ),
    );
  }

  Widget _buildScoresHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF00A896).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.analytics_outlined, color: Color(0xFF00A896), size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Avaliações',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00509D),
              ),
            ),
          ],
        ),
        if (_scores.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00509D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_scores.length}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildScoresList() {
    if (_scores.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.2), style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.note_add_outlined, size: 40, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'Nenhuma avaliação registrada',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _scores.length,
      itemBuilder: (context, index) {
        final score = _scores[index];
        return Dismissible(
          key: Key(score.dataHora.toString()),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await _confirmDeleteScore(score);
          },
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.delete_outline, color: Colors.red[700]),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          score.scoreName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263238),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (score.totalScore != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getScoreColor(score.totalScore!).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${score.totalScore} pts',
                              style: TextStyle(
                                color: _getScoreColor(score.totalScore!),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (score.resultado != null)
                    Text(
                      score.resultado!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDateTime(score.dataHora),
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                      // Visual indicator bar
                      Container(
                        width: 80,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _getScorePercentage(score),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getScoreColor(score.totalScore ?? 0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildClearDataButton() {
    if (_patient == null && _scores.isEmpty) return const SizedBox.shrink();
    
    return Center(
      child: TextButton.icon(
        onPressed: _clearAllData,
        icon: const Icon(Icons.delete_sweep_outlined, size: 18),
        label: const Text('Limpar Dados da Sessão'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey[400],
          textStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 20) return Colors.red;
    if (score >= 15) return Colors.deepOrange;
    if (score >= 10) return Colors.orange;
    if (score >= 5) return Colors.amber;
    return Colors.green;
  }
  
  double _getScorePercentage(CompletedScore score) {
    // Basic heuristic: assume max score approx 30 for visualization if unknown
    // Ideally pass maxScore in CompletedScore model
    double max = 30; 
    double current = (score.totalScore ?? 0).toDouble();
    if (current > max) current = max;
    return current / max;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')} '
           'às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _exportPDF() async {
    if (_patient == null && _scores.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há dados para gerar o PDF'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await PdfService.generateAndSharePDF(
        patient: _patient,
        scores: _scores,
        context: context,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao exportar PDF: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<bool> _confirmDeleteScore(CompletedScore score) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Escala'),
        content: Text('Deseja remover "${score.scoreName}" do relatório?'),
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

    if (confirm == true) {
      await PatientService.deleteCompletedScore(score);
      await _loadData();
      return true;
    }
    return false;
  }

  Future<void> _clearAllData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Sessão'),
        content: const Text('Isso removerá os dados da visualização atual, mas não do banco de dados.\nDeseja continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Limpar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await PatientService.clearPatientData();
      await PatientService.clearCompletedScores();
      if (mounted) {
        setState(() {
          _patient = null;
          _scores = [];
        });
      }
    }
  }
}
