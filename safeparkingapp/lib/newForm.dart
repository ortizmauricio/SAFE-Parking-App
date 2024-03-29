import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class newForm extends StatefulWidget {
  @override
  _newFormState createState() => _newFormState();
}

class _newFormState extends State<newForm> {

//Controllers for all textfields in the for
  var pickupDate = TextEditingController(text: "");
  var dropOffDate =TextEditingController(text: "");
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var contactNum = TextEditingController(text: "");
  var licenseNum =TextEditingController(text: "");
  var trailerPlateNum = TextEditingController(text: "");
  var boxPlateNum = TextEditingController(text: "");
  var employeeID = TextEditingController();
  var total = 0;
  bool signatureBool = false;
  bool paidBool = false;

//Radio button and function for monthly or non-monthly
//payment options
  int radioValue1 = 0;
  bool showDates = true;

  void handleRadioValueChange(int value){

    setState(() {
      radioValue1 = value;
      if(value == 1)
      {
        showDates = false;
        total = 300;
      }
      else
      {
        showDates = true;
        total = 0;
      }
    });

  }

//Map containing all form data is created and 
//add on firebase 
  void createForm(){

    var data = {
      'total' : total,
      'monthly': !showDates,
      'pickupDate': pickupDate.text,
      'dropOffDate': dropOffDate.text,
      'firstName': firstName.text,
      'lastName': lastName.text,
      'contactNum': contactNum.text,
      'licenseNum': licenseNum.text,
      'trailerPlateNum': trailerPlateNum.text,
      'boxPlateNum': boxPlateNum.text,
      'employee': employeeID.text,
      'paid': paidBool,
      'signature': signatureBool,
    };
      

    final DocumentReference postRef = Firestore.instance.collection("forms").document('safeparking');
    postRef.collection("forms").add(data);
  
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
              title: Text("New Form"),
          ),

          body: Center(
            child: ListView(
              children: <Widget>[

                //Radio buttons for monthly or non-monthly payments
                Row(
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: radioValue1,
                      onChanged: handleRadioValueChange,
                    ),
                    Text("No Monthly Payment"),
                    Radio(
                      value: 1,
                      groupValue: radioValue1,
                      onChanged: handleRadioValueChange,
                    ),
                    Text("Monthly Payment"),
                  ],
                ),

                //ShowDates boolean is determined by radio
                //buttons above. Showdates determines, whether
                //drop off and pickup date entry fields will display
                showDates ?
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
                                labelText: 'Drop Off Date', hasFloatingPlaceholder: false),
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
                                labelText: 'Pick Up Date', hasFloatingPlaceholder: false),
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
                      labelText: "First Name"
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
                      labelText: "Last Name"
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
                      labelText: "Contact Number"
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
                      labelText: "Driver License Number"
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
                      labelText: "Trailer Plate Number"
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
                      labelText: "Box Plate Number"
                    ),
                  ),
                ),

                //Employee Initials and Paid Checkbox
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(15.00),
                          child: TextField(
                            controller: employeeID,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              labelText: "Employee Initials"
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(15.00),
                          child: Row(
                            children: <Widget>[
                              Text("Paid"),
                              Checkbox(
                                value: paidBool,
                                onChanged: (bool value){
                                  setState(() {
                                    paidBool = value;
                                  });
                                },
                              )
                            ],
                          )
                        ),
                      ),
                    ),
                  ],
                ),

                //Digital signature checkbox with corresponding statement
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: signatureBool,
                      onChanged: (bool value){
                        setState(() {
                          signatureBool = value;
                        });
                      },
                    ),
                    Expanded(
                      child: Text("By clicking this checkbox you confirm that all details listed above are true"),
                    )
                  ],
                ),
                
                //Submit button, only works if signature checkbox is true
                Padding(
                  padding: EdgeInsets.only(left: 60.0, right: 60.0),
                  child: RaisedButton(
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white)
                    ),
                    color: Colors.indigo,
                    splashColor: Colors.blueGrey,
                    onPressed: (){
                      if(signatureBool){
                        createForm();
                        Navigator.maybePop(context);
                      }
                      else{
                         signatureAlert();
                      }
                    },
                  )
                )
                
                
            ],
        ),

      ),
    );
   
  }
}