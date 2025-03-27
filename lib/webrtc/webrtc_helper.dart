import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCHelper {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  Future<void> initWebRTC() async {
    // Configuración de servidores STUN
    Map<String, dynamic> config = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    // Crear conexión RTC
    _peerConnection = await createPeerConnection(config);

    // Obtener acceso al micrófono
    _localStream = await navigator.mediaDevices.getUserMedia({
      "audio": true,
      "video": false,
    });

    // Agregar el stream de audio
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });
  }

  RTCPeerConnection? get peerConnection => _peerConnection;
  MediaStream? get localStream => _localStream;
}