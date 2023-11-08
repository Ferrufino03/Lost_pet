import 'dart:io';

import 'package:firebase_crud/screens/UpLoadImage/bloc/up_load_image_event.dart';
import 'package:firebase_crud/screens/UpLoadImage/bloc/up_load_image_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpLoadImageBloc extends Bloc<UpLoadImageEvent, UpLoadImageState> {
  UpLoadImageBloc() : super(UpLoadImageInitial()) {
    on<LoadingImageEvent>(onLoadingImageEvent);
    on<UpLoadToFirebase>(onUpLoadToFirebase);
    on<ResetUpLoadImageEvent>(onResetUpLoadImage);
  }

  void onLoadingImageEvent(
      LoadingImageEvent event, Emitter<UpLoadImageState> emit) async {
    emit(LoadingUpdate(percentage: event.percentage));
  }

  void onResetUpLoadImage(
      ResetUpLoadImageEvent event, Emitter<UpLoadImageState> emit) async {
        emit(ResetUpLoadImage());
      }

  void onUpLoadToFirebase(
      UpLoadToFirebase event, Emitter<UpLoadImageState> emit) async {
    File image = event.image;
    final storageRef = FirebaseStorage.instance.ref();
    String fileName = image.path.split('/').last;
    final fileRef = storageRef.child("images/$fileName");
    try {
      String downloadUrl = '';
      final metadata =
          SettableMetadata(contentType: "image/${fileName.split('.').last}");
      final uploadTask = fileRef.putFile(image, metadata);
      uploadTask.snapshotEvents.listen((snapshot) {
        double progress =
            100 * (snapshot.bytesTransferred / snapshot.totalBytes);
        emit(LoadingUpdate(percentage: progress));
      });
      await uploadTask.whenComplete(() async {
        downloadUrl = await fileRef.getDownloadURL();
      });
      emit(UpLoadImageSuccess(downloadUrl));
    } catch (error) {
      emit(UpLoadImageError());
    }
  }
}
