import 'package:flutter/material.dart';
import 'task.dart'; // Import the Task model

class TaskCreationScreen extends StatefulWidget {
  final Task? task;

  TaskCreationScreen({this.task});

  @override
  _TaskCreationScreenState createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String _selectedCategory = 'Design'; // Default category

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _startTime = TimeOfDay.now();
    _endTime = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Create New Task' : 'Edit Task'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Name
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white
                        .withOpacity(0.8), // Semi-transparent background
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task name';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value!,
                ),
                SizedBox(height: 20),

                // Category
                Text(
                  'Category',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    _buildCategoryButton('Design'),
                    SizedBox(width: 11),
                    _buildCategoryButton('Development'),
                    SizedBox(width: 11),
                    _buildCategoryButton('Research'),
                  ],
                ),
                SizedBox(height: 20),

                // Date & Time
                Text(
                  'Date & Time',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white.withOpacity(
                                0.8), // Semi-transparent background
                          ),
                          child: Text(
                            '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context, true),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white.withOpacity(
                                0.8), // Semi-transparent background
                          ),
                          child: Text(
                            '${_startTime.format(context)}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context, false),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white.withOpacity(
                                0.8), // Semi-transparent background
                          ),
                          child: Text(
                            '${_endTime.format(context)}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Description
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white
                        .withOpacity(0.8), // Semi-transparent background
                  ),
                  maxLines: 3,
                  onSaved: (value) => _description = value ?? '',
                ),
                SizedBox(height: 20),

                // Create Task Button
                Center(
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    child: Text(
                      'Create Task',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _selectedCategory = category;
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: _selectedCategory == category
              ? Color(0xc2e6d8ef).withOpacity(0.1)
              : Colors.transparent,
          side: BorderSide(
            color: _selectedCategory == category
                ? Color(0xc2091604)
                : Colors.white,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: _selectedCategory == category
                ? Color(0xc2e4d8eb)
                : Colors.white,
          ),
        ),
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final task = Task(
        id: widget.task?.id ?? DateTime.now().toString(),
        title: _title,
        description: _description,
        dueDate: _dueDate,
      );
      Navigator.pop(context, task);
    }
  }
}
