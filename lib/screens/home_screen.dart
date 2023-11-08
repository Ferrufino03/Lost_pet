import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/LostAnimalCard.dart';
import 'AnimalRegistrationScreen.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_profile_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false, // Esto quita la etiqueta de debug
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Se mueven las opciones del widget aquí para que se reconstruyan con el estado actualizado
    final List<Widget> _widgetOptions = <Widget>[
      LostAnimalsSection(searchQuery: _searchQuery, isSearching: _isSearching),
      FoundAnimalsSection(), // Asumiendo que no necesita argumentos
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('LOST PETS!'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfileScreen()),
              );
            },
            icon: const Icon(Icons.account_circle),
          ),
          IconButton(
              onPressed: () {
                context.read<SignInBloc>().add(const SignOutRequired());
              },
              icon: const Icon(Icons.logout))
        ],
      ),
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
            child: const Text('Registrar Animal Perdido'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ingrese el tipo de animal',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  _isSearching = value.isNotEmpty;
                  _searchQuery = value.trim();
                });
              },
            ),
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
            label: 'Animales perdidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Animales encontrados',
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
  final String searchQuery;
  final bool isSearching;

  const LostAnimalsSection({
    Key? key,
    required this.searchQuery,
    required this.isSearching,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('animals')
        .where('status', isEqualTo: 'Perdido')
        .snapshots();

    if (isSearching && searchQuery.isNotEmpty) {
      stream = FirebaseFirestore.instance
          .collection('animals')
          .where('status', isEqualTo: 'Perdido')
          .where('animaltype', isEqualTo: searchQuery)
          .snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        var animalCards = snapshot.data!.docs.map((doc) {
          return LostAnimalCard(
            imageUrl: doc['imageURL'],
            animalType: doc['animaltype'],
            additionalInfo: doc['informacion'],
            ubicacionDePerdida: doc['infoubicacion'],
            recompensa: doc['recompensa'],
            numeroDeReferencia: doc['numref'],
            statusa: doc['status'],
          );
        }).toList();

        return ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Animales perdidos",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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

        var animalCards = snapshot.data!.docs.map((doc) {
          return LostAnimalCard(
            imageUrl: doc['imageURL'],
            animalType: doc['animaltype'],
            additionalInfo: doc['informacion'],
            ubicacionDePerdida: doc['infoubicacion'],
            recompensa: doc['recompensa'],
            numeroDeReferencia: doc['numref'],
            statusa: doc['status'],
          );
        }).toList();

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
