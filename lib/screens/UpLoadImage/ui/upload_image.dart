import 'dart:io';

import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_bloc.dart';
import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_event.dart';
import 'package:firebase_crud/screens/UpLoadImage/bloc/up_load_image_bloc.dart';
import 'package:firebase_crud/screens/UpLoadImage/bloc/up_load_image_event.dart';
import 'package:firebase_crud/screens/UpLoadImage/bloc/up_load_image_state.dart';
import 'package:firebase_crud/services/load_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void popScreen() {
    BlocProvider.of<UpLoadImageBloc>(context).add(ResetUpLoadImageEvent());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back, color:Theme.of(context).colorScheme.onSecondary),
        onPressed: () => Navigator.of(context).pop(),
        ),
          title: Text("Cargar Imagen",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
          ),)),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<UpLoadImageBloc, UpLoadImageState>(
            builder: (context, state) {
              if (state is LoadingUpdate) {
                return Main(state.percentage);
              } else if (state is UpLoadImageSuccess) {
                BlocProvider.of<AnimalRegistrationBloc>(context)
                    .add(GetImageEvent(url: state.url));
                popScreen();
              }
              return Main(0);
            },
          ),
        ));
  }

  Widget Main(double percentage) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        child: resource != null
            ? Column(
                children: [
                  Image.file(resource!),
                  LinearProgressIndicator(
                    value: percentage,
                    semanticsValue: "Subiendo Imagen",
                  )
                ],
              )
            : const Text("Upload Image"),
      ),
      const SizedBox(
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
              icon: const Icon(Icons.camera_alt)),
        ],
      ),
      IconButton(
          onPressed: () {
            if (resource != null) {
              BlocProvider.of<UpLoadImageBloc>(context)
                  .add(UpLoadToFirebase(resource!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Subiendo Imagen."),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Ingrese una imagen por favor"),
                ),
              );
            }
          },
          icon: const Icon(Icons.file_upload_outlined))
    ]);
  }
}
