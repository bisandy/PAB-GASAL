import 'package:flutter/material.dart';
import 'package:uas_gasal/navbar/SplashScreen.dart';
import 'package:uas_gasal/auth/login.dart';
import 'package:uas_gasal/pages/tambahDosen.dart';
import 'package:uas_gasal/pages/tambahUser.dart';
import 'package:uas_gasal/pages/tambahBuku.dart';
import 'package:uas_gasal/pages/tampilanUser.dart';
import 'package:uas_gasal/pages/tampilanDosen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xFF181e38)),
        scaffoldBackgroundColor: Colors.white, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/login': (context) => Login(),
        '/penguna': (context) => DisplayUserPage(),
        '/dosen': (context) => DisplayDosenPage(),
        '/tambahbuku': (context) => AddBookPage(),
        '/tambahpenguna': (context) => AddUserPage(),
        '/tambahdosen': (context) => AddDosenPage(),
      },
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List<int> strengths = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
  Map<int, Color> swatch = <int, Color>{};
  final int primary = color.value;

  for (int i = 0; i < 10; i++) {
    final int strength = strengths[i];
    final double blend = i / 10.0;
    swatch[strength] = Color.lerp(Colors.white, color, blend)!;
  }

  return MaterialColor(primary, swatch);
}