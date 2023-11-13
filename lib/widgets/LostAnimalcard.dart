import 'package:flutter/material.dart';
import '../screens/DetailedAnimalScreen.dart';

class LostAnimalCard extends StatelessWidget {
  final String imageUrl;
  final String animalType;
  final String additionalInfo;
  final String ubicacionDePerdida;
  final String recompensa;
  final String numeroDeReferencia;
  final String statusa;
  final String userId; // Asume que ahora tienes este campo disponible

  LostAnimalCard({
    required this.imageUrl,
    required this.animalType,
    required this.additionalInfo,
    required this.ubicacionDePerdida,
    required this.recompensa,
    required this.numeroDeReferencia,
    required this.statusa,
    required this.userId, // Incluye el userId como un parámetro requerido
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailedAnimalScreen(
              imageUrl: imageUrl,
              animalType: animalType,
              additionalInfo: additionalInfo,
              ubicacionDePerdida: ubicacionDePerdida,
              recompensa: recompensa,
              numeroDeReferencia: numeroDeReferencia,
              statusa: statusa,
              userId: userId, // Pasa el userId a DetailedAnimalScreen
            ),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20.0)),
              child: Image.network(imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    animalType,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Text(additionalInfo),
                  const SizedBox(height: 10.0),
                  Text("Ubicación de pérdida: $ubicacionDePerdida"),
                  const SizedBox(height: 10.0),
                  Text("Recompensa: $recompensa"),
                  const SizedBox(height: 10.0),
                  Text("Número de referencia: $numeroDeReferencia"),
                  const SizedBox(height: 10.0),
                  Text(statusa),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
