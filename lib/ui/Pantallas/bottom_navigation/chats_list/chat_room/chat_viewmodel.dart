import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizsong/core/models/message_model.dart';
import 'package:quizsong/core/models/user_model.dart';
import 'package:quizsong/core/other/base_viewmodel.dart';
import 'package:quizsong/core/services/chat_service.dart';

class ChatViewmodel extends BaseViewmodel {
  final ChatService _chatService;
  final UserModel _currentUser;
  final UserModel _receiver;

  Stream<List<Message>> get messagesStream {
    return _chatService.getMessages(chatRoomId).map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Message.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }


  // Definir el StreamSubscription para manejar la escucha en tiempo real
  StreamSubscription? _subscription;

  ChatViewmodel(this._chatService, this._currentUser, this._receiver) {
    getChatRoom();

    _subscription = _chatService.getMessages(chatRoomId).listen((messages) {
      _messages = messages.docs
          .map((e) => Message.fromMap(e.data() as Map<String, dynamic>)) // ✅ Casting aquí
          .toList();
      notifyListeners();
    });

  }

  String chatRoomId = "";
  final _messageController = TextEditingController();
  TextEditingController get controller => _messageController;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  // Función para obtener el chatRoomId
  getChatRoom() {
    if (_currentUser.uid.hashCode > _receiver.uid.hashCode) {
      chatRoomId = "${_currentUser.uid}_${_receiver.uid}";
    } else {
      chatRoomId = "${_receiver.uid}_${_currentUser.uid}";
    }
  }

  // Función para enviar un mensaje

  saveMessage() async {
    try {
      if (_messageController.text.isEmpty) {
        throw Exception("Por favor, escribe un mensaje");
      }

      final now = DateTime.now();
      final message = Message(
        id: now.millisecondsSinceEpoch.toString(),
        content: _messageController.text,
        senderId: _currentUser.uid!,
        receiverId: _receiver.uid!,
        timestamp: now.microsecondsSinceEpoch,
      );

      // Actualización optimista
      _messages.insert(0, message);
      notifyListeners();

      await _chatService.saveMessage(message.toMap(), chatRoomId);
      _messageController.clear();
    } catch (e) {
      // Eliminar la actualización optimista si falla el envío
      _messages.removeAt(0);
      notifyListeners();
      rethrow;
    }
  }


  // Función para eliminar la conversación
  Future<void> deleteConversation() async {
    try {
      await _chatService.deleteConversation(_currentUser.uid!, _receiver.uid!);
      _messages.clear();  // Limpiar los mensajes locales
      notifyListeners();
    } catch (e) {
      throw Exception('Error al eliminar la conversación: $e');
    }
  }

  // Método para cargar mensajes de Firestore (opcional, si lo necesitas)
  Future<void> loadMessages() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(_currentUser.uid)
          .collection(_receiver.uid!)
          .orderBy('timestamp')
          .get();

      _messages = snapshot.docs.map((doc) {
        return Message.fromFirestore(doc);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error al cargar los mensajes: $e");
    }
  }

  // Método dispose para cancelar la suscripción al stream
  @override
  void dispose() {
    _subscription?.cancel();  // Cancelamos la suscripción al stream de mensajes
    super.dispose();  // Llamamos al dispose de la clase base
  }
}
