import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
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
            color: currentTheme.brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[300], borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusColor: Colors.black,
                  hintText: ' Add Task'),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  addTodoItem(value);
                }
              },
            ),
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: todoItems.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(todoItems[index].text),
                    onDismissed: (direction) {
                      deleteTodoItem(index);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: CheckboxListTile(
                      title: Text("$index ${todoItems[index].text}"),
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
