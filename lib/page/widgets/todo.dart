import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> todoItems = [];

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void addTodoItem(String todoText) {
    setState(() {
      todoItems.add(TodoItem(text: todoText, completed: false));
      _textEditingController.clear();
    });
  }

  void deleteTodoItem(int index) {
    setState(() {
      todoItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: const Text('Todo List'),
      // ),
      body: Container(
        decoration: BoxDecoration(
            color: currentTheme.brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                labelText: 'Add Task',
              ),
              onSubmitted: (value) {
                addTodoItem(value);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todoItems.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(todoItems[index].text),
                    onDismissed: (direction) {
                      deleteTodoItem(index);
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                    ),
                    child: CheckboxListTile(
                      title: Text(todoItems[index].text),
                      value: todoItems[index].completed,
                      onChanged: (newValue) {
                        setState(() {
                          todoItems[index].completed = newValue!;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoItem {
  String text;
  bool completed;

  TodoItem({required this.text, required this.completed});
}
