import 'package:flutter/material.dart';
import 'package:application_de_note/model/list_model.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  Color _selectedColor = Colors.white;

  void _saveProduct() {
    final newProduct = Product(
      title: _titleController.text,
      desc: _descController.text,
      color: _selectedColor,
    );
    Navigator.pop(context, newProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Todo",
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedColor = Colors.red),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: _selectedColor == Colors.red
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedColor = Colors.green),
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: _selectedColor == Colors.green
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedColor = Colors.blue),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: _selectedColor == Colors.blue
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shadowColor: Colors.black26,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              onPressed: _saveProduct,
              child: const Text(
                'Save',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
