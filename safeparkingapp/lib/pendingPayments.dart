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
  

//Deletes current card via delete option
  deleteItem(var data) async{
    await Firestore.instance.runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(data.reference);
    });
  }


//Pop up menu on every card
PopupMenuButton optionsMenu(var data){
  return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text("Edit"),
            ),
            PopupMenuItem(
              value: 2,
              child: Text("Delete"),
            ),
          ],

          onSelected: (value){
            value == 1 ?
              print("Edit item")
            :deleteItem(data);
          },
    );
}

//Creates card containing driver information, options to edit, delete
//or mark entry as paid.
  Card pendingCard(var data){
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Everything on the left side of the card
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Driver Name
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
                  //Driver information
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

                        //Dropoff and Pickup dates for truck
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

              //Everything on the right side of the card
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    //Options menu 
                    optionsMenu(data),

                    //Pay button
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

          //List View for all unpaid driver entries 
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance
              .collection("forms")
              .document("safeparking")
              .collection("forms")
              .where('paid', isEqualTo: false)
              .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return pendingCard(snapshot.data.documents[index]);
                  },
                );
              },
            )
          )
        ],
      ),
    );
  }
}