import 'package:flutter/material.dart';

class HomeChat extends StatefulWidget {
  @override
  _HomeChatState createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream Chat')
      ), //AppBar
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome to the public Chat'),
            TextField(
              controller: null,
              decoration: InputDecoration(
                hinText: 'Username',
              ), //InputDecoration
            ), //TextField
            ElevatedButton(
              onPressed: _onGoPressed,
              child: Text('Go'),
            ), //ElevatedButton
          ],
        ), //Column
      ), //Center
    ); //Scaffold
  }
}