import 'dart:typed_data';
import 'dart:io' show File;
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import '../models/chart_data.dart';
import 'package:path_provider/path_provider.dart';

class ExportXlsxService {
  static Future<File?> export(List<ChartItem> data, String fileName) async {
    final excel = Excel.createExcel();
    final sheet = excel['Relatorio'];

    // Cabeçalhos
    sheet.appendRow([
      TextCellValue("Label"),
      TextCellValue("Valor"),
    ]);

    // Dados
    for (var item in data) {
      sheet.appendRow([
        TextCellValue(item.label),
        DoubleCellValue(item.value),
      ]);
    }

    final bytes = excel.encode()!;

    if (kIsWeb) {
      // Web: download via AnchorElement
      final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "$fileName.xlsx")
        ..click();
      html.Url.revokeObjectUrl(url);
      return null; // Web não retorna File
    } else {
      // Mobile/Desktop: salva localmente
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/$fileName.xlsx");
      await file.writeAsBytes(bytes);
      return file;
    }
  }
}
