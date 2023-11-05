/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/LostAnimalcard.dart';
import 'AnimalRegistrationScreen.dart'; // Importa la pantalla de registro

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    LostAnimalsSection(),
    //FoundAnimalsSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mascotas')),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnimalRegistrationScreen()),
              );
            },
            child: Text('Registrar Animal Perdido'),
          ),
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Perros perdidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Perros encontrados',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class LostAnimalsSection extends StatelessWidget {
  const LostAnimalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('animals')
          .where('status', isEqualTo: 'Perdido')
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
                "Animales perdidos",
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
}*/
