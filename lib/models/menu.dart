import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu {
  String title;
  FaIconData image;
  Widget widget;
  Color color;
  Menu(this.title, this.image, this.color, this.widget);
}
