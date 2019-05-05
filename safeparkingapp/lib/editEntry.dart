import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class editEntry extends StatefulWidget {
  var entryInfo;

  editEntry(this.entryInfo, {Key key}):super (key: key);

  @override
  _editEntryState createState() => _editEntryState();
}

class _editEntryState extends State<editEntry> {

//Controllers for all textfields in the form
  var pickupDate = TextEditingController(text: "");
  var dropOffDate = TextEditingController(text: "");
  var firstName = TextEditingController(text: "");
  var lastName = TextEditingController(text: "");
  var contactNum = TextEditingController(text: "");
  var licenseNum =TextEditingController(text: "");
  var trailerPlateNum = TextEditingController(text: "");
  var boxPlateNum = TextEditingController(text: "");



//Update entry on firebase
  void updateForm(var data){


    Map<String, dynamic> updatedInfo = {};

    if(pickupDate.text != "") updatedInfo["pickupDate"] = pickupDate.text;
    if(dropOffDate.text != "") updatedInfo["dropOffDate"] = dropOffDate.text;
    if(firstName.text != "") updatedInfo["firstName"] = firstName.text;
    if(lastName.text != "") updatedInfo["lastName"] = lastName.text;
    if(contactNum.text != "") updatedInfo["contactNum"] = contactNum.text;
    if(trailerPlateNum.text != "") updatedInfo["trailerPlateNum"] = trailerPlateNum.text;
    if(boxPlateNum.text != "") updatedInfo["boxPlateNum"] = boxPlateNum.text;


    Firestore.instance
    .collection("forms")
    .document("safeparking")
    .collection("forms")
    .document(data.documentID)
    .updateData(
      
      updatedInfo
    
    );
  
  }

//Date Format is set
  final formats = {
    InputType.date: DateFormat('yyyy-MM-dd'),
  };

  
  @override

//Alert Dialog for when user does not 
//complete digital signature checkbox
  void signatureAlert(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Missing confirmation"),
          content: Text("Form cannot be submitted unless driver signs"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: new AppBar(
            leading: new IconButton(
                icon: new Icon(Icons.close),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
              title: Text("Edit Entry"),
          ),

          body: Center(
            child: ListView(
              children: <Widget>[


                //ShowDates boolean is determined by radio
                //buttons above. Showdates determines, whether
                //drop off and pickup date entry fields will display
                !widget.entryInfo["monthly"] ?
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: DateTimePickerFormField(
                            inputType: InputType.date,
                            format: formats[InputType.date],
                            editable: true,
                            controller: dropOffDate,
                            decoration: InputDecoration(
                                labelText: widget.entryInfo["dropOffDate"], hasFloatingPlaceholder: false),
                            onChanged: (dt) => setState(() => print(dt)),
                          ),
                        )
                      ),
                    ),

                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: DateTimePickerFormField(
                            inputType: InputType.date,
                            format: formats[InputType.date],
                            editable: true,
                            controller: pickupDate,
                            decoration: InputDecoration(
                                labelText: widget.entryInfo["pickupDate"] == ""?
                                'Pickup Date': widget.entryInfo["pickupDate"], hasFloatingPlaceholder: false),
                            onChanged: (dt) => setState(() => print(dt)),
                          ),
                        )
                      ),
                    )
                  ],
                ): Container(),

                //First Name 
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: firstName,
                    autofocus: true,
                    decoration: InputDecoration(
                      helperText: "First Name",
                      hintText: widget.entryInfo["firstName"].toString()
                    ),
                ),
                ),

                //Last Name
                Padding(
                  padding: EdgeInsets.all(15.00),
                  child: TextField(
                    controller: lastName,
                    autofocus: true,
                    decoration: InputDecoration(
                      helperText: "Last Name",
                      hintText: widget.entryInfo["lastName"].toString()
                    ),
                  ),
                ),

                //Contact Number
                Padding(
                  padding: EdgeInsets.all(15.00),
                  child: TextField(
                    controller: contactNum,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      helperText: "Contact Number",
                      hintText: widget.entryInfo["contactNum"].toString()
                    ),
                  ),
                ),

                //License Number
                Padding(
                  padding: EdgeInsets.all(15.00),
                  child: TextField(
                    controller: licenseNum,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      helperText: "Driver License Number",
                      hintText: widget.entryInfo["licenseNum"].toString()
                    ),
                  ),
                ),

                //Trailer Plate Number
                Padding(
                  padding: EdgeInsets.all(15.00),
                  child: TextField(
                    controller: trailerPlateNum,
                    textCapitalization: TextCapitalization.characters,
                    autofocus: true,
                    decoration: InputDecoration(
                      helperText: "Trailer Plate Number",
                      hintText: widget.entryInfo["trailerPlateNum"].toString()
                    ),
                  ),
                ),

                //Box Plate Number
                Padding(
                  padding: EdgeInsets.all(15.00),
                  child: TextField(
                    controller: boxPlateNum,
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      helperText: "Box Plate Number",
                      hintText: widget.entryInfo["boxPlateNum"].toString()
                    ),
                  ),
                ),

                
                //Submit button, only works if signature checkbox is true
                Padding(
                  padding: EdgeInsets.only(left: 60.0, right: 60.0),
                  child: RaisedButton(
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.white)
                    ),
                    color: Colors.indigo,
                    splashColor: Colors.blueGrey,
                    onPressed: (){
                      updateForm(widget.entryInfo);
                      Navigator.maybePop(context);
                    },
                  )
                )
                
                
            ],
        ),

      ),
    );
   
  }
}