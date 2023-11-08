import 'dart:io';

import 'package:firebase_crud/services/up_load_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpLoadImage extends StatefulWidget {
  const UpLoadImage({super.key});
  @override
  State<UpLoadImage> createState() => _UpLoadImage();
}

class _UpLoadImage extends State<UpLoadImage> {
  File? resource;

  Future<void> getImage(ImageSource img) async {
    final XFile? image = await getResource(img);
    setState(() {
      resource = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Cargar Image")),
        body: Column(children: [
          Card(
            child: resource != null
                ? Image.file(resource!)
                : const Text("Upload Image"),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image)),
              const SizedBox(width: 15),
              IconButton(
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera_alt)),
            ],
          )
        ]));
  }
}
