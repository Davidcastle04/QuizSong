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
          ChangeNotifierProvider(create: (context) => ThemeProvider()), // 📌 Proveedor del tema
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              theme: ThemeData.light(),  // 🌞 Tema Claro
              darkTheme: ThemeData.dark(),  // 🌙 Tema Oscuro
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
