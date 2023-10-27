import 'package:flutter/material.dart';

class LostAnimalCard extends StatelessWidget {
  final String imageUrl; // URL de la imagen del animal
  final String animalType; // Tipo de animal (ejemplo: Perro, Gato, etc.)
  final String additionalInfo; // Información adicional sobre el animal
  final String ubicacionDePerdida; // Ubicación donde se perdió el animal
  final String recompensa; // Recompensa ofrecida
  final String numeroDeReferencia; // Número de contacto o referencia
  final String statusa; // Estado del animal (perdido/encontrado)

  LostAnimalCard({
    required this.imageUrl,
    required this.animalType,
    required this.additionalInfo,
    required this.ubicacionDePerdida,
    required this.recompensa,
    required this.numeroDeReferencia,
    required this.statusa,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Image.network(imageUrl), // Muestra la imagen del animal
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  animalType,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(additionalInfo),
                SizedBox(height: 10.0),
                Text("Ubicación de pérdida: $ubicacionDePerdida"),
                SizedBox(height: 10.0),
                Text("Recompensa: $recompensa"),
                SizedBox(height: 10.0),
                Text("Número de referencia: $numeroDeReferencia"),
                SizedBox(height: 10.0),
                Text(statusa),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
