import 'package:quizsong/core/services/database_service.dart';
import 'package:quizsong/core/utils/route_utils.dart';
import 'package:quizsong/firebase_options.dart';
import 'package:quizsong/ui/screens/other/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


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
      builder: (context, child) => ChangeNotifierProvider(
        create: (context) => UserProvider(DatabaseService()),
        child: MaterialApp(
          onGenerateRoute: RouteUtils.onGenerateRoute,
          home: SplashScreen(),
        ),
      ),
    );
  }
}