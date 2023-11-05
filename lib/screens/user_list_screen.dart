/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Usuarios')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Añadido el operador "!" para indicar que el valor no es nulo
            return Text('No hay usuarios disponibles.');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!
                  .length, // Añadido el operador "!" para indicar que el valor no es nulo
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]['name'] ??
                      ''), // Añadido el operador "!" y "?? ''" para manejar null
                  subtitle: Text(snapshot.data![index]['lastname'] ??
                      ''), // Añadido el operador "!" y "?? ''" para manejar null
                );
              },
            );
          }
        },
      ),
    );
  }
}
*/