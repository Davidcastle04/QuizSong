import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizsong/core/constants/string.dart';
import 'package:quizsong/core/models/user_model.dart';
import 'package:quizsong/core/services/database_service.dart';
import 'package:quizsong/ui/Pantallas/bottom_navigation/chats_list/chat_list_viewmodel.dart';
import 'package:quizsong/ui/Pantallas/other/user_provider.dart';
import 'package:quizsong/ui/widgets/Widgets_Texto.dart';

import '../../../../core/enums/enums.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    return ChangeNotifierProvider(
      create: (context) => ChatListViewmodel(DatabaseService(), currentUser!),
      child: Consumer<ChatListViewmodel>(builder: (context, model, _) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor, // 🔹 Fondo dinámico
          padding:
          EdgeInsets.symmetric(horizontal: 1.sw * 0.05, vertical: 10.h),
          child: Column(
            children: [
              30.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "QuizSong",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 30),
                ),
              ),
              20.verticalSpace,
              CustomTextfield(
                isSearch: true,
                hintText: "Buscar aquí ...",
                onChanged: model.search,
              ),
              10.verticalSpace,
              model.state == ViewState.loading
                  ? const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
                  : model.users.isEmpty
                  ? Expanded(
                child: Center(
                  child: Text(
                    "Todavía no hay usuarios con quien hablar 😢",
                    style: Theme.of(context).textTheme.bodyLarge, // 🔹 Usa tema
                  ),
                ),
              )
                  : Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  itemCount: model.filteredUsers.length,
                  separatorBuilder: (context, index) =>
                  8.verticalSpace,
                  itemBuilder: (context, index) {
                    final user = model.filteredUsers[index];
                    return ChatTile(
                      user: user,
                      onTap: () => Navigator.pushNamed(
                        context,
                        chatRoom,
                        arguments: user,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, this.onTap, required this.user});
  final UserModel user;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: Theme.of(context).cardColor, // 🔹 Color adaptable
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      leading: user.imageUrl == null
          ? CircleAvatar(
        backgroundColor: Theme.of(context).disabledColor, // 🔹 Color adaptable
        radius: 25,
        child: Text(
          user.name![0],
          style: Theme.of(context).textTheme.bodyLarge, // 🔹 Usa tema
        ),
      )
          : ClipOval(
        child: Image.network(
          user.imageUrl!,
          height: 50,
          width: 50,
          fit: BoxFit.fill,
        ),
      ),
      title: Text(
        user.name!,
        style: Theme.of(context).textTheme.titleMedium, // 🔹 Usa tema
      ),
      subtitle: Text(
        user.lastMessage != null ? user.lastMessage!["content"] : "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall, // 🔹 Usa tema
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            user.lastMessage == null ? "" : getTime(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor, // 🔹 Color adaptable
            ),
          ),
          8.verticalSpace,
          user.unreadCounter == 0 || user.unreadCounter == null
              ? const SizedBox(height: 15)
              : CircleAvatar(
            radius: 9.r,
            backgroundColor: Theme.of(context).colorScheme.primary, // 🔹 Usa color principal del tema
            child: Text(
              "${user.unreadCounter}",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary, // 🔹 Contraste adecuado
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getTime() {
    DateTime now = DateTime.now();
    DateTime lastMessageTime = user.lastMessage == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(user.lastMessage!["timestamp"]);

    int minutes = now.difference(lastMessageTime).inMinutes % 60;

    if (minutes < 60) {
      return "$minutes minutes ago";
    } else {
      return "${now.difference(lastMessageTime).inHours % 24} hours ago";
    }
  }
}
