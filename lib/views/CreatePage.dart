import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eventku_app/modal/api.dart';
import 'package:eventku_app/modal/EventModel.dart';
import 'package:eventku_app/views/editEvent.dart';
import 'package:eventku_app/views/tambahEvent.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final money = NumberFormat("#,##0","en_US");
  var loading = false;
  final list = new List<EventModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
  GlobalKey<RefreshIndicatorState>();
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.lihatProduk);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new EventModel(
          api['id'],
          api['namaEvent'],
          api['expDate'],
          api['alamat'],
          api['description'],
          api['tnc'],
          api['image'],
          api['createdDate'],
          api['idUsers'],
          api['username'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Are you sure want to delete this product?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                        onTap: () {
                          _delete(id);
                        },
                        child: Text("Yes")),
                  ],
                )
              ],
            ),
          );
        });
  }

  _delete(String id) async {
    final response =
    await http.post(BaseUrl.deleteProduk, body: {"idProduk": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TambahEvent(_lihatData)));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.blue ),
          child: Text(
            "Create Event",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final x = list[i];
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    'http://beranekaragam.com/eventku/upload/'+x.image,
                    width: 1000.0,
                    height: 180.0,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Event:",style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(
                                x.namaEvent,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10,),
                              Text("Address:",style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(x.alamat),
                              SizedBox(height: 10,),
                              Text("Description:",style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(x.description),
                              SizedBox(height: 10,),
                              Text("Term & Condition:",style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(x.tnc),
                              SizedBox(height: 10,),
                              Text("event time:",style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(x.expDate),
                              Divider(),
                              Text("Created By: "+x.username,style: TextStyle(fontWeight: FontWeight.bold),),
                              Text("event created: "+x.createdDate,style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditEvent(x, _lihatData)));
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogDelete(x.id);
                          },
                          icon: Icon(Icons.delete),
                        )
                      ],
                    ),
                  )

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
