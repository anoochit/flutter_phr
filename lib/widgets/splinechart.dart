import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phr/const.dart';
import 'package:phr/models/chartdata.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SplineChartWidget extends StatelessWidget {
  const SplineChartWidget({Key? key, required this.chartData}) : super(key: key);

  final List<List<ChartData>> chartData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.auto,
        //ateFormat: DateFormat('E d MMM y, HH:mm'),
        dateFormat: DateFormat('d MMM y, HH:mm'),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
      ),
      series: <ChartSeries>[
        for (int series = 0; series < chartData.length; series++)
          SplineSeries<ChartData, DateTime>(
            dataSource: chartData[series],
            xValueMapper: (ChartData data, _) => data.dateTime,
            yValueMapper: (ChartData data, _) => data.value,
            color: chartColor[series],
            enableTooltip: true,
            markerSettings: const MarkerSettings(
              isVisible: true,
              height: 4,
              width: 4,
            ),
          ),
      ],
      // series: <ChartSeries>[

      // ],
    );
  }
}
