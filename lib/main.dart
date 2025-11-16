import 'package:flutter/material.dart';
import 'charts/pie_chart_widget.dart';
import 'charts/line_chart_widget.dart';
import 'charts/bar_chart_widget.dart';
import 'models/chart_data.dart';
import 'services/export_pdf_service.dart';
import 'services/export_xlsx_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:printing/printing.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html; // Para web download

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gráficos FL Chart',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChartPage(),
    );
  }
}

class ChartPage extends StatelessWidget {
  final List<ChartItem> data = [
    ChartItem("Jan", 50),
    ChartItem("Fev", 80),
    ChartItem("Mar", 30),
  ];

  ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gráficos")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 300, child: PieChartWidget(data: data)),
            const SizedBox(height: 20),
            SizedBox(height: 300, child: BarChartWidget(data: data)),
            const SizedBox(height: 20),
            SizedBox(height: 300, child: LineChartWidget(data: data)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => exportXlsx(), child: Text("Exportar XLSX")),
                ElevatedButton(
                    onPressed: () => exportPdf(), child: Text("Exportar PDF")),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> exportXlsx() async {
    final file = await ExportXlsxService.export(data, "relatorio");

    if (kIsWeb) {
      // Web: download automático, file é null
      print("Arquivo XLSX baixado no navegador (Web).");
    } else if (file != null) {
      // Mobile/Desktop: abrir ou salvar localmente
      print("Arquivo XLSX salvo em: ${file.path}");
    }
  }

  Future<void> exportPdf() async {
    final file = await ExportPdfService.export(data, "relatorio");

    if (kIsWeb) {
      // Web: download automático, file é null
      print("PDF baixado no navegador (Web).");
    } else if (file != null) {
      // Mobile/Desktop: abrir PDF com Printing
      final bytes = await file.readAsBytes();
      await Printing.layoutPdf(onLayout: (_) => bytes);
      print("PDF salvo em: ${file.path}");
    }
  }
}
