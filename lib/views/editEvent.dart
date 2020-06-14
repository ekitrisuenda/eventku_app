import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:eventku_app/custom/currency.dart';
import 'package:eventku_app/custom/datePicker.dart';
import 'package:eventku_app/modal/api.dart';
import 'package:eventku_app/modal/EventModel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class EditEvent extends StatefulWidget {
  final EventModel model;
  final VoidCallback reload;
  EditEvent(this.model, this.reload);
  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _key = new GlobalKey<FormState>();
  String namaEvent, alamat, description, tnc;


  TextEditingController txtNama, txtAlamat, txtDes, txtTnc;
  String tgldate;
  setup() async{
    tgldate = widget.model.expDate;
    txtNama = TextEditingController(text: widget.model.namaEvent);
    txtAlamat = TextEditingController(text: widget.model.alamat);
    txtDes = TextEditingController(text: widget.model.description);
    txtTnc = TextEditingController(text: widget.model.tnc);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
//    try{
//      var stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
//      var length = await _imageFile.length();
//      var uri = Uri.parse(BaseUrl.editProduk);
//      var request = http.MultipartRequest("POST",uri);

//      request.fields['namaProduk']=namaProduk;
//      request.fields['qty']=qty;
//      request.fields['harga']=harga;
//      request.fields['idUsers']=idUsers;
//      request.fields['idProduk']=widget.model.id;
//      request.fields['expDate']="$tgldate";
//
//      request.files.add(http.MultipartFile("image", stream, length,
//          filename: path.basename(_imageFile.path)));
//      var response = await request.send();
//      if(response.statusCode > 2){
//        print("image upload");
//        setState(() {
//          widget.reload();
//          Navigator.pop(context);
//        });
//      }else{
//        print("image failed");
//      }
//    } catch (e){
//      debugPrint("Error $e");
//    }
//
    final response = await http.post(BaseUrl.editProduk, body: {
      "namaEvent": namaEvent,
      "alamat": alamat,
      "description": description,
      "tnc": tnc,
      "idProduk": widget.model.id,
      "expDate": "$tgldate"
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  String pilihTanggal, labelText;
  DateTime tgl = new DateTime.now();
  var formatTgl = new DateFormat('yyy-MM-dd');
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
        tgldate = formatTgl.format(tgl);
      });
    }else{}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[

            TextFormField(
              controller: txtNama,
              onSaved: (e) => namaEvent = e,
              decoration: InputDecoration(labelText: 'Nama Event'),
            ),
            DateDropDown(
              labelText: labelText,
              valueText: tgldate,
              valueStyle: valueStyle,
              onPressed: (){
                _selectedDate(context);
              },
            ),
            TextFormField(
              controller: txtAlamat,
              onSaved: (e) => alamat = e,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextFormField(
              controller: txtDes,
              onSaved: (e) => description = e,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: txtTnc,
              onSaved: (e) => tnc = e,
              decoration: InputDecoration(labelText: 'Term & Condiiton'),
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
