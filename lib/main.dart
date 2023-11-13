import 'package:lost_pet/app.dart';
import 'package:lost_pet/firebase_options.dart';
import 'package:lost_pet/screens/AnimalRegistration/bloc/animal_registration_bloc.dart';
import 'package:lost_pet/screens/UpLoadImage/bloc/up_load_image_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'simple_bloc_observer.dart';

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
          ),
          BlocProvider(
            create: (context) => UpLoadImageBloc(),
          ),
        ],
        child:MyApp(FirebaseUserRepo())));
}