import 'package:quizsong/core/constants/string.dart';
import 'package:quizsong/core/models/user_model.dart';
import 'package:quizsong/ui/Pantallas/auth/login/login_screen.dart';
import 'package:quizsong/ui/Pantallas/auth/signup/signup_screen.dart';
import 'package:quizsong/ui/Pantallas/bottom_navigation/chats_list/chat_room/chat_screen.dart';
import 'package:quizsong/ui/Pantallas/splash/splash_screen.dart';
import 'package:quizsong/ui/Pantallas/wrapper/wrapper.dart';
import 'package:flutter/material.dart';

class RouteUtils {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      // Auth
      case signup:
        return MaterialPageRoute(builder: (context) => const SignupScreen());
      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case wrapper:
        return MaterialPageRoute(builder: (context) => const Wrapper());
      case chatRoom:
        return MaterialPageRoute(
            builder: (context) => ChatScreen(
                  receiver: args as UserModel,
                ));

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text("No Route Found")),
          ),
        );
    }
  }
}
