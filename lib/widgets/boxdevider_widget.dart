import 'package:flutter/material.dart';

class BoxDeviderWiget extends StatelessWidget {
  const BoxDeviderWiget(
      {Key? key,
      required this.value1,
      required this.value2,
      required this.valueColor})
      : super(key: key);

  final String value1;
  final String value2;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value1,
          style: TextStyle(
            color: valueColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(
          indent: 16,
          color: valueColor,
          thickness: 2.0,
          endIndent: 16,
        ),
        Text(
          value2,
          style: TextStyle(
            color: valueColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
