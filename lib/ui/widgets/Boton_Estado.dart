import 'package:quizsong/core/constants/colors.dart';
import 'package:quizsong/core/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BotonPersonalizable extends StatelessWidget {
  const BotonPersonalizable(
      {super.key, required this.texto, this.onPressed, this.estadoCarga = false});

  final void Function()? onPressed;
  final String texto;
  final bool estadoCarga;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 40.h,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: primary),
          onPressed: onPressed,
          child: estadoCarga
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Text(texto, style: body.copyWith(color: white))),
    );
  }
}
