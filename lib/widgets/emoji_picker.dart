import 'package:flutter/material.dart';

class EmojiPicker extends StatelessWidget {
  final void Function(String) onEmojiSelected;
  EmojiPicker({required this.onEmojiSelected});

  final List<String> emojis = ["😍", "😂", "🔥", "🥳", "🎉", "❤️", "👍", "😎", "🤩", "🙌"];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: emojis.map((e) => IconButton(
        onPressed: () => onEmojiSelected(e),
        icon: Text(e, style: TextStyle(fontSize: 24)),
      )).toList(),
    );
  }
}
