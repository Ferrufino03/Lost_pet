import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailedAnimalScreen extends StatelessWidget {
  final String documentId; // Añadido para identificar el documento a eliminar.
  final String imageUrl;
  final String animalType;
  final String additionalInfo;
  final String ubicacionDePerdida;
  final String recompensa;
  final String numeroDeReferencia;
  final String statusa;

  // Constructor de la clase
  DetailedAnimalScreen({
    required this.documentId, // Añadido para el manejo del documento.
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tipo de animal: $animalType',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Información adicional: $additionalInfo',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ubicación de la pérdida: $ubicacionDePerdida',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Recompensa: $recompensa',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Número de referencia: $numeroDeReferencia',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Estado: $statusa',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _deleteAnimal(context, documentId),
                        child: Text('Eliminar'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            _contactOwner(context, numeroDeReferencia),
                        child: Text('Contactar'),
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
        SnackBar(
          content: Text("No se pudo abrir WhatsApp"),
        ),
      );
    }
  }

  // Asumiendo que tienes una función para eliminar el documento en Firestore.
  void _deleteAnimal(BuildContext context, String documentId) {
    FirebaseFirestore.instance
        .collection('animals')
        .doc(documentId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Animal eliminado correctamente."),
        ),
      );
      Navigator.of(context)
          .pop(); // Regresar a la pantalla anterior tras eliminar.
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al eliminar el animal: $error"),
        ),
      );
    });
  }
}
