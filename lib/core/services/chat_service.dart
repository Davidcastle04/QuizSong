import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final _fire = FirebaseFirestore.instance;

  // Guardar un mensaje en la colección de mensajes
  saveMessage(Map<String, dynamic> message, String chatRoomId) async {
    try {
      await _fire
          .collection("chatRooms")
          .doc(chatRoomId)
          .collection("messages")
          .add(message);
    } catch (e) {
      rethrow;
    }
  }

  // Actualizar el último mensaje y el contador de mensajes no leídos
  updateLastMessage(String currentUid, String receiverUid, String message,
      int timestamp) async {
    try {
      // Actualizar el último mensaje para el usuario actual
      await _fire.collection("users").doc(currentUid).update({
        "lastMessage": {
          "content": message,
          "timestamp": timestamp,
          "senderId": currentUid
        },
        "unreadCounter": FieldValue.increment(1)
      });

      // Actualizar el último mensaje para el receptor
      await _fire.collection("users").doc(receiverUid).update({
        "lastMessage": {
          "content": message,
          "timestamp": timestamp,
          "senderId": currentUid,
        },
        "unreadCounter": 0
      });
    } catch (e) {
      rethrow;
    }
  }

  // Obtener los mensajes de una conversación ordenados por timestamp
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatRoomId) {
    return _fire
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // Eliminar una conversación, incluyendo todos los mensajes dentro de ella
  Future<void> deleteConversation(String currentUserId, String receiverId) async {
    try {
      // Generar el chatRoomId de la conversación
      String chatRoomId = currentUserId.hashCode > receiverId.hashCode
          ? "$currentUserId$receiverId"
          : "$receiverId$currentUserId";

      // Obtener todos los mensajes en esa sala de chat
      var chatRoomMessages = await _fire.collection('chatRooms').doc(chatRoomId).collection('messages').get();

      // Verificar si hay mensajes en la colección
      if (chatRoomMessages.docs.isEmpty) {
        print("No hay mensajes para eliminar.");
        return;
      }

      // Eliminar los mensajes de la conversación
      for (var doc in chatRoomMessages.docs) {
        await doc.reference.delete();
      }

      print("Mensajes eliminados exitosamente.");
    } catch (e) {
      print("Error al eliminar los mensajes: $e");
      throw Exception('Error al eliminar los mensajes: $e');
    }
  }
}
