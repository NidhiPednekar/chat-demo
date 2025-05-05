import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/user.dart';

class ChatProvider with ChangeNotifier {
  final List<User> _users = [
    User(id: '1', name: 'You', avatarUrl: ''),
    User(id: '2', name: 'Alice', avatarUrl: ''),
    User(id: '3', name: 'Bob', avatarUrl: ''),
    // Add more users if you want
  ];

  List<User> get users => _users;

  final List<Message> _messages = [];
  List<Message> get messages => _messages;

  User get currentUser => _users[0];

  final List<String> _randomTexts = [
    "This concert is amazing!",
    "Anyone here from Mumbai?",
    "Coldplay rocks!",
    "Best night ever!",
    "Who's your favorite band member?",
    "Can't believe I'm here!",
    "The lights are insane!",
    "Love this song!",
    "Anyone want to meet up after?",
    "This is a dream come true!",
  ];

  Timer? _timer;
  final Random _random = Random();

  ChatProvider() {
    _startRandomMessages();
  }

  void _startRandomMessages() {
    _timer = Timer.periodic(Duration(seconds: 2), (_) {
      // Pick a random user (not the current user)
      final user = _users[_random.nextInt(_users.length - 1) + 1];
      final text = _randomTexts[_random.nextInt(_randomTexts.length)];
      _messages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        userId: user.id,
        type: MessageType.text,
        timestamp: DateTime.now(),
      ));
      notifyListeners();
    });
  }

  void sendMessage(String text, {MessageType type = MessageType.text, String? stickerAsset}) {
    _messages.add(Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      userId: currentUser.id,
      type: type,
      timestamp: DateTime.now(),
      stickerAsset: stickerAsset,
    ));
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  void stopLiveChat() {
    _timer?.cancel();
    _timer = null;
  }

  void startLiveChat() {
    if (_timer == null) {
      _startRandomMessages();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
