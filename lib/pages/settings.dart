import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phr/controllers/appcontroller.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AppController appController = Get.find<AppController>();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Todo : load user profile from box
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 140),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    Positioned(
                      right: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Todo: open image picker for choose image from gallery
                            }),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'Your Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () {
                    // Todo: save user profile and goto homepage
                    // save settings and goto homepage
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
