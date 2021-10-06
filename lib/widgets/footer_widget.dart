import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Made with "),
          Icon(
            FontAwesomeIcons.solidHeart,
            color: Colors.red,
            size: 18.0,
          ),
          Text(" by RedLine Software."),
        ],
      ),
    );
  }
}
