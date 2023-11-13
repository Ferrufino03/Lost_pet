import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}
 
class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  File? _image;
 
  @override
  void initState() {
    super.initState();
    // Obtener el usuario actualmente autenticado
    User? user = FirebaseAuth.instance.currentUser;
 
    // Obtener los datos del usuario desde Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _nombreController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _direccionController.text = data['direccion'] ?? '';
          _telefonoController.text = data['telefono'] ?? '';
        });
      }
    });
  }
 
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }
 
  Future<String> _uploadImage() async {
    if (_image == null) return '';
 
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profile_images/${_image!.path}');
    UploadTask uploadTask = storageReference.putFile(_image!);
    await uploadTask.whenComplete(() => null);
    return await storageReference.getDownloadURL();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child:
                      _image == null ? Icon(Icons.camera_alt, size: 50) : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección de Domicilio',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _telefonoController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  // Obtener el ID del usuario actualmente autenticado
                  User? user = FirebaseAuth.instance.currentUser;
 
                  // Subir la imagen de perfil a Firebase Storage y obtener la URL
                  String imageUrl = await _uploadImage();
 
                  try {
                    // Actualizar los datos del usuario en Firestore incluyendo la URL de la imagen de perfil
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .update({
                      'name': _nombreController.text,
                      'email': _emailController.text,
                      'direccion': _direccionController.text,
                      'telefono': _telefonoController.text,
                      'imagenPerfil':
                          imageUrl, // Campo para la URL de la imagen de perfil
                    });
 
                    // Mostrar un mensaje de éxito si la actualización fue exitosa
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cambios guardados correctamente.'),
                      ),
                    );
                  } catch (error) {
                    // Mostrar un mensaje de error si la actualización falla
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Error al guardar los cambios. Por favor, inténtalo de nuevo.'),
                      ),
                    );
                  }
                },
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
