import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import '../models/user.dart';
import '../models/message.dart';


class ChatBubble extends StatelessWidget {
  final User user;
  final Message message;  // Changed from String to Message
  final bool isMe;

  const ChatBubble({
    Key? key,
    required this.user,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxBubbleWidth = MediaQuery.of(context).size.width * 0.75; // 75% of screen

    Widget content;
    if (message.type == MessageType.text) {
      content = Text(
        message.text,
        style: TextStyle(
          color: isMe ? Colors.white : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (message.type == MessageType.emoji) {
      content = Text(message.text, style: TextStyle(fontSize: 32));
    } else {
      content = Image.asset(message.stickerAsset!, width: 60, height: 60);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Container(
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.purpleAccent, width: 2),
              ),
              child: RandomAvatar(user.name, height: 32, width: 32),
            ),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxBubbleWidth,
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? LinearGradient(
                          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [Colors.white, Colors.grey[200]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(isMe ? 18 : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: content,
              ),
            ),
          ),
          if (isMe)
            Container(
              margin: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.deepPurple, width: 2),
              ),
              child: RandomAvatar(user.name, height: 32, width: 32),
            ),
        ],
      ),
    );
  }
}