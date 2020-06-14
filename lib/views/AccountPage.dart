import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  final VoidCallback signOut;
  AccountPage(this.signOut);
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String username = "", email = "", mobile = "";

  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      email = preferences.getString("email");
      mobile = preferences.getString("mobile");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(title: Text ("Account"),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              setState(() {
                widget.signOut();
              });
            },
            icon: Icon(Icons.lock_open),
          )
        ],),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget>[
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: ClipOval(
                      child: Image.asset("assets/images/placeholder.jpg", fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("$username", style: TextStyle(color: Colors.grey[800], fontFamily: "Roboto", fontSize: 25, ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '$email',
                  prefixIcon: Icon(Icons.email,
                    color: Colors.black,),
                ),
                enabled: false,
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "0$mobile",
                  prefixIcon: Icon(Icons.phone,
                    color: Colors.black,),
                ),
                enabled: false,
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                    borderRadius:BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                    borderRadius:BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  prefixIcon: Icon(Icons.location_on,
                    color: Colors.black,),
                  labelText: "Location",
                  helperText: "Your Location",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );

  }
}