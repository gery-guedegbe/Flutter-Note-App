import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:application_de_note/pages/add_todo.dart';
import 'package:application_de_note/model/list_model.dart';
import 'package:application_de_note/widgets/list_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addNewProduct(Product product) async {
    await _firestore.collection('notes').add({
      'title': product.title,
      'desc': product.desc,
      'color': product.color.value,
      'userId': user?.uid,
    });
  }

  Stream<List<Product>> _fetchProducts() {
    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: user?.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Product(
                title: data['title'],
                desc: data['desc'],
                color: Color(data['color']),
              );
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "NoteApp",
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.hasData) {
            final products = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75, // Adjust the aspect ratio as needed
              ),
              itemBuilder: (context, index) {
                return ListButton(
                  product: products[index],
                  onTap: () {
                    // Handle tap if needed
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No notes found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final newProduct = await Navigator.push<Product>(
            context,
            MaterialPageRoute(builder: (context) => const AddTodo()),
          );

          if (newProduct != null) {
            _addNewProduct(newProduct);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
