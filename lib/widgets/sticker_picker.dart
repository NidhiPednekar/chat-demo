import 'package:flutter/material.dart';

class StickerPicker extends StatelessWidget {
  final void Function(String) onStickerSelected;
  StickerPicker({required this.onStickerSelected});

  final List<String> stickers = [
    'assets/stickers/bye.png',
    'assets/stickers/cat_love.png',
    'assets/stickers/hi.png',
    'assets/stickers/cool.png',
    'assets/stickers/cute.png',
    'assets/stickers/gm.png',
    'assets/stickers/good_luck.png',
    'assets/stickers/hmm.png',
    'assets/stickers/love.png',
    'assets/stickers/stop.png',
    'assets/stickers/wow.png',
    'assets/stickers/xoxo.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: stickers.map((s) => GestureDetector(
        onTap: () => onStickerSelected(s),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(s, width: 60, height: 60),
        ),
      )).toList(),
    );
  }
}
