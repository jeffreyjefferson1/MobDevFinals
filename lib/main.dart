import 'package:todd_flutter_app/routes.dart';
import 'package:todd_flutter_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    title: 'Toddelicious Recipes',
    theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
    themeMode: ThemeMode.light, 
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
    routes: routes,
  ));
}