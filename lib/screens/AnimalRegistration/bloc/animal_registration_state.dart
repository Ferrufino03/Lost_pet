abstract class AnimalRegistrationState {}

class AnimalRegistrationInitial extends AnimalRegistrationState {}

class AnimalRegistrationUpdate extends AnimalRegistrationState {
  String? url;
  AnimalRegistrationUpdate({this.url});
}

class ResetState extends AnimalRegistrationState{}