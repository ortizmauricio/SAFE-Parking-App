import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'editEntry.dart';


class pendingPayments extends StatefulWidget {

  var pending;

  pendingPayments(this.pending, {Key key}):super (key:key);

  @override
  _pendingPaymentsState createState() => _pendingPaymentsState();
}

class _pendingPaymentsState extends State<pendingPayments> {
  

//Deletes current card via delete option
  void deleteItem(var data) async{
    await Firestore.instance.runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(data.reference);
    });
  }

  
//Marks entry as paid on firebase
void markAsPaid(var data, var total){
  Firestore.instance
    .collection("forms")
    .document("safeparking")
    .collection("forms")
    .document(data.documentID)
    .updateData(
      {
        "paid" : true,
        "total" :total
      }
    );
}

//Calculates difference in days between drop off
//and pickup date
  int calculateDays(var data){
    DateTime start = DateTime.parse(data["dropOffDate"]);
    DateTime end;
    if(data["pickupDate"] == ""){
      end =DateTime.now();
    }
    else{
      end = DateTime.parse(data["pickupDate"]);
    }
    
    int difference = end.difference(start).inDays;
    
    return difference == 0 ? 1:difference;

  }
  
//Completes pending payment and moves entry to
//'Complete Payments"
  void pay(var data){

    var totalDays = calculateDays(data);
    var lastDay;
    data["pickupDate"] == "" ? lastDay = "Today" : lastDay = data["pickupDate"];

    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Payment"),
          content: Container(
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Are all details correct?"),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Name: ${data["firstName"]} ${data["lastName"]}"),
                        Text("Dates: ${data["dropOffDate"]} - $lastDay"),
                        Text("Total Days: ${totalDays}"),

                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            "Total: \$${totalDays * 10}",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold),),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text(
                "Confirm",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                markAsPaid(data, (totalDays  * 10));
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => editEntry(data)))
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
                              data["dropOffDate"] == null ? 
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
                        onPressed: (){
                          pay(data);
                        },
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