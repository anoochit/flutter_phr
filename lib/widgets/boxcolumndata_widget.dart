import 'package:flutter/material.dart';

class BoxColumnDataWidget extends StatelessWidget {
  const BoxColumnDataWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.subTitle,
    this.valueColor = Colors.black,
    this.textColor = Colors.black,
  }) : super(key: key);

  final String title;
  final String value;
  final String subTitle;
  final Color valueColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            subTitle,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
