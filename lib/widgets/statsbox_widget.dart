import 'package:flutter/material.dart';
import 'package:phr/widgets/boxcolumndata_widget.dart';

class StatsBoxWidget extends StatelessWidget {
  const StatsBoxWidget({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.subTitle,
  });

  final double width;
  final double height;
  final String title;
  final String value;
  final Color valueColor;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        child: BoxColumnDataWidget(
          title: title,
          value: value,
          subTitle: subTitle,
          valueColor: valueColor,
        ),
      ),
    );
  }
}
