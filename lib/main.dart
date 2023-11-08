//import 'package:firebase_crud/screens/login_screen.dart';
import 'package:firebase_crud/app.dart';
import 'package:firebase_crud/firebase_options.dart';
import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'simple_bloc_observer.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  runApp(MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AnimalRegistrationBloc(),
          )
        ],
        child:MyApp(FirebaseUserRepo())));
}
//MyApp(FirebaseUserRepo())