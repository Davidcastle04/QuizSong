import 'dart:math';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
                      _buildHeader(context, name: receiver.name!, model: model),
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
                              isCurrentUser: message.senderId ==
                                  currentUser!.uid,
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

  void _showUserProfileImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Esquinas redondeadas
        ),
        content: SizedBox(
          width: 250, // Ancho del cuadro de diálogo
          height: 250, // Alto del cuadro de diálogo
          child: Center(
            child: receiver.imageUrl != null
                ? Image.network(receiver.imageUrl!) // Imagen del usuario
                : _buildInitialAvatar(
                receiver.name!), // Avatar con la inicial si no hay imagen
          ),
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

  void _changeBackground(BuildContext context) async {
    // Usamos el image_picker para seleccionar una imagen
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Si el usuario selecciona una imagen, guardamos el archivo
      File imageFile = File(pickedFile.path);

      // Aquí puedes guardar la imagen de fondo en el estado o donde sea necesario
      // Por ejemplo, podrías actualizar el fondo de la conversación o guardar la imagen
      context.read<ChatViewmodel>().updateBackground(imageFile);
    }
  }

  Row _buildHeader(BuildContext context,
      {String name = "", required ChatViewmodel model}) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context), // Acción para volver atrás
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
            } else if (value == 'change_background') {
              _changeBackground(context); // Cambiar fondo
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
            const PopupMenuItem(
              value: 'change_background',
              child: Text('Cambiar Fondo'),
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

  Widget _buildChatBackground(ChatViewmodel model) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: model.backgroundImage != null
            ? DecorationImage(
          image: FileImage(model.backgroundImage!),
          fit: BoxFit.cover,
        )
            : null,
      ),
    );
  }

  Widget _buildInitialAvatar(String? name) {
    String initial = name != null && name.isNotEmpty ? name[0].toUpperCase() : '?';

    // Generar un color aleatorio
    Color randomColor = Color.fromRGBO(
      Random().nextInt(256), // Rojo (0-255)
      Random().nextInt(256), // Verde (0-255)
      Random().nextInt(256), // Azul (0-255)
      1, // Opacidad (1 = completamente opaco)
    );

    return Container(
      width: 90, // Tamaño cuadrado más pequeño
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Hace que sea un círculo
        color: randomColor, // Color de fondo aleatorio
      ),
      child: Center(
        child: Text(
          initial, // Primera letra del nombre
          style: TextStyle(
            color: Colors.white, // Color del texto
            fontSize: 40, // Tamaño del texto
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
