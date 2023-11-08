import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LostAnimalCard.dart';

class FoundAnimalsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('animals')
          .where('status', isEqualTo: 'Encontrado')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        List<LostAnimalCard> animalCards = [];
        snapshot.data!.docs.forEach((doc) {
          animalCards.add(LostAnimalCard(
            imageUrl: doc['imageURL'],
            animalType: doc['animaltype'],
            additionalInfo: doc['informacion'],
            ubicacionDePerdida: doc['infoubicacion'],
            recompensa: doc['recompensa'],
            numeroDeReferencia: doc['numref'],
            statusa: doc['status'],
          ));
        });

        return ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "ANIMALES ENCONTRADOS",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ...animalCards,
          ],
        );
      },
    );
  }
}
