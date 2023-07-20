import 'package:flutter/material.dart';
import 'dart:async';
import 'project_page.dart';

//Main do programa
void main() {
  runApp(ProjectApp());
}

class ProjectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projects',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      // Navegar para a próxima tela após 3 segundos (tempo de exibição da logo)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProjectPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(94, 178, 235, 1.0),
        child: Center(
          child: Image.asset('assets/flow-logo.png'),
        ),
      ),
    );
  }
}
