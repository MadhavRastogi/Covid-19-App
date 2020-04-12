import 'package:flutter/material.dart';
import 'package:graphs/covid_bars.dart';
import 'package:graphs/covid_home.dart';

void main() {
  runApp(MaterialApp(
     home: MyTabs(),
  ));
}
class MyTabs extends StatefulWidget {
  @override
  _MyTabsState createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin{

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController (vsync: this, length: 2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
           title: Row(
              children: <Widget>[
                 CircleAvatar(
                   backgroundImage:AssetImage('assets/covid.gif'),
                 ),
                 SizedBox(width: 10.0,),
                 Text('COVID_19 India',style: TextStyle(color: Colors.cyanAccent,fontSize: 24.0))
              ],
           ),
           backgroundColor: Colors.redAccent,
           bottom: TabBar(
              controller: _controller,
              tabs: <Tab>[
                 Tab(icon:Icon(Icons.pie_chart)),
                 Tab(icon:Icon(Icons.show_chart))
              ]
           ),
         ),
        body: TabBarView(
           controller: _controller,
           children: <Widget>[
               CovidHomePage(),
              CovidBarsPage()
           ],
        ),
    );
  }
}