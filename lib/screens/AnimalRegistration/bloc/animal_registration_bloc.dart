import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/screens/AnimalRegistration/model/Animal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_event.dart';
import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_state.dart';

class AnimalRegistrationBloc
    extends Bloc<AnimalRegistrationEvent, AnimalRegistrationState> {
  // ignore: unnecessary_new
  Animal animal = new Animal();
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
        // ignore: unnecessary_new
        animal=new Animal();
    emit(ResetState(animal: animal));
  }

  void onInputState(
      InputEvent event, Emitter<AnimalRegistrationState> emit) async {
    animal.imageURL = event.animal!.imageURL;
    animal.animaltype = event.animal!.animaltype;
    animal.informacion = event.animal!.informacion;
    animal.infoubicacion = event.animal!.infoubicacion;
    animal.recompensa = event.animal!.recompensa;
    animal.numref = event.animal!.numref;
    emit(AnimalRegistrationUpdate(animal: animal));
  }

  void onSubmitState(
      SubmitEvent event, Emitter<AnimalRegistrationState> emit) async {
    await FirebaseFirestore.instance
        .collection('animals')
        .add(animal.toMap)
        .then((DocumentReference documentRef) {
      emit(RegistrationSuccess());
    }).catchError((error) {
      emit(RegistrationError());
    });
  }
}
