import 'dart:convert';

import 'package:eventku_app/modal/api.dart';
import 'package:eventku_app/modal/EventModel.dart';
import 'package:eventku_app/views/SearchEvent.dart';
import 'package:eventku_app/views/detailEvent.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String idUsers;

  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    _lihatData();
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.notifications),
          )
        ],
        title: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchEvent()
            ));
          },
          child: Container(
            height: 45,
            alignment: Alignment.center,
            padding: EdgeInsets.all(4),
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                enabled: false,
                fillColor: Colors.white,
                filled: true,
                hintText: "Search Eventku",
                suffixIcon: IconButton(onPressed: (){},
                icon: Icon(Icons.search),)
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        key: _refresh,
        onRefresh: _lihatData,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i){
            final x = list[i];
            return Padding(
              padding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=>DetailEvent(x)
                  ));
                },
                child: Container(
                  child: Card(
                    elevation: 2.0,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        new ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: new Radius.circular(16.0),
                            topRight: new Radius.circular(16.0),
                          ),

                          child: Container(
                            height: 180,
                            child: Hero(
                              tag: x.id,
                              child: Image.network(
                                'http://beranekaragam.com/eventku/upload/'+x.image,
                                  fit: BoxFit.cover,width: 1000.0
                              ),
                            ),
                          ),

                        ),
                        new Padding(
                          padding: new EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                x.namaEvent.toUpperCase(),
                                style: TextStyle(
                                  fontWeight:FontWeight.bold, color: Colors.blue
                                ),
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              )
                            ],
                          ),)
                      ],
                    ),

                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

  }
}
