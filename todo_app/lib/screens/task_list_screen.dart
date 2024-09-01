import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/task.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> _taskList;

  @override
  void initState() {
    super.initState();
    _refreshTaskList();
  }

  void _refreshTaskList() {
    setState(() {
      _taskList = DatabaseService().getTasks();
    });
  }

  void _deleteTask(int id) async {
    await DatabaseService().deleteTask(id);
    _refreshTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: _taskList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(
                      task.isCompleted ? Icons.check_circle : Icons.circle,
                      color: task.isCompleted ? Colors.green : Colors.orange,
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(task.description),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTask(task.id!),
                    ),
                    onTap: () async {
                      // Ouvrir l'écran de modification de tâche
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskFormScreen(task: task),
                        ),
                      );
                      if (result == true) {
                        _refreshTaskList();
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Aucune tâche trouvée.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaskFormScreen()),
          );
          if (result == true) {
            _refreshTaskList();
          }
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
    );
  }
}
