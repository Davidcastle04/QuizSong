import 'package:quizsong/core/constants/colors.dart';
import 'package:quizsong/core/constants/styles.dart';
import 'package:quizsong/core/extension/widget_extension.dart';
import 'package:quizsong/core/models/user_model.dart';
import 'package:quizsong/core/services/chat_service.dart';
import 'package:quizsong/ui/Pantallas/bottom_navigation/chats_list/chat_room/chat_viewmodel.dart';
import 'package:quizsong/ui/Pantallas/bottom_navigation/chats_list/chat_room/chat_widgets.dart';
import 'package:quizsong/ui/Pantallas/other/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizsong/webrtc/call_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.receiver});
  final UserModel receiver;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    return ChangeNotifierProvider(
      create: (context) => ChatViewmodel(ChatService(), currentUser!, receiver),
      child: Consumer<ChatViewmodel>(builder: (context, model, _) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 1.sw * 0.05, vertical: 10.h),
                  child: Column(
                    children: [
                      35.verticalSpace,
                      _buildHeader(context, name: receiver.name!, model: model), // Pasamos 'model' aquí
                      15.verticalSpace,
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(0),
                          itemCount: model.messages.length,
                          separatorBuilder: (context, index) =>
                          10.verticalSpace,
                          itemBuilder: (context, index) {
                            final message = model.messages[index];
                            return ChatBubble(
                              isCurrentUser: message.senderId == currentUser!.uid,
                              message: message,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              BottomField(
                controller: model.controller,
                onTap: () async {
                  try {
                    await model.saveMessage();
                  } catch (e) {
                    context.showSnackbar(e.toString());
                  }
                },
              )
            ],
          ),
        );
      }),
    );
  }

  Row _buildHeader(BuildContext context, {String name = "", required ChatViewmodel model}) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context), // ✅ Acción para volver atrás
          child: Container(
            padding: const EdgeInsets.only(left: 10, top: 6, bottom: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: grey.withOpacity(0.15),
            ),
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        15.horizontalSpace,
        Text(
          name,
          style: h.copyWith(fontSize: 20.sp),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: grey.withOpacity(0.15),
          ),
          child: IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              context.showSnackbar('Llamando a $name...');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CallScreen()),
              );
            },
          ),
        ),
        10.horizontalSpace,
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              _confirmDeleteConversation(context, model);
            } else if (value == 'view_image') {
              _showUserProfileImage(context);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Text('Borrar Conversación'),
            ),
            const PopupMenuItem(
              value: 'view_image',
              child: Text('Ver Imagen del Usuario'),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: grey.withOpacity(0.15),
            ),
            child: const Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }

  // Función para mostrar la imagen de perfil del usuario o la inicial con fondo
  void _showUserProfileImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: Center(
          child: receiver.imageUrl != null
              ? Image.network(receiver.imageUrl!) // Imagen del usuario
              : _buildInitialAvatar(receiver.name!), // Avatar con la inicial si no hay imagen
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cerrar"),
          ),
        ],
      ),
    );
  }
  void _confirmDeleteConversation(BuildContext context, ChatViewmodel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Estás seguro?'),
        content: Text('Esta acción eliminará toda la conversación.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              // Lógica para eliminar la conversación
              await model.deleteConversation();
              Navigator.pop(context);
              context.showSnackbar('Conversación eliminada');
            },
            child: Text("Eliminar"),
          ),
        ],
      ),
    );
  }
}

  Widget _buildInitialAvatar(String? name) {
    String initial = name != null && name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 80.w, // Tamaño del contenedor (ajustar según sea necesario)
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.blue, // Fondo de color (puedes cambiarlo o hacerlo aleatorio)
        borderRadius: BorderRadius.circular(40.r), // Redondear el contorno
      ),
      child: Center(
        child: Text(
          initial, // La primera letra del nombre del usuario
          style: TextStyle(
            color: Colors.white, // Color de la letra
            fontSize: 36.sp, // Tamaño de la letra
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


