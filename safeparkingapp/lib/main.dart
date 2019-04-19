import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'newForm.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAFE Parking',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'SAFE Parking'),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  Card paymentCard(String title, int count)
  {

    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
          padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.indigo))),
            child: Text("$count",
              style: TextStyle(fontSize: 30, color: Colors.indigo),
            ),
            
          ),
          
          title: Text("$title"),
          trailing: Icon(
            Icons.arrow_forward_ios,
          ),
        ),
      ),
    );

  }

  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: FlatButton(
              child: Text(
                "New Form",
                style: TextStyle(color: Colors.white),
                ),
              highlightColor: Colors.blueGrey,
              color: Colors.indigo[400],
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => newForm()));
              },
                
            )
           
          ),

        ],
      ),
      body: Center(
        
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: Firestore.instance
                .collection('forms')
                .document("safeparking")
                .collection('forms')
                .where('paid', isEqualTo: false)
                .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return paymentCard("Pending Payments", snapshot.data.documents.length);
              },
            ),

            StreamBuilder(
              stream: Firestore.instance
                .collection('forms')
                .document("safeparking")
                .collection('forms')
                .where('paid', isEqualTo: true)
                .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return paymentCard("Completed Payments", snapshot.data.documents.length);
              },
            ),

          ],
        ),
        
      ),
    
    );
  }
}
