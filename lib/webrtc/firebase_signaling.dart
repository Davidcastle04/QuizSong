import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class FirebaseSignaling {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? callId;
  late RTCPeerConnection _peerConnection;

  FirebaseSignaling(this._peerConnection);

  Future<void> createOffer() async {

    RTCSessionDescription offer = await _peerConnection.createOffer();

    await _peerConnection.setLocalDescription(offer);

// Crear documento en Firestore con oferta y estado "waiting"

    DocumentReference callDoc = _firestore.collection('calls').doc();

    await callDoc.set({

      'offer': offer.toMap(),

      'status': 'waiting', // 🔥 Indicador de llamada en curso

      'createdAt': FieldValue.serverTimestamp(), // Para ordenación

    });



    callId = callDoc.id;

  }

  Future<void> answerCall(String callId) async {

    DocumentSnapshot callDoc = await _firestore.collection('calls').doc(callId).get();

    if (!callDoc.exists) return;



    Map<String, dynamic>? callData = callDoc.data() as Map<String, dynamic>?;



    if (callData != null && callData.containsKey('offer')) {

      RTCSessionDescription offer = RTCSessionDescription(

        callData['offer']['sdp'],

        callData['offer']['type'],

      );

      await _peerConnection.setRemoteDescription(offer);



      RTCSessionDescription answer = await _peerConnection.createAnswer();

      await _peerConnection.setLocalDescription(answer);



// Enviar la respuesta a Firebase

      await _firestore.collection('calls').doc(callId).update({

        'answer': answer.toMap(),

        'status': 'connected', // 🔥 Marcar como conectada

      });



      this.callId = callId;

    }

  }

  void listenForIceCandidates() {
    if (callId == null) return;

    _firestore.collection('calls').doc(callId).collection('candidates').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        // Convertir los datos a Map<String, dynamic>
        Map<String, dynamic>? candidateData = doc.data() as Map<String, dynamic>?;

        if (candidateData != null && candidateData.containsKey('candidate')) {
          RTCIceCandidate candidate = RTCIceCandidate(
            candidateData['candidate']['candidate'],
            candidateData['candidate']['sdpMid'],
            candidateData['candidate']['sdpMLineIndex'],
          );
          _peerConnection.addCandidate(candidate);
        }
      }
    });
  }

  Future<void> endCall() async {

    if (callId != null) {

      await _firestore.collection('calls').doc(callId).update({

        'status': 'ended',

      });

    }

  }
}