import 'package:flutter/material.dart';

class BoxColumnDataWidget extends StatelessWidget {
  const BoxColumnDataWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.subTitle,
  }) : super(key: key);

  final String title;
  final String value;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Text(value),
        Text(subTitle),
      ],
    );
  }
}
