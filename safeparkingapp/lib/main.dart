import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'newForm.dart';
import 'pendingPayments.dart';
import 'completedPayments.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAFE Parking',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'SAFE Parking'),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  //Creates layout for card on homepage
  Card paymentCard(String title, int count)
  {

    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
          padding: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
                border:  Border(
                    right: BorderSide(width: 1.0, color: Colors.indigo))),
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

            //Loads data of unpaid forms only and passes data
            //to layout helper funciton, "paymentCard"
            StreamBuilder(
              stream: Firestore.instance
                .collection('forms')
                .document("safeparking")
                .collection('forms')
                .where('paid', isEqualTo: false)
                .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.none: return Text('No connection');
                  case ConnectionState.waiting: return Text('Awaiting information...');
                  case ConnectionState.active: return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => pendingPayments(snapshot.data)));
                    },
                    child: paymentCard("Pending Payments", snapshot.data.documents.length),
                  );
                   case ConnectionState.done: return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => pendingPayments(snapshot.data)));
                    },
                    child: paymentCard("Pending Payments", snapshot.data.documents.length),
                  );
                }                
              },
            ),

            //Loads data of paid forms only and passes data
            //to layout helper funciton, "paymentCard"
            StreamBuilder(
              stream: Firestore.instance
                .collection('forms')
                .document("safeparking")
                .collection('forms')
                .where('paid', isEqualTo: true)
                .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.none: return Text('No connection');
                  case ConnectionState.waiting: return Text('Awaiting information...');
                  case ConnectionState.active: return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => completedPayments(snapshot.data)));
                    },
                    child: paymentCard("Completed Payments", snapshot.data.documents.length),
                  );
                  case ConnectionState.done: return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => completedPayments(snapshot.data)));
                    },
                    child: paymentCard("Completed Payments", snapshot.data.documents.length),
                  );
                }
                              
              },
            ),

          ],
        ),
        
      ),
    
    );
  }
}
