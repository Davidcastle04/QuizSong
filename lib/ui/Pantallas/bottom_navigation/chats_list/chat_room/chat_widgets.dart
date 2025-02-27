import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quizsong/core/constants/colors.dart';
import 'package:quizsong/core/constants/styles.dart';
import 'package:quizsong/core/models/message_model.dart';
import 'package:quizsong/ui/widgets/Widgets_Texto.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BottomField extends StatelessWidget {
  const BottomField({super.key, this.onTap, this.onChanged, this.controller});
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  // Método para abrir el modal de opciones
  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(FeatherIcons.paperclip, color: primary),
                title: Text("Enviar Archivo", style: body),
                onTap: () {
                  Navigator.pop(context);
                  _handleFileSend(context);  // Llamar a la función para enviar archivo
                },
              ),
              ListTile(
                leading: Icon(FeatherIcons.music, color: primary),
                title: Text("Iniciar Juego QuizSong", style: body),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implementar lógica para iniciar juego
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Función para manejar la selección de archivo (Imagen, Audio, etc.)
  Future<void> _handleFileSend(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    // Abre un modal para seleccionar tipo de archivo
    final pickedFile = await showDialog<File>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Selecciona un archivo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Imagen"),
                onTap: () async {
                  final file = await picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, file != null ? File(file.path) : null);
                },
              ),
              ListTile(
                leading: Icon(Icons.audiotrack),
                title: Text("Audio"),
                onTap: () async {
                  final file = await picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, file != null ? File(file.path) : null);
                },
              ),
              ListTile(
                leading: Icon(Icons.video_collection),
                title: Text("Video"),
                onTap: () async {
                  final file = await picker.pickVideo(source: ImageSource.gallery);
                  Navigator.pop(context, file != null ? File(file.path) : null);
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      // Aquí puedes hacer lo que necesites con el archivo (subirlo, mostrarlo, etc.)
      print("Archivo seleccionado: ${pickedFile.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: grey.withOpacity(0.2),
      padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.05, vertical: 25.h),
      child: Row(
        children: [
          InkWell(
            onTap: () => _showOptionsModal(context), // Abre el modal cuando se toca
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: const Icon(Icons.add),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: CustomTextfield(
              controller: controller,
              isChatText: true,
              hintText: "Write message..",
              onChanged: onChanged,
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {super.key, this.isCurrentUser = true, required this.message});
  final bool isCurrentUser;
  final Message message;

  @override
  Widget build(BuildContext context) {
    final borderRadius = isCurrentUser
        ? BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
        bottomLeft: Radius.circular(16.r))
        : BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
        bottomRight: Radius.circular(16.r));
    final alignment =
    isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: 1.sw * 0.75, minWidth: 50.w),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isCurrentUser ? primary : grey.withOpacity(0.2),
            borderRadius: borderRadius),
        child: Column(
          crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              message.content!,
              style: body.copyWith(color: isCurrentUser ? white : null),
            ),
            5.verticalSpace,
            Text(
              DateFormat('hh:mm a').format(message.timestamp!),
              style: small.copyWith(color: isCurrentUser ? white : null),
            ),
          ],
        ),
      ),
    );
  }
}
