import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';


class pendingPayments extends StatefulWidget {

  var pending;

  pendingPayments(this.pending, {Key key}):super (key:key);

  @override
  _pendingPaymentsState createState() => _pendingPaymentsState();
}

class _pendingPaymentsState extends State<pendingPayments> {

  Card pendingCard(var data){

    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text("${data["firstName"]} ${data["lastName"]}"),
        subtitle: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Contact: ${data["contactNum"]}"),
                  Text("Trailer Plate: ${data["trailerPlateNum"]}"),
                  Text("Box Plate: ${data["boxPlateNum"]}")
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Contact: ${data["contactNum"]}"),
                  Text("Trailer Plate: ${data["trailerPlateNum"]}"),
                  Text("Box Plate: ${data["boxPlateNum"]}")
                ],
              ),
            ),
           
          ],
        )
                
      ),
      
        
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
        title: Text("Pending Payments"),
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.pending.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return pendingCard(widget.pending.documents[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}