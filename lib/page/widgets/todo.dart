import 'package:flutter/material.dart';

class Todo {
  final String name;
  bool checked;

  Todo({
    required this.name,
    this.checked = false,
  });
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Todo> _todos = [];
  final TextEditingController _textController = TextEditingController();

  void _addTodo() {
    setState(() {
      final name = _textController.text;
      if (name.isNotEmpty) {
        _todos.add(Todo(name: name));
        _textController.clear();
      }
    });
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _handleTodoChange(int index, bool checked) {
    setState(() {
      _todos[index].checked = checked;
    });
  }

  Widget _buildTodoItem(BuildContext context, int index) {
    final todo = _todos[index];
    return Dismissible(
      key: Key(todo.name),
      onDismissed: (_) => _removeTodo(index),
      child: CheckboxListTile(
        title: Text(todo.name),
        value: todo.checked,
        onChanged: (checked) => _handleTodoChange(index, checked ?? false),
      ),
    );
  }

  Widget _buildAddTodoButton() {
    return FloatingActionButton(
      onPressed: _addTodo,
      tooltip: 'Add todo',
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: _buildTodoItem,
      ),
      floatingActionButton: _buildAddTodoButton(),
    );
  }
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: TodoList(),
    );
  }
}
