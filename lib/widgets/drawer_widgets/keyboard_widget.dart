import 'package:flutter/material.dart';

class KeyboardWidget extends StatelessWidget {
  final Function(String) onKeyPressed;
  final Function() onDeletePressed;
  final Function() onSubmitPressed;

  const KeyboardWidget({super.key, required this.onKeyPressed, required this.onDeletePressed, required this.onSubmitPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Wrap(
        children: <Widget>[
          _buildKeyboardRow(1, 2, 3, 4, 5, 6, 7, 8, 9, 0),
          _buildKeyboardRow('Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'),
          _buildKeyboardRow('A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'),
          _buildKeyboardRow('Z', 'X', 'C', 'V', 'B', 'N', 'M'),
          _buildKeyboardRow(null, null, null, null, null, null, null, null, null, null),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
                child: GestureDetector(
              onTap: () => onKeyPressed(' '),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(20)),
                child: const Divider(
                  height: 0,
                  color: Colors.transparent,
                ),
              ),
            )),
            GestureDetector(
                onTap: onDeletePressed,
                child: Container(color: Colors.transparent, padding: const EdgeInsets.all(20), child: const Icon(Icons.backspace))),
            GestureDetector(
                onTap: onSubmitPressed,
                child: Container(color: Colors.transparent, padding: const EdgeInsets.all(20), child: const Icon(Icons.check))),
          ])
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(dynamic key1, dynamic key2, dynamic key3,
      [dynamic key4, dynamic key5, dynamic key6, dynamic key7, dynamic key8, dynamic key9, dynamic key10, dynamic key11, dynamic key12]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (key1 != null) _buildKeyboardButton(key1),
        if (key2 != null) _buildKeyboardButton(key2),
        if (key3 != null) _buildKeyboardButton(key3),
        if (key4 != null) _buildKeyboardButton(key4),
        if (key5 != null) _buildKeyboardButton(key5),
        if (key6 != null) _buildKeyboardButton(key6),
        if (key7 != null) _buildKeyboardButton(key7),
        if (key8 != null) _buildKeyboardButton(key8),
        if (key9 != null) _buildKeyboardButton(key9),
        if (key10 != null) _buildKeyboardButton(key10),
        if (key11 != null) _buildKeyboardButton(key11),
        if (key12 != null) _buildKeyboardButton(key12),
      ],
    );
  }

  Widget _buildKeyboardButton(dynamic key) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onKeyPressed(key.toString()),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.transparent,
          child: Text(
            key.toString(),
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
