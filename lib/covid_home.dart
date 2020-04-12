import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphs/my_covid.dart';

class CovidHomePage extends StatefulWidget {
  @override
  _CovidHomePageState createState() {
    return _CovidHomePageState();
  }
}

class _CovidHomePageState extends State<CovidHomePage> {
  List<charts.Series<Covid, String>> _seriesPieData;
  List<Covid> mydata;
  _generateData(mydata) {
    _seriesPieData = List<charts.Series<Covid, String>>();
    _seriesPieData.add(
      charts.Series(
        domainFn: (Covid covid, _) => covid.state,
        measureFn: (Covid covid, _) => covid.deaths,
        colorFn: (Covid covid, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(covid.colorVal))),
        id: 'covid',
        data: mydata,
        labelAccessorFn: (Covid row, _) => "${row.deaths}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.cyan[800],Colors.white]
          )
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('covid_india').orderBy('deaths',descending:true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          } else {
            List<Covid> covid = snapshot.data.documents
                .map((documentSnapshot) => Covid.fromMap(documentSnapshot.data))
                .toList();
            return _buildChart(context, covid);
          }
        },
      ),
    );
  }
  Widget _buildChart(BuildContext context, List<Covid> coviddata) {
    mydata = coviddata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'COVID-19 State wise Deaths',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,color: Colors.greenAccent),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 3),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                        charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 6,
                        desiredMaxColumns:3,
                        cellPadding:
                        new EdgeInsets.only(right: 4.0, bottom: 4.0,top: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.black,
                            fontFamily: 'Georgia',
                            fontSize: 13),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}