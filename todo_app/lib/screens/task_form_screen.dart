import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task; // Tâche existante à modifier, ou null si nouvelle tâche

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Si une tâche est fournie, nous remplissons les champs avec ses données
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _isCompleted = widget.task!.isCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.task == null ? 'Ajouter une Tâche' : 'Modifier la Tâche'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Titre',
                prefixIcon: Icon(Icons.title, color: Colors.teal),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description, color: Colors.teal),
              ),
            ),
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text('Tâche complétée'),
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty ||
                    _descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veuillez remplir tous les champs')),
                  );
                  return;
                }

                final task = Task(
                  id: widget.task?.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  isCompleted: _isCompleted,
                );

                if (widget.task == null) {
                  // Nouvelle tâche
                  DatabaseService().insertTask(task);
                } else {
                  // Modifier la tâche existante
                  DatabaseService().updateTask(task);
                }

                Navigator.pop(context, true);
              },
              child: Text(widget.task == null
                  ? 'Enregistrer la Tâche'
                  : 'Modifier la Tâche'),
            ),
          ],
        ),
      ),
    );
  }
}
