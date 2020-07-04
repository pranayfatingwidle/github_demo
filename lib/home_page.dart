import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pranayfatingdemo/api.dart';
import 'package:pranayfatingdemo/login.dart';
import 'package:pranayfatingdemo/profile_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_auth/simple_auth.dart';

class Home_page extends StatefulWidget {

  const Home_page({Key key}) : super(key: key);

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
  State<StatefulWidget> createState() => home_page();
}

class home_page extends State<Home_page> {

  ShapeBorder shape;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autovalidate = false;
  bool _formWasEdited = false;
  bool _loading = false;
  List repositories;
  String username = "";
  String avatar_url = "";

  API api = new API();

    final globalKey = GlobalKey<ScaffoldState>();


  getRepositories() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String token = preferences.getString("token");
    var response =  await api.getAsync_token("https://api.github.com/user/repos", token);
    if(response.statusCode != 200){
      print("Invalid Credentils");

    }else{
      var decodedJson = jsonDecode(response.body);
      setState(() {
        repositories = decodedJson;
      });
        print(response.body.length);
    }
  }

  getUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
         username = preferences.getString("username");
         avatar_url = preferences.getString("avatar_url");
    });
  }

  logout() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setBool("login",false);
          preferences.setString("token","");
          preferences.setString("username", "");
          preferences.setString("avatar_url", "");
          preferences.setString("html_url", "");
          preferences.setString("location", "");
          preferences.setInt("public_repos", 0);
          preferences.setInt("followers", 0);
          preferences.setInt("following", 0);
            await Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Screen()));
              
  }

      @override
  void initState() {
    super.initState();

    getRepositories();
    getUserInfo();

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
        key: globalKey,
        appBar: new AppBar(
        title: Text("Github demo",style: TextStyle(fontWeight: FontWeight.bold),),
        actions: <Widget>[
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.settings,color: Colors.black,),
            onPressed: () async {
              logout();
               
            },
          ),
        
        ],
      
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => globalKey.currentState.openDrawer(),
        ),
      ),
        drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new Card(
              child: UserAccountsDrawerHeader(
                accountName: new Text(username),
                accountEmail: new Text(""),
                onDetailsPressed: () async {
                await  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile_info()));
                
                },
                decoration: new BoxDecoration(
                  backgroundBlendMode: BlendMode.difference,
                  color: Colors.grey,

                ),
                currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(avatar_url == ""?
                        "https://www.fakenamegenerator.com/images/sil-female.png":avatar_url)),
              ),
            ),
            new Card(
              elevation: 4.0,
              child: new Column(
                children: <Widget>[
                  new ListTile(
                      leading: Icon(Icons.favorite),
                      title: new Text("Home"),
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> WishListPage()));
                      }),
                  new Divider(),
                  new ListTile(
                      leading: Icon(Icons.history),
                      title: new Text("Profile"),


                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile_info()));

                      }),
                ],
              ),
            ),
            new Card(
              elevation: 4.0,
              child: new Column(
                children: <Widget>[
                  new ListTile(
                      leading: Icon(Icons.settings),
                      title: new Text("Logout"),
                      onTap: () {
                     logout();
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
        
        body: repositories == null? Center(
          child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor),
                  ),
        ): PageView.builder(
  itemBuilder: (context, position) {
    return Container(
      child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                
                Card(
                  child: Text("name: ${repositories[position]["name"]}"),
                ),
                Card(
                child: Text("name: ${repositories[position]["html_url"]}"),
                ),
                Card(
                child: Text("name: ${repositories[position]["description"]}"),
                ),
              
              ],
            ),
    );
  },
  itemCount:repositories == null? 0: repositories.length, // Can be null
)
);
  }




  }
