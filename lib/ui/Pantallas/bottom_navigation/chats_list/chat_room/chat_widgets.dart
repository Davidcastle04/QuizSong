import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quizsong/core/constants/colors.dart';
import 'package:quizsong/core/constants/styles.dart';
import 'package:quizsong/core/models/message_model.dart';
import 'package:quizsong/ui/widgets/Widgets_Texto.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class BottomField extends StatelessWidget {
  const BottomField({super.key, this.onTap, this.onChanged, this.controller});
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

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
                  // TODO: Implementar lógica para enviar archivos
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: grey.withOpacity(0.2),
      padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.05, vertical: 25.h),
      child: Row(
        children: [
          InkWell(
            onTap: () => _showOptionsModal(context),
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
              ))
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
            )
          ],
        ),
      ),
    );
  }
}
