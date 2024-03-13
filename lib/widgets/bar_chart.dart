import 'package:flutter/material.dart';
import 'package:phr/models/chartdata.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key, required this.chartData});

  final List<List<ChartDataType>> chartData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(),
      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: false,
      ),
      series: <CartesianSeries>[
        for (int series = 0; series < chartData.length; series++)
          ColumnSeries<ChartDataType, String>(
            dataSource: chartData[series],
            xValueMapper: (ChartDataType data, _) => data.name,
            yValueMapper: (ChartDataType data, _) => data.value,
            pointColorMapper: (ChartDataType data, _) => data.color,
            enableTooltip: true,
            markerSettings: const MarkerSettings(
              isVisible: false,
              height: 4,
              width: 4,
            ),
          ),
      ],
    );
  }
}
