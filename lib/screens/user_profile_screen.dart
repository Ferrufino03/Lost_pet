import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        icon: Icon(Icons.arrow_back, color:Theme.of(context).colorScheme.onSecondary),
        onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Perfil del Usuario',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              controller: _telefonoController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: _direccionController,
              decoration: InputDecoration(labelText: 'Dirección'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Obtener los valores de los controladores
                // Aquí puedes guardar los datos del usuario en la base de datos.
                // Por ejemplo, usando FirebaseFirestore.
                // Guarda los valores de nombre, apellido, email, telefono y direccion en la base de datos.

                // Lógica para guardar los datos en la base de datos.
              },
              child: Text('Guardar Cambios',
               style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary
               ),),
            ),
          ],
        ),
      ),
    );
  }
}
