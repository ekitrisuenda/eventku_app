import 'dart:convert';

import 'package:eventku_app/modal/api.dart';
import 'package:eventku_app/modal/EventModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detailEvent.dart';

class SearchEvent extends StatefulWidget {
  @override
  _SearchEventState createState() => _SearchEventState();
}

class _SearchEventState extends State<SearchEvent> {

  final money = NumberFormat("#,##0","en_US");


  var loading = false;
  List<EventModel> list = [];
  List<EventModel> listSeacrh = [];

  lihatEvent() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(BaseUrl.lihatProduk);
    if (response.statusCode == 200) {
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
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    lihatEvent();
  }

  Future<void>onRefresh()async{
    lihatEvent();
  }



  TextEditingController searchController = TextEditingController();

  onSearch(String text)async {
    listSeacrh.clear( );
    if (text.isEmpty) {
      setState( () {

      } );
    }
    list.forEach((a){
      if (a.namaEvent.toLowerCase().contains(text))
        listSeacrh.add(a);
    });

    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 45,
          alignment: Alignment.center,
          padding: EdgeInsets.all(4),
          child: TextField(
            controller: searchController,
            onChanged: onSearch,
            autofocus: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Search Eventku",
                suffixIcon: IconButton(onPressed: (){},
                  icon: Icon(Icons.search),)
            ),
          ),
        ),
      ),
      body: Container(
        child: loading ? Center(child: CircularProgressIndicator(),) : searchController.text.isNotEmpty || listSeacrh.length !=0 ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
          ),
          itemCount: listSeacrh.length,
          itemBuilder: (context, i){
            final x = listSeacrh[i];
            return Padding(
              padding: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=>DetailEvent(x)
                  ));
                },
                child: Card(
                  elevation: 2.0,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Hero(
                          tag: x.id,
                          child: Image.network(
                            'http://beranekaragam.com/bisnis/upload/'+x.image,
                          ),
                        ),
                      ),
                      Text(x.namaEvent, textAlign: TextAlign.center,),
                      SizedBox(
                        height: 10.0,
                      )
                    ],
                  ),
                ),
              ),
            );
          },

        ) : Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Please Search your item product", textAlign: TextAlign.center,)
            ],
          ),
        )
      ),
    );
  }
}
