import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:phr/const.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Wrap(
        children: mainMenu.map((item) {
          // Todo: add menu icon
          return GestureDetector(
            child: SizedBox(
              width: (constraints.maxWidth / 3),
              height: (constraints.maxWidth / 3),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: (constraints.maxWidth / 3) * 0.6,
                      height: (constraints.maxWidth / 3) * 0.6,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 4.0),
                    Text(item.title)
                  ],
                ),
              ),
            ),
            onTap: () {
              // Todo : add navigation here
            },
          );
        }).toList(),
      );
    });
  }
}
