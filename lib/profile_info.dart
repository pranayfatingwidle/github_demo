import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile_info extends StatefulWidget {




  const Profile_info({Key key}) : super(key: key);

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
  State<StatefulWidget> createState() => profile_info();
}

class profile_info extends State<Profile_info> {
   String login;
 String html_url; 
 String name; 
 String location; 
 int public_repos; 
 int followers;
 int following;



getUserInfo() async {

 SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
         login = preferences.getString("username");
         html_url = preferences.getString("avatar_url");
         location = preferences.getString("location");
         public_repos = preferences.getInt("public_repos");
         followers = preferences.getInt("followers");
         following = preferences.getInt("following");

    });



}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text('Profile Page', style: TextStyle(fontWeight: FontWeight.bold)),
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          child: new SingleChildScrollView(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                
                Card(
                  child: Text("login: $login"),
                ),
                Card(
                  child: Text("html_url: $html_url"),
                ),
                Card(
                  child: Text("location: $location"),
                ),
                Card(
                  child: Text("public_repos: ${public_repos.toString()}"),
                ),
                Card(
                  child: Text("followers: ${followers.toString()}"),
                ),
                Card(
                  child: Text("following: ${following.toString()}"),
                ),
              
              ],
            ),
          )
        ));
  }




  }
