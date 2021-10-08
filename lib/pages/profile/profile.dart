import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phr/controllers/appcontroller.dart';
import 'package:phr/themes/theme.dart';
import 'package:phr/widgets/footer_widget.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            width: constraints.maxWidth,
            child: Card(
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: FileImage(
                      File('${appController.yourImage}'),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${appController.yourName}',
                    style: textTitleStyleBig,
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.file_download),
                          title: Text("Export CSV"),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(Icons.file_download),
                          title: Text("Export PDF"),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text("About"),
                          onTap: () {
                            showAboutDialog(
                                context: context,
                                applicationName: 'Personal Health Record',
                                applicationVersion: 'Version 1.0',
                                applicationIcon: Image.asset(
                                  'assets/launcher.png',
                                  width: 60,
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
