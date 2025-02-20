import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quizsong/core/services/auth_service.dart';
import 'package:quizsong/ui/Pantallas/other/user_provider.dart';

import '../../../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _profileImage;
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    print("Entra aquí");
    if (image != null) {
      final bytes = await image.readAsBytes(); // Lee la imagen en bytes
      setState(() {
        _profileImage = bytes;
      });
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("⚠️ No hay usuario autenticado.");
        return null;
      } else {
        print("✅ Usuario autenticado: ${user.uid}");
      }


      await AuthService().actualizarFotoPerfil(bytes); // Guarda la URL en la BD
    }
  }

  void _confirmDeleteUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de que deseas eliminar tu cuenta? Esta acción es irreversible."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              AuthService().borrarUsuario();
              Navigator.pop(context);
            },
            child: Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cambiar contraseña"),
        content: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: "Nueva contraseña"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              AuthService().actualizarContrasenia(_passwordController.text);
              Navigator.pop(context);
            },
            child: Text("Actualizar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(title: Text("Perfil")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Bienvenido a QuizSong, ${user?.name ?? 'Usuario'}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? MemoryImage(_profileImage!) // Si hay imagen en memoria, úsala
                    : (user?.imageUrl != null && user!.imageUrl!.isNotEmpty
                    ? NetworkImage(user!.imageUrl!) as ImageProvider // Imagen desde URL
                    : AssetImage('assets/profile_placeholder.png') as ImageProvider // Imagen por defecto
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("Modificar foto de perfil"),
              onTap: _pickImage,
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text("Modificar contraseña"),
              onTap: _changePassword,
            ),
            ListTile(
              leading: Icon(Icons.person_remove),
              title: Text("Eliminar usuario"),
              onTap: _confirmDeleteUser,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Cerrar sesión"),
              onTap: () {
                Provider.of<UserProvider>(context, listen: false).clearUser();
                AuthService().salirUsuario();
              },
            ),
            ListTile(
              leading: Icon(Icons.nightlight),
              title: Text("Cambiar de Aspecto"),
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
