import 'package:quizsong/core/services/database_service.dart';
import 'package:quizsong/core/utils/route_utils.dart';
import 'package:quizsong/firebase_options.dart';
import 'package:quizsong/ui/Pantallas/other/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizsong/ui/Pantallas/splash/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quizsong/webrtc/call_screen.dart';
import 'core/utils/FontSizeProvider.dart';
import 'generated/l10n.dart';

// 📌 PROVEEDOR PARA MANEJAR EL TEMA DE LA APP
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const QuizSong());
}

class QuizSong extends StatelessWidget {
  const QuizSong({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider(DatabaseService())),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => FontSizeProvider()),
        ],
        child: Consumer2<ThemeProvider, FontSizeProvider>(
          builder: (context, themeProvider, fontSizeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              //home:CallScreen(),
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              theme: ThemeData.light().copyWith(
                textTheme: TextTheme(
                  displayLarge: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black),
                  displayMedium: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black87),
                  displaySmall: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black54),
                  headlineMedium: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black45),
                  headlineSmall: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black38),
                  titleLarge: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black26),
                  titleMedium: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black87),
                  titleSmall: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black54),
                  bodyLarge: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black),
                  bodyMedium: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black87),
                  labelLarge: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white),
                  bodySmall: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black54),
                  labelSmall: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black38),
                ),
              ),  // 🌞 Tema Claro

              darkTheme: ThemeData.dark().copyWith(
                textTheme: TextTheme(
                  displayLarge: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white),
                  displayMedium: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white70),
                  displaySmall: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white60),
                  headlineMedium: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white70),
                  headlineLarge: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white70),
                  headlineSmall: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white30),
                  titleLarge: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white24),
                  titleMedium: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white70),
                  titleSmall: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white60),
                  bodyLarge: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white),
                  bodyMedium: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white70),
                  labelLarge: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white),
                  bodySmall: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white60),
                  labelSmall: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.white70),
                ),
              ),  // 🌙 Tema Oscuro

              themeMode: themeProvider.themeMode, // 🌗 Cambia según el usuario

              onGenerateRoute: RouteUtils.onGenerateRoute,
              home: SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
