import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';


class pendingPayments extends StatefulWidget {


  @override
  _pendingPaymentsState createState() => _pendingPaymentsState();
}

class _pendingPaymentsState extends State<pendingPayments> {
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
    );
  }
}