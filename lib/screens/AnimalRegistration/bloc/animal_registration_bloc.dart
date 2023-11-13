import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_pet/screens/AnimalRegistration/model/Animal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_pet/screens/AnimalRegistration/bloc/animal_registration_event.dart';
import 'package:lost_pet/screens/AnimalRegistration/bloc/animal_registration_state.dart';

class AnimalRegistrationBloc
    extends Bloc<AnimalRegistrationEvent, AnimalRegistrationState> {
  Animal animal = Animal();
  AnimalRegistrationBloc() : super(AnimalRegistrationInitial()) {
    on<GetImageEvent>(onUpLoadImage);
    on<ResetStateEvent>(onResetState);
    on<InputEvent>(onInputState);
    on<SubmitEvent>(onSubmitState);
  }

  void onUpLoadImage(
      GetImageEvent event, Emitter<AnimalRegistrationState> emit) async {
    animal.imageURL = event.url;
    emit(AnimalRegistrationUpdate(animal: animal));
  }

  void onResetState(
      ResetStateEvent event, Emitter<AnimalRegistrationState> emit) async {
    animal = Animal();
    emit(ResetState(animal: animal));
  }

  void onInputState(
      InputEvent event, Emitter<AnimalRegistrationState> emit) async {
    animal = event.animal ?? Animal();
    emit(AnimalRegistrationUpdate(animal: animal));
  }

  void onSubmitState(
      SubmitEvent event, Emitter<AnimalRegistrationState> emit) async {
    try {
      animal.userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('animals')
          .add(animal.toMap)
          .then((DocumentReference documentRef) {
        emit(RegistrationSuccess());
      });
    } catch (error) {
      emit(RegistrationError());
    }
  }
}
