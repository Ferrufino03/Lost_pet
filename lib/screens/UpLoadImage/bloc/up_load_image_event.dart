import 'dart:io';

abstract class UpLoadImageEvent {}

class LoadingImageEvent extends UpLoadImageEvent {
  double percentage;
  LoadingImageEvent({required this.percentage});
}

class UpLoadToFirebase extends UpLoadImageEvent {
  File image;
  UpLoadToFirebase(this.image);
}

class ResetUpLoadImageEvent extends UpLoadImageEvent {}
