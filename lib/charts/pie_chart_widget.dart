import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/chart_data.dart';

class PieChartWidget extends StatelessWidget {
  final List<ChartItem> data;

  PieChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: data.map((item) {
          return PieChartSectionData(
            value: item.value,
            title: item.label,
            color: Colors.primaries[data.indexOf(item) % Colors.primaries.length],
            radius: 60,
          );
        }).toList(),
      ),
    );
  }
}
