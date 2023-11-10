import 'package:flutter/material.dart';

class DeveloperInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de los Desarrolladores'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Desarrolladores:',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), // Aumenté el tamaño del título
            ),
            SizedBox(height: 16),
            Text(
              'Andres Ferrufino',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Correo Electronico'),
            SizedBox(height: 16),
            Text(
              'Luis Padilla',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Correo Electronico'),
            SizedBox(height: 16),
            Text(
              'Kevin Molina',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Correo Electronico'),
            SizedBox(height: 16),
            Text(
              'Freddy Moscoso',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Correo Electronico'),
            SizedBox(height: 16),
            Text(
              'Jose Chambi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Correo Electronico'),
            // Agrega más información sobre los desarrolladores según sea necesario
          ],
        ),
        ),
    );
}
}