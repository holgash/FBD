import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:math';

class LinearCharts extends StatefulWidget {
  final int id;

  const LinearCharts({Key? key, required this.id}) : super(key: key);

  @override
  _LinearChartsState createState() => _LinearChartsState();
}

class _LinearChartsState extends State<LinearCharts> {
  List<Expenses> data = [];

  @override
  void initState() {
    super.initState();
    readJsonData().then((jsonData) {
      setState(() {
        // Buscar o item correto com base no valor de widget.id
        final item = jsonData['projetos']
            .firstWhere((projeto) => projeto['id'] == widget.id);

        // Ler os dados do JSON e converter para a lista de Expenses
        data = List<Expenses>.from(item['dados'].map(
            (item) => Expenses(item['sprint'] as int, item['score'] as int)));
      });
    });
  }

  Future<dynamic> readJsonData() async {
    String jsonData = await rootBundle.loadString('assets/sprint.json');
    return jsonDecode(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Expenses, int>> series = [
      charts.Series<Expenses, int>(
        id: 'Lineal',
        domainFn: (v, i) => v.day,
        measureFn: (v, i) => v.expense,
        data: data,
      )
    ];

    return Center(
      child: SizedBox(
        height: 350.0,
        child: charts.LineChart(
          series,
          primaryMeasureAxis: charts.NumericAxisSpec(
            viewport:
                charts.NumericExtents(0, 100), // Definir o intervalo de 0 a 100
          ),
        ),
      ),
    );
  }
}

class Expenses {
  final int day;
  final int expense;

  Expenses(this.day, this.expense);
}

class MySymbolRenderer extends charts.CircleSymbolRenderer {
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      charts.Color? fillColor,
      charts.FillPatternType? fillPattern,
      charts.Color? strokeColor,
      double? strokeWidthPx,
      double? radius}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
  }
}

void main() {
  runApp(
    MaterialApp(
      title: 'Linear Charts Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Linear Charts Example'),
        ),
        body: LinearCharts(id: 0),
      ),
    ),
  );
}
