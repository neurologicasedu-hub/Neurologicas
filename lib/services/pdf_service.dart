import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/patient_data.dart';
import '../models/completed_score.dart';

class PdfService {
  // Gerar e compartilhar PDF
  static Future<void> generateAndSharePDF({
    required PatientData? patient,
    required List<CompletedScore> scores,
    required BuildContext context,
  }) async {
    if (patient == null && scores.isEmpty) {
      return;
    }

    try {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Gerando PDF...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Gerar PDF
      final pdf = await _buildPDF(patient, scores);
      
      // Salvar temporariamente
      final file = await _savePDFToFile(pdf);
      
      if (context.mounted) {
        Navigator.pop(context); // Fechar loading
        
        if (file != null) {
          // Compartilhar PDF
          await Share.shareXFiles(
            [XFile(file.path)],
            subject: 'Relatório de Avaliação Neurológica',
            text: 'Relatório de avaliação neurológica do paciente',
          );
        } else {
          // Fallback: usar printing para visualizar
          await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => pdf,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Fechar loading se ainda estiver aberto
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar PDF: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Gerar PDF e abrir visualização
  static Future<void> generateAndPreviewPDF({
    required PatientData? patient,
    required List<CompletedScore> scores,
  }) async {
    try {
      final pdf = await _buildPDF(patient, scores);
      
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf,
      );
    } catch (e) {
      print('Erro ao gerar PDF: $e');
      rethrow;
    }
  }

  // Construir PDF
  static Future<Uint8List> _buildPDF(
    PatientData? patient,
    List<CompletedScore> scores,
  ) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateStr = _formatDateTime(now);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            _buildHeader(dateStr),
            pw.SizedBox(height: 20),
            if (patient != null) ..._buildPatientSection(patient),
            pw.SizedBox(height: 20),
            if (scores.isNotEmpty) ..._buildScoresSection(scores),
            if (scores.isEmpty) _buildEmptyScores(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // Salvar PDF em arquivo
  static Future<File?> _savePDFToFile(Uint8List pdfBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'Relatorio_${_formatFileName(DateTime.now())}.pdf';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      return file;
    } catch (e) {
      print('Erro ao salvar PDF: $e');
      return null;
    }
  }

  // Cabeçalho
  static pw.Widget _buildHeader(String dateTime) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Relatório de Avaliação Neurológica',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Calculadora Neurológica',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
          pw.Text(
            dateTime,
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Seção do Paciente
  static List<pw.Widget> _buildPatientSection(PatientData patient) {
    return [
      pw.Container(
        padding: const pw.EdgeInsets.all(15),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: pw.BorderRadius.circular(5),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'DADOS DO PACIENTE',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Nome', patient.nome ?? 'Não informado'),
                      _buildInfoRow('Prontuário', patient.prontuario ?? 'Não informado'),
                      _buildInfoRow('Idade', patient.idade != null ? '${patient.idade} anos' : 'Não informado'),
                      _buildInfoRow('Sexo', patient.sexo ?? 'Não informado'),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Peso', patient.peso != null ? '${patient.peso!.toStringAsFixed(1)} kg' : 'Não informado'),
                      _buildInfoRow('Altura', patient.altura != null ? '${patient.altura!.toStringAsFixed(0)} cm' : 'Não informado'),
                      _buildInfoRow('IMC', patient.imcFormatado ?? 'Não informado'),
                    ],
                  ),
                ),
              ],
            ),
            if (patient.diagnosticoPrincipal != null) ...[
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _buildInfoRow('Diagnóstico Principal', patient.diagnosticoPrincipal!),
            ],
            if (patient.alergias != null) ...[
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.red50,
                  borderRadius: pw.BorderRadius.circular(3),
                ),
                child: pw.Row(
                  children: [
                    pw.Text(
                      '⚠ ALERGIAS: ',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.red700,
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        patient.alergias!,
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.red700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ];
  }

  // Linha de informação
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  // Seção de Escalas
  static List<pw.Widget> _buildScoresSection(List<CompletedScore> scores) {
    return [
      pw.Text(
        'ESCALAS APLICADAS',
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue800,
        ),
      ),
      pw.SizedBox(height: 10),
      ...scores.asMap().entries.map((entry) {
        final index = entry.key;
        final score = entry.value;
        return _buildScoreCard(score, index + 1);
      }).toList(),
    ];
  }

  // Card de Escala
  static pw.Widget _buildScoreCard(CompletedScore score, int index) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 30,
                height: 30,
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue100,
                  borderRadius: pw.BorderRadius.circular(15),
                ),
                child: pw.Center(
                  child: pw.Text(
                    index.toString(),
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue700,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      score.scoreName,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      'Data: ${_formatDateTime(score.dataHora)}',
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              if (score.totalScore != null)
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue100,
                    borderRadius: pw.BorderRadius.circular(10),
                    border: pw.Border.all(color: PdfColors.blue700, width: 1),
                  ),
                  child: pw.Text(
                    '${score.totalScore}',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue700,
                    ),
                  ),
                ),
            ],
          ),
          if (score.resultado != null) ...[
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(3),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Text(
                score.resultado!,
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Mensagem vazia
  static pw.Widget _buildEmptyScores() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Center(
        child: pw.Text(
          'Nenhuma escala preenchida ainda',
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey600,
            fontStyle: pw.FontStyle.italic,
          ),
        ),
      ),
    );
  }

  // Formatar data e hora
  static String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  // Formatar nome de arquivo
  static String _formatFileName(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '${year}${month}${day}_${hour}${minute}${second}';
  }
}

