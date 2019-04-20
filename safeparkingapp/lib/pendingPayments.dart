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
      elevation: 3.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: 
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    child: Text(
                      "${data["firstName"]} ${data["lastName"]}",
                      style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                       ),
                    ),

                Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        data["contactNum"] == null ? 
                        Text("Contact: None") :
                        Text("Contact: ${data["contactNum"]}"),
                      data["licenseNum"] == null ?
                        Text("License Number: None"):
                        Text("License Number: ${data["licenseNum"]}"),
                      data["boxPlateNum"] == "" ?
                        Text("Box Plate: None") :
                        Text("Box Plate: ${data["boxPlateNum"]}"),
                      data["trailerPlateNum"] == "" ?
                        Text("Trailer Plate: None") :
                        Text("Trailer Plate: ${data["trailerPlateNum"]}"),

                         Padding(
                          padding: EdgeInsets.only(top: 7.0),
                          child: Column(         
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              data["dropffDate"] == null ? 
                                Text("Drop Off Date: None", style:TextStyle(color: Colors.green[700])) :
                                Text("Drop Off Date: ${data["dropOffDate"]}", style:TextStyle(color: Colors.green[700])),
                              data["pickupDate"] == null ?
                                Text("Pick Up Date: None", style:TextStyle(color: Colors.red[700])):
                                Text("Pick Up Date: ${data["pickupDate"]}", style:TextStyle(color: Colors.red[700])),
                              
                            ],
                          ),
                        ),
                      ],                      
                    ),
                  ),   
                ],
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                            icon: Icon(Icons.more_vert),
                            alignment: Alignment.topRight,
                          ),
                    Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.only(right: 15.0),
                      child: RaisedButton(
                        color: Colors.green,
                        child: Text("Pay", style: TextStyle(color: Colors.white),),
                        onPressed: (){},
                      ),
                    )
                    
                  ],
                ),
              )
            ]
          ),
        )
        
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