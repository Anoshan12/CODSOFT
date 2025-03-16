import 'package:flutter/material.dart';
import 'task.dart'; // Import the Task model
import 'task_storage.dart'; // Import the TaskStorage class
import 'task_creation_screen.dart'; // Import the TaskCreationScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  final TaskStorage _taskStorage = TaskStorage();
  final String _userName = "Anoshan Yoganathan"; // User name
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks when the screen is initialized
  Future<void> _loadTasks() async {
    final loadedTasks = await _taskStorage.loadTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    await _taskStorage.saveTasks(tasks);
  }

  // Add a new task
  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
    _saveTasks();
  }

  // Edit an existing task
  void _editTask(int index, Task updatedTask) {
    setState(() {
      tasks[index] = updatedTask;
    });
    _saveTasks();
  }

  // Toggle task completion status
  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
    _saveTasks();
  }

  // Delete a task
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks();
  }

  // Filter tasks based on search query
  List<Task> _filterTasks(String query) {
    return tasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filterTasks(_searchController.text);

    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove shadow
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/b.png'), // Background image
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Column(
          children: [
            // User Name and Search Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello $_userName',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text for better visibility
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${tasks.length} Tasks are pending',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70, // Light white text
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Tasks',
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(
                          () {}); // Refresh the list when search query changes
                    },
                  ),
                ],
              ),
            ),
            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color:
                        Colors.white.withOpacity(0.8), // Semi-transparent card
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: task.isCompleted,
                            onChanged: (value) =>
                                _toggleTaskCompletion(tasks.indexOf(task)),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(tasks.indexOf(task)),
                          ),
                        ],
                      ),
                      onTap: () =>
                          _navigateToEditTaskScreen(tasks.indexOf(task)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskScreen,
        child: Icon(Icons.add),
      ),
    );
  }

  // Navigate to the task creation screen
  void _navigateToAddTaskScreen() async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskCreationScreen()),
    );
    if (newTask != null) {
      _addTask(newTask);
    }
  }

  // Navigate to the task editing screen
  void _navigateToEditTaskScreen(int index) async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskCreationScreen(task: tasks[index]),
      ),
    );
    if (updatedTask != null) {
      _editTask(index, updatedTask);
    }
  }
}
