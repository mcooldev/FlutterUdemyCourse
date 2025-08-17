import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/pages/chat_app/chat.dart';

import '../../helper/firebase_services/auth_services.dart';
import '../../providers/chat_app_provider.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({super.key});

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  ///
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<ChatAppProvider>(context, listen: false);
      prov.getUsers();
      prov.getUsername();
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatAppProvider>(
      builder: (_, prov, _) {
        ///
        final Auth auth = Auth.instance;
        final user = auth.auth.currentUser;
        final email = user!.email!;

        ///
        return PopScope(
          canPop: false,
          child: Scaffold(
            /// App bar here
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(prov.profileImg),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, ${prov.username}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    // todo
                    prov.logOut(context);
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.red),
                ),
              ],
            ),

            /// Body content here
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16, bottom: 44),
              child: SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: prov.users.length,
                  itemBuilder: (ctx, i) {
                    final otherUser = prov.users[i];
                    return ListTile(
                      onTap: () {
                        // todo
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Chat(
                              receiverUserEmail: otherUser.email,
                              receiverUsername: otherUser.userName == null
                                  ? "Unknown user"
                                  : otherUser.userName!,
                              receiverId: otherUser.uid,
                            ),
                          ),
                        );
                      },
                      //
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.shade300,
                        child: otherUser.userName != null
                            ? Text(otherUser.userName!.substring(0, 1))
                            : const Text("?"),
                      ),
                      //
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (otherUser.userName != null)
                            Text(
                              otherUser.userName!,
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          const SizedBox(height: 2),
                          Text(
                            otherUser.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      //
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey.shade700,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
