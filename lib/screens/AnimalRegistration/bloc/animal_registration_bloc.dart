import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_event.dart';
import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_state.dart';

class AnimalRegistrationBloc
    extends Bloc<AnimalRegistrationEvent, AnimalRegistrationState> {
  AnimalRegistrationBloc() : super(AnimalRegistrationInitial()) {
    on<UpLoadImageEvent>(onUpLoadImage);
  }
  void onUpLoadImage(
      UpLoadImageEvent event, Emitter<AnimalRegistrationState> emit) async {
    print(event.url);
    emit(AnimalRegistrationUpdate(url: event.url));
  }
}
