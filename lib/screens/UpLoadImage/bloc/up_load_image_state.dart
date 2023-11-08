abstract class UpLoadImageState {}

class UpLoadImageInitial extends UpLoadImageState {}

class LoadingUpdate extends UpLoadImageState {
  double percentage;
  LoadingUpdate({required this.percentage});
}

class UpLoadImageSuccess extends UpLoadImageState {
  String url;
  UpLoadImageSuccess(this.url);
}

class ResetUpLoadImage extends UpLoadImageInitial {}

class UpLoadImageError extends UpLoadImageState {}
