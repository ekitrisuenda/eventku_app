import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:eventku_app/custom/currency.dart';
import 'package:eventku_app/custom/datePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:eventku_app/modal/api.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;


class TambahEvent extends StatefulWidget {
  final VoidCallback reload;
  TambahEvent(this.reload);
  @override
  _TambahEventState createState() => _TambahEventState();
}

class _TambahEventState extends State<TambahEvent> {
  String namaEvent, alamat, description, tnc, idUsers;
  final _key = new GlobalKey<FormState>();
  File _imageFile;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  _pilihGallery() async{
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1920.0,
        maxWidth: 1080.0
    );
    setState(() {
      _imageFile = image;
    });
  }

  _pilihKamera() async{
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1920.0,
        maxWidth: 1080.0
    );
    setState(() {
      _imageFile = image;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    try{
      var stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.tambahProduk);
      var request = http.MultipartRequest("POST",uri);
      request.fields['namaEvent']=namaEvent;
      request.fields['alamat']=alamat;
      request.fields['description']=description;
      request.fields['tnc']=tnc;
      request.fields['idUsers']=idUsers;
      request.fields['expDate']="$tgl";

      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if(response.statusCode > 2){
        print("image upload");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      }else{
        print("image failed");
      }
    } catch (e){
      debugPrint("Error $e");
    }
  }
  String pilihTanggal, labelText;
  DateTime tgl = new DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  Future<Null> _selectedDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(1992),
        lastDate: DateTime(2099));

    if(picked != null && picked != tgl){
      setState(() {
        tgl = picked;
        pilihTanggal = new DateFormat.yMd().format(tgl);
      });
    }else{}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('assets/images/placeholder.jpg'),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
        width: double.infinity,
              height: 150.0,
              child: InkWell(
                onTap: (){
                  _pilihKamera();
                },
                child:
                  _imageFile == null ? placeholder : Image.file(_imageFile, fit: BoxFit.fill,),
              ),
            ),
            TextFormField(
              onSaved: (e) => namaEvent = e,
              decoration: InputDecoration(labelText: 'Nama Event'),
            ),
            DateDropDown(
              labelText: labelText,
              valueText: new DateFormat.yMd().format(tgl),
              valueStyle: valueStyle,
              onPressed: (){
                _selectedDate(context);
              },
            ),
            TextFormField(
              onSaved: (e) => alamat = e,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextFormField(
              onSaved: (e) => description = e,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              onSaved: (e) => tnc = e,
              decoration: InputDecoration(labelText: 'Term & Condition'),
            ),


            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
