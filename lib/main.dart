import 'package:brew_crew/screens/wrapper.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/models/user.dart';

const espresso = Color(0xFF171411);
const roast = Color(0xFF28211C);
const cream = Color(0xFFF6F0E7);
const paper = Color(0xFFFFFCF7);
const ember = Color(0xFFE8753D);
const muted = Color(0xFF8B8177);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Brew Crew',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: cream,
          colorScheme: ColorScheme.fromSeed(seedColor: ember, brightness: Brightness.light, surface: paper),
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(backgroundColor: cream, foregroundColor: espresso, elevation: 0, centerTitle: false),
          inputDecorationTheme: InputDecorationTheme(
            filled: true, fillColor: paper, hintStyle: const TextStyle(color: muted),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE8DED2))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: ember, width: 1.5)),
          ),
        ),
        home: Wrapper(),
      ),
    );
  }
}
