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
          // color: currentTheme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[300],
          color: Colors.black45,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                  filled: true,
                  // fillColor: const Color.fromARGB(255, 50, 50, 50),
                  enabledBorder: OutlineInputBorder(
                    // borderSide: const BorderSide(color: Color.fromARGB(255, 50, 50, 50), width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderSide: const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  // focusColor: Colors.black,
                  hintText: ' Add Task'),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  addTodoItem(value);
                }
              },
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: todoItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(color: currentTheme.canvasColor, borderRadius: BorderRadius.circular(20)),
                      child: Dismissible(
                        key: Key(todoItems[index].text),
                        onDismissed: (direction) {
                          deleteTodoItem(index);
                        },
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.redAccent,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.redAccent,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: CheckboxListTile(
                            // visualDensity: VisualDensity.compact,
                            checkboxShape: const CircleBorder(),
                            // tileColor: currentTheme.canvasColor,
                            // tileColor: Colors.grey[900],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: Text(
                              todoItems[index].text,
                              style: TextStyle(
                                decoration: todoItems[index].completed ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            value: todoItems[index].completed,
                            onChanged: (newValue) {
                              setState(() {
                                todoItems[index].completed = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
