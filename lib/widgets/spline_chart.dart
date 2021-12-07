import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phr/const.dart';
import 'package:phr/models/chartdata.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SplineChartWidget extends StatelessWidget {
  const SplineChartWidget({Key? key, required this.chartData, required this.legend}) : super(key: key);

  final List<List<ChartData>> chartData;
  final bool legend;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      //palette: listChartColor,
      // legend: Legend(
      //   isVisible: false,
      //   toggleSeriesVisibility: true,
      // ),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.auto,
        //ateFormat: DateFormat('E d MMM y, HH:mm'),
        dateFormat: DateFormat('d MMM'),
        autoScrollingDeltaType: DateTimeIntervalType.months,
      ),
      primaryYAxis: NumericAxis(
        autoScrollingMode: AutoScrollingMode.start,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: false,
      ),
      series: <ChartSeries>[
        for (int series = 0; series < chartData.length; series++)
          LineSeries<ChartData, DateTime>(
            name: chartData[series].first.name,
            dataSource: chartData[series],
            xValueMapper: (ChartData data, _) => data.dateTime,
            yValueMapper: (ChartData data, _) => data.value,
            color: listChartColor[series],
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
