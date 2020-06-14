import 'dart:convert';
import 'package:eventku_app/modal/EventModel.dart';
import 'package:eventku_app/modal/api.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;

class DetailEvent extends StatefulWidget {
  final EventModel model;
  DetailEvent(this.model);
  @override
  _DetailEventState createState() => _DetailEventState();
}

class _DetailEventState extends State<DetailEvent> {
  var loading = false;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceModel;
  String idEvent;

  getDeviceInfo()async{
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}');  // e.g. "Moto G (4)"
    setState(() {
      deviceModel = androidInfo.id;
      idEvent = widget.model.id;
    });
  }

  addFavorite()async{
    setState(() {
      loading = true;
    });
    final response = await http.post(BaseUrl.addFavoriteWithoutLogin, body: {
      "deviceInfo" : deviceModel,
      "idEvent" : idEvent,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value==1){
      print(message);
      setState(() {
        loading = false;
      });
    }else{
      print(message);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text ("Event")),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 230,
                    padding: EdgeInsets.only(right: 10, left: 10, top: 10),
                    child: Image.network('http://beranekaragam.com/eventku/upload/'+widget.model.image,fit: BoxFit.cover,width: 1000.0),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(widget.model.namaEvent.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    addFavorite();
                                  });
                                },
                                icon: Icon(Icons.favorite_border, size: 35,),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.calendar_today, size: 15,),
                              ),
                              Text(widget.model.expDate,style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.location_on, size: 15,),
                              ),
                              Text(widget.model.alamat,style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),

                        SizedBox(height: 30,),
                        Text('Description',style: TextStyle(fontWeight: FontWeight.bold),),
                        Divider(),
                        Text(widget.model.description),
                        SizedBox(height: 30,),
                        Text('Term & Conditions',style: TextStyle(fontWeight: FontWeight.bold),),
                        Divider(),
                        Text(widget.model.tnc),
                        SizedBox(height: 30,),
                        Divider(),
                        Text("Created By: "+widget.model.username,style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("event created:  "+widget.model.createdDate,style: TextStyle(fontWeight: FontWeight.bold),),
                         ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/white.jpg'),
                      fit: BoxFit.fill
                  )
              ),
              padding: EdgeInsets.all(10.0),
              child: Material(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
                child: MaterialButton(
                  onPressed: (){},
                  child: Text(
                    "Join The Event",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),

    );
  }
}
