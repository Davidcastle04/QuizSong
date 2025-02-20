import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class AuthService {
  final _autentificacion = FirebaseAuth.instance;
  final _almacenamiento = FirebaseStorage.instance;

  Future<User?> inicioSesion(String email, String password) async {
    try {
      final authCredential = await _autentificacion.createUserWithEmailAndPassword(
          email: email, password: password);

      if (authCredential.user != null) {
        log("User created successfully");
        return authCredential.user!;
      }
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
    return null;
  }

  Future<User?> login(String email, String password) async {
    try {
      final authCredential = await _autentificacion.signInWithEmailAndPassword(
          email: email, password: password);

      if (authCredential.user != null) {
        log("User logged in successfully");
        return authCredential.user!;
      }
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
    return null;
  }

  Future<void> salirUsuario() async {
    try {
      await _autentificacion.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> actualizarContrasenia(String newPassword) async {
    try {
      User? user = _autentificacion.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        log("Password updated successfully");
      }
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> borrarUsuario() async {
    try {
      User? user = _autentificacion.currentUser;
      if (user != null) {
        await user.delete();
        log("User deleted successfully");
      }
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<String?> actualizarFotoPerfil(Uint8List imageBytes) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log("⚠️ No hay usuario autenticado.");
        return null;
      }

      // Guardar temporalmente la imagen
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${user.uid}.jpg');
      await tempFile.writeAsBytes(imageBytes);

      final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}.jpg');
      log("📤 Subiendo archivo desde: ${tempFile.path}");

      await storageRef.putFile(tempFile);  // Usamos putFile en lugar de putData
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'imageUrl': imageUrl,
      });

      log("✅ Imagen subida correctamente: $imageUrl");
      return imageUrl;
    } catch (e) {
      log("❌ Error al subir la imagen: $e");
      return null;
    }
  }

}
