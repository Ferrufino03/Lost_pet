import 'package:lost_pet/screens/AnimalRegistration/model/Animal.dart';

abstract class AnimalRegistrationEvent {}

class GetImageEvent extends AnimalRegistrationEvent {
  String url;
  GetImageEvent({required this.url});
}

class InputEvent extends AnimalRegistrationEvent {
  Animal? animal;
  InputEvent({
    this.animal,
  });
}

class SubmitEvent extends AnimalRegistrationEvent {}

class ResetStateEvent extends AnimalRegistrationEvent {}
