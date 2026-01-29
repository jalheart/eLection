import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../application/providers/results_provider.dart';
import '../../domain/entities/settings.dart';

class PDFReportService {
  Future<Uint8List> generateResultsPDF({
    required List<ResultData> results,
    required Settings? settings,
    required String mesa,
    required String sede,
    String? logoPath,
  }) async {
    final pdf = pw.Document();

    pw.MemoryImage? logoImage;
    if (logoPath != null && File(logoPath).existsSync()) {
      final logoBytes = File(logoPath).readAsBytesSync();
      logoImage = pw.MemoryImage(logoBytes);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      settings?.name ?? 'eLection - Reporte de Resultados',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(settings?.slogan ?? ''),
                    pw.SizedBox(height: 8),
                    pw.Text('Reporte de Escrutinio', style: const pw.TextStyle(fontSize: 14)),
                  ],
                ),
                if (logoImage != null)
                  pw.Container(
                    width: 60,
                    height: 60,
                    child: pw.Image(logoImage),
                  ),
              ],
            ),
            pw.Divider(thickness: 1.5, height: 24),

            // Election Info
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Sede: $sede', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Mesa: $mesa', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Fecha: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                    pw.Text('Hora: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}'),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 24),

            // Results by Category
            ...results.map((result) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    width: double.infinity,
                    child: pw.Text(
                      result.category.name.toUpperCase(),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey400),
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text('Candidato', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text('Votos', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                      ...result.candidates.map((c) {
                        return pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(c.candidate.name),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(c.votes.toString(), textAlign: pw.TextAlign.center),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  pw.SizedBox(height: 16),
                ],
              );
            }).toList(),

            // Footer / Signatures
            pw.SizedBox(height: 48),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Column(
                  children: [
                    pw.Container(
                      width: 150,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(top: pw.BorderSide()),
                      ),
                    ),
                    pw.Text('Jurado 1'),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Container(
                      width: 150,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(top: pw.BorderSide()),
                      ),
                    ),
                    pw.Text('Jurado 2'),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  Future<void> saveAndOpenFile(Uint8List bytes, String fileName) async {
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
  }
}
