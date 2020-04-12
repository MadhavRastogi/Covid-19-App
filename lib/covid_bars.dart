import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphs/my_covid.dart';



class CovidBarsPage extends StatefulWidget {
  @override
  _CovidBarsPageState createState() {
    return _CovidBarsPageState();
  }
}


class _CovidBarsPageState extends State<CovidBarsPage> {
  List<charts.Series<Covid, String>> _seriesBarData;
  List<Covid> mydata;
  _generateData(mydata) {
    _seriesBarData = List<charts.Series<Covid, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (Covid covid, _) => covid.state,
        measureFn: (Covid covid, _) => covid.deaths,
        colorFn: (Covid covid, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(covid.colorVal))),
        id: 'Covid',
        data: mydata,
        labelAccessorFn: (Covid row, _) => "${row.state}",
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
        stream: Firestore.instance.collection('covid_india').where('deaths',isGreaterThan:10).orderBy('deaths').snapshots(),
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
                'COVID-19 Deaths > 10',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,color: Colors.greenAccent),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(_seriesBarData,
                  animate: true,
                  animationDuration: Duration(seconds:2),
                 /* behaviors: [
                    new charts.DatumLegend(

                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.black,
                          fontFamily: 'Georgia',
                          fontSize: 10),
                    )
                  ],*/
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}