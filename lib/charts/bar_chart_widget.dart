import 'package:flutter/material.dart';
import '../models/chart_data.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  final List<ChartItem> data;

  BarChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: data
            .asMap()
            .entries
            .map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.value,
                      color: Colors.blue,
                    )
                  ],
                ))
            .toList(),
      ),
    );
  }
}
