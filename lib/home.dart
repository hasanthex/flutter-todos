import 'package:flutter/material.dart';
import 'package:flutter_form_application/models/todo.dart';
import 'package:flutter_form_application/todo_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formGlobalKey = GlobalKey<FormState>();
  Priority _selectedPriority = Priority.low;
  String _title = '';
  String _description = '';

  final List<Todo> todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: TodoList(todos: todos)),
            Form(
              key: _formGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //  todo title
                  TextFormField(
                    maxLength: 30,
                    decoration: const InputDecoration(
                      label: Text("Todo title"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Todo title required";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _title = value!;
                    },
                  ),
                  //  todo description
                  TextFormField(
                    maxLength: 1000,
                    decoration: const InputDecoration(
                      label: Text("Todo description"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Todo description required";
                      } else if (value.length < 10) {
                        return "Todo description too small.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value!;
                    },
                  ),
                  DropdownButtonFormField(
                    value: _selectedPriority,
                    decoration: const InputDecoration(
                      label: Text("Priority of todo"),
                    ),
                    items: Priority.values.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text(p.title),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value!;
                      });
                    },
                  ),
                  // submit button
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      if (_formGlobalKey.currentState!.validate()) {
                        _formGlobalKey.currentState!.save();
                        setState(() {
                          todos.add(Todo(
                            description: _description,
                            title: _title,
                            priority: _selectedPriority,
                          ));
                        });
                        _formGlobalKey.currentState!.reset();
                        _selectedPriority = Priority.low;
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
