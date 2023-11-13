import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa FirebaseAuth

class DetailedAnimalScreen extends StatelessWidget {
  final String imageUrl;
  final String animalType;
  final String additionalInfo;
  final String ubicacionDePerdida;
  final String recompensa;
  final String numeroDeReferencia;
  final String statusa;
  final String userId; // ID del usuario que creó el registro

  DetailedAnimalScreen({
    required this.imageUrl,
    required this.animalType,
    required this.additionalInfo,
    required this.ubicacionDePerdida,
    required this.recompensa,
    required this.numeroDeReferencia,
    required this.statusa,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserID =
        FirebaseAuth.instance.currentUser!.uid; // ID del usuario actual

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(animalType,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Tipo de animal: $animalType',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Información adicional: $additionalInfo',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('Ubicación de la pérdida: $ubicacionDePerdida',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('Recompensa: $recompensa',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.green)),
                  const SizedBox(height: 10),
                  Text('Número de referencia: $numeroDeReferencia',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('Estado: $statusa',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (currentUserID == userId)
                        ElevatedButton(
                          onPressed: () => _deleteAnimalByReferenceNumber(
                              context, numeroDeReferencia),
                          child: const Text('Eliminar'),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onSecondary),
                        ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (currentUserID == userId)
                        ElevatedButton(
                          onPressed: () =>
                              _markAnimalAsFound(context, numeroDeReferencia),
                          child: const Text('Encontrado'),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onSecondary),
                        ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            _contactOwner(context, numeroDeReferencia),
                        child: const Text('Contactar'),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.secondary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onSecondary),
                      ),
                    ],
                  )
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
          const SnackBar(content: Text("No se pudo abrir WhatsApp")));
    }
  }

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
          const SnackBar(content: Text("Animal eliminado correctamente.")));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar el animal: $e")));
    }
  }

  Future<void> _markAnimalAsFound(
      BuildContext context, String referenceNumber) async {
    try {
      var collection = FirebaseFirestore.instance.collection('animals');
      var querySnapshot =
          await collection.where('numref', isEqualTo: referenceNumber).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'status': 'Encontrado'});
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Animal marcado como encontrado correctamente.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error al marcar el animal como encontrado: $e")));
    }
  }
}
