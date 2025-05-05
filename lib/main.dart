import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/message.dart';
import 'models/user.dart';
import 'providers/chat_provider.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/emoji_picker.dart';
import 'widgets/sticker_picker.dart';
import 'widgets/floating_emoji.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: ChatRoomApp(),
    ),
  );
}

class ChatRoomApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Chat Room',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatRoomScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatRoomScreen extends StatefulWidget {
  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _showEmojiPicker = false;
  bool _showStickerPicker = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<OverlayEntry> _floatingEmojis = [];
  final List<String> predefinedMessages = [
    "This concert is amazing!",
    "Coldplay rocks!",
    "Best night ever!",
    "Love this song!",
    "Anyone here from Mumbai?",
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<ChatProvider>(context, listen: false).startLiveChat()
    );
  }

  void _sendMessage(BuildContext context, String text, {MessageType type = MessageType.text, String? stickerAsset}) {
    if (text.trim().isEmpty && type == MessageType.text) return;
    Provider.of<ChatProvider>(context, listen: false).sendMessage(text, type: type, stickerAsset: stickerAsset);
    _controller.clear();
    setState(() {
      _showEmojiPicker = false;
      _showStickerPicker = false;
    });
  }

  void _showFloatingEmoji(String emoji) {
  final overlay = Overlay.of(context);
  final entry = OverlayEntry(
    builder: (context) => FloatingEmoji(emoji: emoji),
  );
  overlay.insert(entry);
  Future.delayed(Duration(milliseconds: 1800), () {
    entry.remove();
  });
}

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final messages = chatProvider.messages;
    final users = chatProvider.users;
    final currentUser = chatProvider.currentUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.black.withOpacity(0.3),
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/stickers/community.webp'), // Add a topic image
                radius: 22,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CHAT ROOM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 6),
                      Text('Trending', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.stop_circle, color: Colors.redAccent),
              tooltip: 'Stop Live Chat',
              onPressed: () {
                chatProvider.stopLiveChat();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6D5BFF), Color(0xFF2196F3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.15),
          ),
          Column(
            children: [
              SizedBox(height: 90), // For AppBar
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    final user = users.firstWhere((u) => u.id == msg.userId, orElse: () => currentUser);
                    return ChatBubble(
                      message: msg,
                      user: user,
                      isMe: msg.userId == currentUser.id,
                    );
                  },
                ),
              ),
              // Predefined message chips
              Container(
                height: 48,
                margin: EdgeInsets.only(bottom: 4),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: predefinedMessages.map((msg) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ActionChip(
                        label: Text(msg, style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.purpleAccent.withOpacity(0.8),
                        onPressed: () {
                          chatProvider.sendMessage(msg);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Input bar
              _buildInputBar(context),
              if (_showEmojiPicker)
                EmojiPicker(
                onEmojiSelected: (emoji) {
                  chatProvider.sendMessage(emoji, type: MessageType.emoji);
                  _showFloatingEmoji(emoji); 
                },
              ),
              if (_showStickerPicker)
                StickerPicker(
                  onStickerSelected: (sticker) {
                    chatProvider.sendMessage('', type: MessageType.sticker, stickerAsset: sticker);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final TextEditingController _controller = TextEditingController();

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.emoji_emotions, color: Colors.purpleAccent),
              onPressed: () {
                setState(() {
                  _showEmojiPicker = !_showEmojiPicker;
                  _showStickerPicker = false;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.sticky_note_2, color: Colors.blueAccent),
              onPressed: () {
                setState(() {
                  _showStickerPicker = !_showStickerPicker;
                  _showEmojiPicker = false;
                });
              },
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Type your message...",
                  border: InputBorder.none,
                ),
                onSubmitted: (text) {
                  if (text.trim().isNotEmpty) {
                    chatProvider.sendMessage(text.trim());
                    _controller.clear();
                  }
                },
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.deepPurple),
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    chatProvider.sendMessage(_controller.text.trim());
                    _controller.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
