// @dart=2.17
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Widget to display steps data in a chart
class StepsChart extends StatelessWidget {
  final List<StepsData> chartData;

  const StepsChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SfCartesianChart(
          title: ChartTitle(text: "Total Steps"),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<StepsData, String>>[
            ColumnSeries<StepsData, String>(
              dataSource: chartData,
              xValueMapper: (StepsData steps, _) => steps.key,
              yValueMapper: (StepsData steps, _) => steps.value,
              color: Colors.deepPurple,
              borderColor: Colors.deepPurple,
              borderWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}

// Class to represent steps data
class StepsData {
  final String key; // Timestamp or category
  final double value; // Steps count

  StepsData(this.key, this.value);
}
