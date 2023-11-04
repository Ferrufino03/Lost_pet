import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Animal Perdido')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: _decor('URL de Imagen'),
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese una URL' : null,
                onSaved: (value) => _imageUrl = value!,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: _decor('Tipo de Animal'),
                validator: (value) => value!.isEmpty
                    ? 'Por favor ingrese el tipo de animal'
                    : null,
                onSaved: (value) => _animalType = value!,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: _decor('Información Adicional'),
                onSaved: (value) => _additionalInfo = value!,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: _decor('Ubicación de Pérdida'),
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese la ubicación' : null,
                onSaved: (value) => _ubicacionDePerdida = value!,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: _decor('Recompensa'),
                onSaved: (value) => _recompensa = value!,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: _decor('Número de Referencia'),
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese un número' : null,
                onSaved: (value) => _numeroDeReferencia = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Registrar'),
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent, // Color del botón
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
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
