import 'dart:convert';
import 'dart:math';

import 'package:eventku_app/views/menuUsers.dart';
import 'package:flutter/material.dart';
import 'package:eventku_app/modal/api.dart';
import 'package:eventku_app/views/HomePage.dart';
import 'package:eventku_app/views/SearchPage.dart';
import 'package:eventku_app/views/CreatePage.dart';
import 'package:eventku_app/views/AccountPage.dart';
import 'package:eventku_app/views/FavoritePage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Animation/FadeAnimation.dart';
import 'SplashScreen.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus{
  notSignIn,
  signIn,
  signInUsers
}

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;


  String email, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide(){
    setState(() {
      _secureText = !_secureText;
    });
  }

  var _autovalidate = false;
  check(){
    final form = _key.currentState;
    if (form.validate()){
      form.save();
      login();
    }else{
      setState(() {
        _autovalidate = true;
      });
    }
  }

  login() async{
    final response = await http.post(BaseUrl.login, body: {
      "email" : email,
      "password" : password
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String emailAPI = data['email'];
    String mobileAPI = data['mobile'];
    String id = data['id'];
    String level = data['level'];
    if(value==1){
      if(level == "1"){
        setState(() {
          _loginStatus = LoginStatus.signIn;
          savePref(value, usernameAPI, emailAPI, mobileAPI, id, level);
        });
      }else{
        setState(() {
          _loginStatus = LoginStatus.signInUsers;
          savePref(value, usernameAPI, emailAPI, mobileAPI, id, level);
        });
      }
      print(pesan);
    } else{
      print(pesan);
    }
  }

  savePref(int value, String username, String email, String mobile, String id, String level)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("username", username);
      preferences.setString("email", email);
      preferences.setString("mobile", mobile);
      preferences.setString("id", id);
      preferences.setString("level", level);
      preferences.commit();
    });
  }


  var value;
  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("level");

      _loginStatus = value == "1"
          ? LoginStatus.signIn
          : value == "2" ? LoginStatus.signInUsers : LoginStatus.notSignIn;
    });
  }

  signOut() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("level", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
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
    switch (_loginStatus){
      case LoginStatus.notSignIn:
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 330,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.fill
                        )
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 30,
                          top: 25,
                          width: 80,
                          height: 120,
                          child: FadeAnimation(1, Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/awan-1.png')
                                )
                            ),
                          )),
                        ),
                        Positioned(
                          left: 140,
                          width: 80,
                          height: 120,
                          child: FadeAnimation(1.3, Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/awan-2.png')
                                )
                            ),
                          )),
                        ),
                        Positioned(
                          right: 40,
                          top: 25,
                          width: 80,
                          height: 120,
                          child: FadeAnimation(1.5, Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/awan-3.png')
                                )
                            ),
                          )),
                        ),
                        Positioned(
                          top: 250,
                          width: 80,
                          height: 80,
                          child: FadeAnimation(2.1, Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/orang.png')
                                )
                            ),
                          )),
                        ),
                        Positioned(
                          left: 140,
                          top: 220,
                          width: 80,
                          height: 20,
                          child: FadeAnimation(2.2, Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/sinyal-1.png')
                                )
                            ),
                          )),
                        ),
                        Positioned(
                          right: 1,
                          top: 250,
                          width: 80,
                          height: 15,
                          child: FadeAnimation(2.3, Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/sinyal-2.png')
                                )
                            ),
                          )),
                        ),
                        Positioned(
                          top: 10,
                          left: 110,
                          width: 150,
                          height: 250,
                          child: FadeAnimation(1.3, Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/Untitled-1.png')
                                )
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child: Form(
                        key: _key,
                        autovalidate: _autovalidate,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            //card for Email TextFormField
                            Card(
                              elevation: 6.0,
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Please Insert Email";
                                  } else{
                                    if (!e.contains("@")) {
                                      return "Wrong format email";
                                    } else{
                                      return null;
                                    }
                                  }
                                },
                                onSaved: (e) => email = e,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding:
                                      EdgeInsets.only(left: 20, right: 15),
                                      child:
                                      Icon(Icons.person, color: Colors.black),
                                    ),
                                    contentPadding: EdgeInsets.all(18),
                                    labelText: "Email"),
                              ),
                            ),

                            // Card for password TextFormField
                            Card(
                              elevation: 6.0,
                              child: TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Password Can't be Empty";
                                  }else{
                                    if(e.length<8){
                                      return "Minimal password 8 character";
                                    }else{
                                      return null;
                                    }
                                  }
                                },
                                obscureText: _secureText,
                                onSaved: (e) => password = e,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(left: 20, right: 15),
                                    child: Icon(Icons.phonelink_lock,
                                        color: Colors.black),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: showHide,
                                    icon: Icon(_secureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  contentPadding: EdgeInsets.all(18),
                                ),
                              ),
                            ),

                            FadeAnimation(1.5, Container(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                onPressed: null,
                                child: Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
                              ),
                            )),

                            FadeAnimation(2,ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width,
                              child: new Container(
                                child: new RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),

                                  onPressed: () {
                                    check();
                                  },

                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  child: Text(
                                    "Login",
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                ),
                              ),
                            )),
                            SizedBox(height: 5,),
                            Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Divider()
                                  ),

                                  Text("OR"),

                                  Expanded(
                                      child: Divider()
                                  ),
                                ]
                            ),
                            FadeAnimation(2,ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width,
                              child: new Container(
                                child: new RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),

                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  child: Text(
                                    "Login With Facebook",
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                ),
                              ),
                            )),
                            FadeAnimation(1.5,
                              FlatButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()),
                                  );
                                },
                                child: Text("New User? Sign Up",
                                  style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
      case LoginStatus.signInUsers:
        return Admin(signOut);
        break;
    }

  }
}


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String username, email, mobile, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide(){
    setState(() {
      _secureText = !_secureText;
    });
  }

  var validate = false;
  check(){
    final form = _key.currentState;
    if (form.validate()){
      form.save();
      save();
    }else{
      setState(() {
        validate = true;
      });
    }
  }

  save()async{
    final response = await http.post(BaseUrl.register, body:{
      "username" : username,
      "email" : email,
      "mobile" : mobile,
      "password" : password
    });

    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if ( value==1){
      setState(() {
        Navigator.pop(context);
      });
    } else{
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 330,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.fill
                    )
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      top: 35,
                      width: 80,
                      height: 120,
                      child: FadeAnimation(1, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/awan-1.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 120,
                      child: FadeAnimation(1.3, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/awan-2.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      right: 40,
                      top: 25,
                      width: 80,
                      height: 120,
                      child: FadeAnimation(1.5, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/awan-3.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      top: 250,
                      width: 80,
                      height: 80,
                      child: FadeAnimation(2.1, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/orang.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      left: 140,
                      top: 220,
                      width: 80,
                      height: 20,
                      child: FadeAnimation(2.2, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/sinyal-1.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      right: 1,
                      top: 250,
                      width: 80,
                      height: 15,
                      child: FadeAnimation(2.3, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/sinyal-2.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      top: 10,
                      left: 110,
                      width: 150,
                      height: 250,
                      child: FadeAnimation(1.3, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/Untitled-1.png')
                            )
                        ),
                      )),
                    ),
                  ],
                ),
              ),

              Center(
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Form(
                    key: _key,
                    autovalidate: validate,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert username";
                              }
                            },
                            onSaved: (e) => username = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.person, color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Username"),
                          ),
                        ),
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please Insert Email";
                              } else{
                                if (!e.contains("@")) {
                                  return "Wrong format email";
                                } else{
                                  return null;
                                }
                              }
                            },
                            onSaved: (e) => email = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.email, color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Email"),
                          ),
                        ),
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert Mobile Number";
                              }
                            },
                            onSaved: (e) => mobile = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.phone, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Mobile Number",
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert Password";
                              }else{
                                if(e.length<8){
                                  return "Minimal password 8 character";
                                }else{
                                  return null;
                                }
                              }
                            },
                            obscureText: _secureText,
                            onSaved: (e) => password = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: showHide,
                                  icon: Icon(_secureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.phonelink_lock,
                                      color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Password"),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(5.0),
                        ),

                        FadeAnimation(2,ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width,

                          child: new Container(
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Text(
                                  "Register",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                textColor: Colors.white,
                                color: Colors.blue,
                                onPressed: () {
                                  check();
                                }),
                          ),
                        ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut(){
    setState(() {
      widget.signOut();
    });
  }

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
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: TabBarView(
          children: <Widget>[
            HomePage(),
            SearchPage(),
            CreatePage(),
            FavoritePage(),
            AccountPage(signOut)
          ],
        ),
        bottomNavigationBar: TabBar(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.search),
            ),
            Tab(
              icon: Icon(Icons.add_box),
            ),
            Tab(
              icon: Icon(Icons.favorite),
            ),
            Tab(
              icon: Icon(Icons.account_circle),
            ),
          ],
        ),
      ),
    );
  }
}

