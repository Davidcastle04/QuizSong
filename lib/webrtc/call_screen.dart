import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'firebase_signaling.dart';
import 'webrtc_helper.dart';

class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final WebRTCHelper _webrtcHelper = WebRTCHelper();
  FirebaseSignaling? _signaling;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  bool _isCalling = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _localRenderer.initialize();
    await _webrtcHelper.initWebRTC();

    if (_webrtcHelper.peerConnection != null) {
      setState(() {
        _signaling = FirebaseSignaling(_webrtcHelper.peerConnection!);
      });
    } else {
      print("Error: peerConnection es null");
    }
  }

  void _startCall() async {
    setState(() => _isCalling = true);
    await _signaling?.createOffer();
    setState(() => _isCalling = false);
  }

  void _endCall() {
    _signaling?.endCall();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Llamada en curso", style: TextStyle(color: Colors.white, fontSize: 20)),
          SizedBox(height: 30),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          SizedBox(height: 20),
          Text("Contacto", style: TextStyle(color: Colors.white, fontSize: 18)),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: "mute",
                backgroundColor: Colors.grey.shade800,
                child: Icon(Icons.mic_off, color: Colors.white),
                onPressed: () {},
              ),
              FloatingActionButton(
                heroTag: "end",
                backgroundColor: Colors.red,
                child: Icon(Icons.call_end, color: Colors.white),
                onPressed: _endCall,
              ),
              FloatingActionButton(
                heroTag: "speaker",
                backgroundColor: Colors.grey.shade800,
                child: Icon(Icons.volume_up, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
