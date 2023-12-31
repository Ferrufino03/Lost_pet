import 'package:lost_pet/screens/AnimalRegistration/ui/AnimalRegistrationScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/LostAnimalCard.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_profile_screen.dart';
import 'DeveloperInfoScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
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
  String selectedCategory = '';

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Se mueven las opciones del widget aquí para que se reconstruyan con el estado actualizado
    final List<Widget> _widgetOptions = <Widget>[
      LostAnimalsSection(
          searchQuery: _searchQuery,
          isSearching: _isSearching,
          selectedCategory: selectedCategory),
      FoundAnimalsSection(selectedCategory: selectedCategory),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lost Pets',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        actions: [
          IconTheme(
            data:
                IconThemeData(color: Theme.of(context).colorScheme.onSecondary),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen()),
                );
              },
              icon: const Icon(Icons.account_circle),
            ),
          ),
          IconTheme(
            data:
                IconThemeData(color: Theme.of(context).colorScheme.onSecondary),
            child: IconButton(
              onPressed: () {
                context.read<SignInBloc>().add(const SignOutRequired());
              },
              icon: const Icon(Icons.logout),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeveloperInfoScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Ver todos',
                  child: Text('Ver todos'),
                ),
                const PopupMenuItem<String>(
                  value: 'Conejo',
                  child: Text('Conejo'),
                ),
                const PopupMenuItem<String>(
                  value: 'Pato',
                  child: Text('Pato'),
                ),
                const PopupMenuItem<String>(
                  value: 'Perro',
                  child: Text('Perro'),
                ),
                const PopupMenuItem<String>(
                  value: 'Capibara',
                  child: Text('Capibara'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AnimalRegistrationScreen()),
              );
            },
            child: Text(
              'Registrar Animal Perdido',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
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
        selectedItemColor: Theme.of(context).colorScheme.primary,
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
  final String selectedCategory;
  final String searchQuery;
  final bool isSearching;

  const LostAnimalsSection({
    Key? key,
    required this.selectedCategory,
    required this.searchQuery,
    required this.isSearching,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> stream;

    if (isSearching && searchQuery.isNotEmpty) {
      stream = FirebaseFirestore.instance
          .collection('animals')
          .where('status', isEqualTo: 'Perdido')
          .where('animaltype', isEqualTo: searchQuery)
          .snapshots();
    } else if (selectedCategory != 'Ver todos' && selectedCategory.isNotEmpty) {
      stream = FirebaseFirestore.instance
          .collection('animals')
          .where('status', isEqualTo: 'Perdido')
          .where('animaltype', isEqualTo: selectedCategory)
          .snapshots();
    } else {
      stream = FirebaseFirestore.instance
          .collection('animals')
          .where('status', isEqualTo: 'Perdido')
          .snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: const CircularProgressIndicator());

        var animalCards = snapshot.data!.docs.map((doc) {
          return LostAnimalCard(
            imageUrl: doc['imageURL'],
            animalType: doc['animaltype'],
            additionalInfo: doc['informacion'],
            ubicacionDePerdida: doc['infoubicacion'],
            recompensa: doc['recompensa'],
            numeroDeReferencia: doc['numref'],
            statusa: doc['status'],
            userId: doc['userId'], // Asegúrate de incluir el userId aquí
          );
        }).toList();

        return ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Animales Perdidos",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
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
  final String selectedCategory;

  FoundAnimalsSection({required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> animalStream;

    if (selectedCategory == 'Ver todos') {
      animalStream = FirebaseFirestore.instance
          .collection('animals')
          .where('status', isEqualTo: 'Encontrado')
          .snapshots();
    } else if (selectedCategory.isNotEmpty) {
      animalStream = FirebaseFirestore.instance
          .collection('animals')
          .where('status', isEqualTo: 'Encontrado')
          .where('animaltype', isEqualTo: selectedCategory)
          .snapshots();
    } else {
      animalStream = FirebaseFirestore.instance
          .collection('animals')
          .where('status', isEqualTo: 'Encontrado')
          .snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: animalStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        List<LostAnimalCard> animalCards = snapshot.data!.docs.map((doc) {
          return LostAnimalCard(
            imageUrl: doc['imageURL'],
            animalType: doc['animaltype'],
            additionalInfo: doc['informacion'],
            ubicacionDePerdida: doc['infoubicacion'],
            recompensa: doc['recompensa'],
            numeroDeReferencia: doc['numref'],
            statusa: doc['status'],
            userId:
                doc['userId'], // Asegúrate de incluir el userId aquí también
          );
        }).toList();

        return ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Animales Encontrados",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
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
