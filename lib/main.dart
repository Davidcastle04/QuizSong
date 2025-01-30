import 'package:flutter/material.dart';

void main() {
}

class MainChat extends StatefulWidget {
  @override
  _MainChatState createState() => _MainChatState();
}

class MainChatState extends State<MainChat> {

  Client _client;

  @override
  void initState(){
    _client = Client(
      '',//Insertar el API Key
      logLevel: Level.INFO,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      builder: (context, child){
        return StreamChat(
            child: child,
            client: _client,
        );
      }
      home: HomeChat(),
    );
  }
}