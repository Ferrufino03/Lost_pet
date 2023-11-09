import 'package:firebase_crud/screens/AnimalRegistration/model/Animal.dart';

abstract class AnimalRegistrationState {}

class AnimalRegistrationInitial extends AnimalRegistrationState {}

class AnimalRegistrationUpdate extends AnimalRegistrationState {
  Animal? animal;
  AnimalRegistrationUpdate({this.animal});
}

class ResetState extends AnimalRegistrationState {
  Animal? animal;
  ResetState({this.animal});
}

class RegistrationSuccess extends AnimalRegistrationState {}

class RegistrationError extends AnimalRegistrationState {}
