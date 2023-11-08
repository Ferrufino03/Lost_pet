import 'package:firebase_crud/screens/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_crud/services/up_load_image.dart';
import 'package:image_picker/image_picker.dart';

class AnimalRegistrationScreen extends StatefulWidget {
  @override
  _AnimalRegistrationScreenState createState() =>
      _AnimalRegistrationScreenState();
}

class _AnimalRegistrationScreenState extends State<AnimalRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _imageUrl = '';
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: _decor('URL de Imagen'),
                keyboardType: TextInputType.url,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese una URL' : null,
                onSaved: (value) => _imageUrl = value!,
              ),
              const SizedBox(
                width: 15,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _decor('Tipo de Animal'),
                validator: (value) => value!.isEmpty
                    ? 'Por favor ingrese el tipo de animal'
                    : null,
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
                    validator: (value) => value!.isEmpty
                        ? 'Por favor ingrese una recompensa'
                        : null,
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
                child: const Text('Registrar'),
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Color del botón
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UpLoadImage()));
        },
        child: const Icon(Icons.filter),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.collection('animals').add({
        'imageURL': _imageUrl,
        'animaltype': _animalType,
        'informacion': _additionalInfo,
        'infoubicacion': _ubicacionDePerdida,
        'recompensa': _recompensa,
        'numref': _numeroDeReferencia,
        'status': 'Perdido',
      });
      Navigator.pop(context);
    }
  }
}
