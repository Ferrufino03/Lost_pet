abstract class AnimalRegistrationEvent {}

class UpLoadImageEvent extends AnimalRegistrationEvent {
  String url;
  UpLoadImageEvent({required this.url});
}

class ResetStateEvent extends AnimalRegistrationEvent{}