import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first({
    super.key,
    required this.message,
    required this.isMe,
    required this.username,
  }) : isFirstSequence = true;

  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
  }) : isFirstSequence = false,
       username = null;

  final String message;
  final bool isMe;
  final String? username;
  final bool isFirstSequence;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: isFirstSequence ? 24 : 4,
        left: 16,
        right: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe && isFirstSequence) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade300,
              child: username != null && username!.isNotEmpty
                  ? Text(
                      username!.substring(0, 1),
                      style: const TextStyle(color: Colors.black),
                    )
                  : const Text("?"),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.75,
              ),
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: isMe ? Colors.deepPurpleAccent : Colors.grey.shade300,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                message.trim(),
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
                softWrap: true,
              ),
            ),
          ),
          if (isMe && isFirstSequence) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.deepPurpleAccent,
              child: username != null && username!.isNotEmpty
                  ? Text(
                      username!.substring(0, 1),
                      style: const TextStyle(color: Colors.white),
                    )
                  : const Text("?"),
            ),
          ],
        ],
      ),
    );
  }
}
