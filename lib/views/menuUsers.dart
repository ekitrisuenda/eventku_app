import 'dart:convert';

import 'package:eventku_app/modal/api.dart';
import 'package:eventku_app/modal/keranjangModel.dart';
import 'package:eventku_app/modal/EventModel.dart';
import 'package:eventku_app/views/detailEvent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Admin extends StatefulWidget {
  final VoidCallback signOut;
  Admin(this.signOut);
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: (){
              setState(() {
                widget.signOut();
              });
            },
            icon: Icon(Icons.lock_open),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text("Eventku")
          ],
        ),
      ),
    );
  }
}
