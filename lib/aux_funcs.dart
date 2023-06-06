import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ExampleWidget extends StatefulWidget {
  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  List<dynamic> jsonData = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final jsonString = await rootBundle.loadString('assets/sprint.json');
    final data = jsonDecode(jsonString);
    setState(() {
      jsonData = data['projetos'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(jsonData.toString()),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      home: ExampleWidget(),
    );
  }
}
