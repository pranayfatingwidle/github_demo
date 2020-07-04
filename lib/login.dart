import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pranayfatingdemo/api.dart';
import 'package:pranayfatingdemo/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_Screen extends StatefulWidget {




  const Login_Screen({Key key}) : super(key: key);

  ThemeData buildTheme() {
    final ThemeData base = ThemeData();
    return base.copyWith(
      hintColor: Colors.red,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
            color: Colors.yellow,
            fontSize: 24.0
        ),
      ),
    );
  }
  @override
  State<StatefulWidget> createState() => login();
}

class login extends State<Login_Screen> {

  ShapeBorder shape;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autovalidate = false;
  bool _formWasEdited = false;
  bool _loading = false;

  final TextEditingController _emailControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();

  API api = new API();



  authenticateUser() async {
    setState(() {
      _loading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var response =  await api.getAsync("https://api.github.com/users/${_emailControl.text}", _emailControl.text, _passwordControl.text);
    if(response[0].statusCode != 200){
      print("Invalid Credentils");
      preferences.setBool("login",false);
      _loading = false;

    }else{
          preferences.setBool("login",true);
          preferences.setString("token",response[1]);

          var decodedJson = jsonDecode(response[0].body);
          print(decodedJson["login"]);
          await preferences.setString("username", decodedJson["login"]);
          await preferences.setString("avatar_url", decodedJson["avatar_url"]);
          await preferences.setString("html_url", decodedJson["html_url"]);
          await preferences.setString("location", decodedJson["location"]);
          await preferences.setInt("public_repos", decodedJson["public_repos"]);
          await preferences.setInt("followers", decodedJson["followers"]);
          await preferences.setInt("following", decodedJson["following"]);
      _loading = false;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Home_page()));
    }



  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    // _loading_info = new ProgressDialog(context,type: ProgressDialogType.Normal);
    // _loading_info.style(
    //       message: 'Loading...',
    //       // borderRadius: 10.0,
    //       backgroundColor: Colors.white,
    //       progressWidget:  Container(
    //         padding: EdgeInsets.all(15.0),
    //                  height: 40,width: 40, child: CircularProgressIndicator()),
          
    //        insetAnimCurve: Curves.bounceIn,
    //       // messageTextStyle: TextStyle(
    //       //     color: Colors.white.withOpacity(0.6), fontSize: 16.0,),
    //     );
    bool _obscureText = true;
    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: Text('Github Demo', style: TextStyle(fontWeight: FontWeight.bold)),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: new SingleChildScrollView(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                
                new SafeArea(

                    top: false,
                    bottom: false,
                    child: Card(
                        elevation: 5.0,
                        child: Form(
                            key: formKey,
                            autovalidate: _autovalidate,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    const SizedBox(height: 24.0),
                                    TextFormField(
                                      controller: _emailControl,
                                      decoration: const InputDecoration(
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                          ),
                                          focusedBorder:  UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                          ),
                                          icon: Icon(Icons.email,color: Colors.black38,),
                                          hintText: 'Your Username',
                                          labelText: 'Username',
                                          labelStyle: TextStyle(color: Colors.black54)
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                     
                                      onSaved: (val) => _email = val,
                                    ),

                                    const SizedBox(height: 24.0),
                                    TextFormField(
                                      controller: _passwordControl,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                          ),
                                          focusedBorder:  UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                          ),
                                          icon: Icon(Icons.lock,color: Colors.black38,),
                                          hintText: 'Your password',
                                          labelText: 'Password',
                                          labelStyle: TextStyle(color: Colors.black54)
                                      ),

                                      validator: (val) =>
                                      val.length < 6 ? 'Password too short.' : null,
                                      onSaved: (val) => _password = val,
                                    ),

                                    SizedBox(height: 35.0,),
                                    new Container(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[

                                          new Container(
                                            alignment: Alignment.bottomRight,
                                            child: _loading?Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                                        ),
                                      ): new GestureDetector(
                                              onTap: () async {
                                                  // _submit();
                                                // await FirebaseAuth.instance.signOut();
                                                authenticateUser();
                                              },
                                              child: Text('LOGIN',style: TextStyle(
                                                  color: Colors.blue,fontSize: 20.0,fontWeight: FontWeight.bold
                                              ),),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  
                                  ]
                              ),
                            )

                        )        //login,
                    )),
              
              ],
            ),
          )
        ));
  }




  }
