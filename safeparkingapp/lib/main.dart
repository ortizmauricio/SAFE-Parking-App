import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  var pickupDate = TextEditingController();
  var dropOffDate =TextEditingController();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var contactNum = TextEditingController();
  var trailerPlateNum = TextEditingController();
  var boxPlateNum = TextEditingController();
  var employeeID = TextEditingController();
  
  bool signatureBool = false;
  bool paidBool = false;

  void createForm(){

    var data = {
      'pickupDate': pickupDate.text,
      'dropOffDate': dropOffDate.text,
      'firstName': firstName.text,
      'lastName': lastName.text,
      'contactNum': int.parse(contactNum.text),
      'trailerPlateNum': int.parse(trailerPlateNum.text),
      'boxPlateNum': int.parse(boxPlateNum.text),
      'employeeID': int.parse(employeeID.text),
      'paid': paidBool,
      'signature': signatureBool,
    };
      

    final DocumentReference postRef = Firestore.instance.collection("forms").document('safeparking');
    postRef.collection("forms").add(data);
  
  }


  final formats = {
    InputType.date: DateFormat('yyyy-MM-dd'),
  };

  

  @override
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

  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                        controller: pickupDate,
                        decoration: InputDecoration(
                            labelText: 'Pickup', hasFloatingPlaceholder: false),
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
                        controller: dropOffDate,
                        decoration: InputDecoration(
                            labelText: 'Dropoff', hasFloatingPlaceholder: false),
                        onChanged: (dt) => setState(() => print(dt)),
                      ),
                    )
                  ),
                )
              ],
            ),

            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: firstName,
                decoration: InputDecoration(
                  labelText: "First Name"
                ),
             ),
            ),

            Padding(
              padding: EdgeInsets.all(15.00),
              child: TextField(
                controller: lastName,
                decoration: InputDecoration(
                  labelText: "Last Name"
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(15.00),
              child: TextField(
                controller: contactNum,
                decoration: InputDecoration(
                  labelText: "Contact Number"
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(15.00),
              child: TextField(
                controller: trailerPlateNum,
                decoration: InputDecoration(
                  labelText: "Trailer Plate Number"
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(15.00),
              child: TextField(
                controller: boxPlateNum,
                decoration: InputDecoration(
                  labelText: "Box Plate Number"
                ),
              ),
            ),

            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(15.00),
                      child: TextField(
                        controller: employeeID,
                        decoration: InputDecoration(
                          labelText: "Employee ID"
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
            

            RaisedButton(
              child: Text(
                "Add",
                style: TextStyle(color: Colors.white)
              ),
              color: Colors.blue,
              onPressed: (){
                signatureBool?createForm(): signatureAlert();
                
              },
            )

            
          ],
        ),
      ),
    
    );
  }
}
