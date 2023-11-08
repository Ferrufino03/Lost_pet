import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

final storageRef = FirebaseStorage.instance.ref();

Future<String> upLoadfirebase(File image) async {
  // Create a reference to 'file'
  String nameFile = image.path.toString().split("/").last;
  final fileRef = storageRef.child("images/$nameFile");
  try {
    UploadTask uploadTask = fileRef.putFile(
        image,
        SettableMetadata(
          contentType: "image/${nameFile.split(".").last}",
        ));
    await uploadTask
        .whenComplete(() => null); // Espera a que se complete la carga
    return await fileRef.getDownloadURL();
  } on FirebaseException catch (e) {
    // Caught an exception from Firebase.
    print("Failed with error '${e.code}': ${e.message}");
    return "";
  }
}
