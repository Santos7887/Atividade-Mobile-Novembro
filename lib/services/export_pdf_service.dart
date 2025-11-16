import 'dart:io' show File;
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'package:path_provider/path_provider.dart';
import '../models/chart_data.dart';

class ExportPdfService {
  static Future<File?> export(List<ChartItem> data, String fileName) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text("Relatório dos Dados", style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ["Label", "Valor"],
              data: data.map((d) => [d.label, d.value.toString()]).toList(),
            )
          ],
        ),
      ),
    );

    final bytes = await pdf.save();

    if (kIsWeb) {
      // Web: download via AnchorElement
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "$fileName.pdf")
        ..click();
      html.Url.revokeObjectUrl(url);
      return null; // Web não retorna File
    } else {
      // Mobile/Desktop: salva localmente
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/$fileName.pdf");
      await file.writeAsBytes(bytes);
      return file;
    }
  }
}
