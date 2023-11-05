import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailedAnimalScreen extends StatelessWidget {

  final String imageUrl;
  final String animalType;
  final String additionalInfo;
  final String ubicacionDePerdida;
  final String recompensa;
  final String numeroDeReferencia;
  final String statusa;


  DetailedAnimalScreen({
  
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
    return Scaffold(
      appBar: AppBar(title: Text(animalType)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tipo de animal: $animalType',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Información adicional: $additionalInfo',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ubicación de la pérdida: $ubicacionDePerdida',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Recompensa: $recompensa',
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Número de referencia: $numeroDeReferencia',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Estado: $statusa',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _deleteAnimalByReferenceNumber(
                            context, numeroDeReferencia),
                        child: const Text('Eliminar'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            _contactOwner(context, numeroDeReferencia),
                        child: const Text('Contactar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _contactOwner(
      BuildContext context, String numeroDeReferencia) async {
    final Uri _url = Uri.parse(
        "https://wa.me/$numeroDeReferencia?text=Hola!%20He%20encontrado%20tu%20animal.");

    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No se pudo abrir WhatsApp"),
        ),
      );
    }
  }

  // Asumiendo que tienes una función para eliminar el documento en Firestore.
  Future<void> _deleteAnimalByReferenceNumber(
      BuildContext context, String referenceNumber) async {
    try {

      var collection = FirebaseFirestore.instance.collection('animals');
      var querySnapshot =
          await collection.where('numref', isEqualTo: referenceNumber).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Animal eliminado correctamente."),
        ),
      );
      Navigator.of(context).pop(); // Volver a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al eliminar el animal: $e"),
        ),
      );
    }
  }
}
