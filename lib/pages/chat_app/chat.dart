import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/widgets/chat_app/message_bubble.dart';

import '../../providers/chat_app_provider.dart';

class Chat extends StatefulWidget {
  const Chat({
    required this.receiverUserEmail,
    required this.receiverUsername,
    required this.receiverId,
    super.key,
  });

  final String receiverUserEmail, receiverUsername, receiverId;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ///
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<ChatAppProvider>(context, listen: false);
      prov.clearMessages();
      prov.getMessages(widget.receiverId);
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    ///

    ///
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<ChatAppProvider>(
        builder: (_, prov, _) {
          ///
          final bPadding = MediaQuery.of(context).viewInsets.bottom;

          //
          return Scaffold(
            /// App bar here
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey.shade100,
                    child: Text(
                      widget.receiverUsername[0].toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.receiverUsername,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.receiverUserEmail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              centerTitle: false,
            ),

            //
            resizeToAvoidBottomInset: true,
            //

            /// Body content here
            body: Column(
              children: [
                // Message viewer
                Expanded(
                  child: prov.messages.isEmpty
                      ? const Center(child: Text("No messages yet!"))
                      : ListView.builder(
                          // padding: const EdgeInsets.all(16),
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: prov.messages.length,
                          itemBuilder: (ctx, i) {
                            ///
                            final message = prov.messages[i];
                            final nextMsg = i + 1 < prov.messages.length
                                ? prov.messages[i + 1]
                                : null;
                            //
                            final currentMsgUser = message.email;
                            final nextMsgUser = nextMsg?.email;
                            //
                            final isSameUser = currentMsgUser == nextMsgUser;
                            //
                            final isMe =
                                message.email ==
                                prov.auth.auth.currentUser!.email;

                            ///

                            if (isSameUser) {
                              return MessageBubble.next(
                                message: message.message,
                                isMe: isMe,
                              );
                            } else {
                              return MessageBubble.first(
                                message: message.message,
                                isMe: isMe,
                                username: message.sender,
                              );
                            }
                          },
                        ),
                ),

                // Message input
                Container(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 32 + bPadding),
                  //
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(width: 1, color: Colors.grey.shade200),
                    ),
                  ),
                  //
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          //
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: TextField(
                            controller: prov.msgController,
                            cursorColor: Colors.deepPurpleAccent,
                            minLines: 1,
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              hintText: "Type a message...",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          prov.sendMessage(widget.receiverId);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: const Icon(
                            CupertinoIcons.paperplane,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
