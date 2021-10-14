import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/pages/home/home.dart';
import 'package:phr/themes/theme.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AppController appController = Get.find<AppController>();

  final formKey = GlobalKey<FormState>();

  TextEditingController textNameController = TextEditingController();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: GetBuilder<AppController>(
              init: AppController(),
              builder: (controller) {
                textNameController.text = appController.yourName.toString();
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Setup your profile",
                          style: textTitleStyleBig,
                        ),
                        const SizedBox(height: 24),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.6),
                              backgroundImage: controller.yourImage.isNotEmpty ? FileImage(File('${controller.yourImage}')) : null,
                            ),
                            Positioned(
                              right: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt),
                                  onPressed: () async {
                                    // Open image picker for choose image from gallery
                                    final ImagePicker imagePicker = ImagePicker();
                                    image = await imagePicker.pickImage(source: ImageSource.gallery);
                                    if (image != null) {
                                      log(image!.path.toString());
                                      controller.yourImage = RxString(image!.path);
                                      controller.update();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextFormField(
                              controller: textNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
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
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ElevatedButton(
                            style: buttonStyleGreen,
                            child: const Text("Save"),
                            onPressed: () {
                              if ((formKey.currentState!.validate()) && (appController.yourImage.isNotEmpty)) {
                                log("save -> profile " + image!.path);
                                // Save user profile and goto homepage
                                appController.addProfile(
                                  name: textNameController.text,
                                  photo: image!.path,
                                );
                                Get.off(() => const HomePage());
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
