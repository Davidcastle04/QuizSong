import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart'; // Importa image_picker
import 'package:provider/provider.dart';
import 'package:quizsong/core/services/auth_service.dart';
import 'package:quizsong/ui/screens/other/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _profileImageUrl; // Variable para la URL de la imagen de perfil

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Aquí iría la lógica para subir la imagen a Firebase Storage
      // y obtener la URL.  Por ahora, solo actualizamos la variable local.
      setState(() {
        _profileImageUrl = image.path; // Usar la ruta local como ejemplo
      });

      // TODO: Subir la imagen a Firebase Storage y actualizar _profileImageUrl con la URL real.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.05),
        child: Column(
          children: [
            50.verticalSpace,

            // Imagen de perfil (o un placeholder)
            GestureDetector(
              onTap: _pickImage, // Abrir el selector de imágenes al tocar
              child: CircleAvatar(
                radius: 50.r,
                backgroundImage: _profileImageUrl != null
                    ? FileImage(File(_profileImageUrl!)) // Imagen local (ejemplo)
                    : const AssetImage('assets/profile_placeholder.png') as ImageProvider, // Placeholder
              ),
            ),

            20.verticalSpace,

            // Menú de opciones
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Modificar foto de perfil"),
              onTap: _pickImage,
            ),
            ListTile(
              leading: const Icon(Icons.person_remove),
              title: const Text("Eliminar usuario"),
              onTap: () {
                // TODO: Lógica para eliminar usuario (requiere confirmación)
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Modificar contraseña"),
              onTap: () {
                // TODO: Lógica para modificar contraseña
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Cerrar sesión"),
              onTap: () {
                Provider.of<UserProvider>(context, listen: false).clearUser();
                AuthService().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}