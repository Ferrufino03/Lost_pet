import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_bloc.dart';
import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_event.dart';
import 'package:firebase_crud/screens/AnimalRegistration/bloc/animal_registration_state.dart';
import 'package:firebase_crud/screens/AnimalRegistration/widgets/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimalRegistrationScreen extends StatefulWidget {
  const AnimalRegistrationScreen({super.key});

  @override
  State<AnimalRegistrationScreen> createState() =>
      _AnimalRegistrationScreenState();
}

class _AnimalRegistrationScreenState extends State<AnimalRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _imageUrl = TextEditingController();
  String _animalType = '';
  String _additionalInfo = '';
  String _ubicacionDePerdida = '';
  String _recompensa = '';
  String _numeroDeReferencia = '';

  InputDecoration _decor(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Animal Perdido')),
      body: Container(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AnimalRegistrationBloc, AnimalRegistrationState>(
              builder: (context, state) {
            if (state is AnimalRegistrationUpdate) {
              _imageUrl.text = state.url ?? "";
              return _form(image: state.url);
            }
            return _form();
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UpLoadImage()));
        },
        child: const Icon(Icons.add_box),
      ),
    );
  }

  Widget _form({String? image}) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: _decor('URL de Imagen'),
            keyboardType: TextInputType.url,
            controller: _imageUrl,
            validator: (value) =>
                value!.isEmpty ? 'Por favor ingrese una URL' : null,
          ),
          const SizedBox(
            width: 15,
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: _decor('Tipo de Animal'),
            validator: (value) =>
                value!.isEmpty ? 'Por favor ingrese el tipo de animal' : null,
            onSaved: (value) => _animalType = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: _decor('Información Adicional'),
            keyboardType: TextInputType.multiline,
            onSaved: (value) => _additionalInfo = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: _decor('Ubicación de Pérdida'),
            validator: (value) =>
                value!.isEmpty ? 'Por favor ingrese la ubicación' : null,
            onSaved: (value) => _ubicacionDePerdida = value!,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                decoration: _decor('Recompensa'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _recompensa = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese una recompensa' : null,
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: TextFormField(
                decoration: _decor('Número de Referencia'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese un número' : null,
                onSaved: (value) => _numeroDeReferencia = value!,
              )),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: Text('Registrar'),
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Color del botón
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.collection('animals').add({
        "imageURL": _imageUrl.text,
        "animaltype": _animalType,
        "informacion": _additionalInfo,
        "infoubicacion": _ubicacionDePerdida,
        "recompensa": _recompensa,
        "numref": _numeroDeReferencia,
        "status": "Perdido"
      });
      BlocProvider.of<AnimalRegistrationBloc>(context)
          .add(UpLoadImageEvent(url: ""));
      Navigator.pop(context);
    }
  }
}
