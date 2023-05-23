import 'package:flutter/material.dart';
import 'project_page.dart';

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
      home: ProjectPage(),
    );
  }
}
