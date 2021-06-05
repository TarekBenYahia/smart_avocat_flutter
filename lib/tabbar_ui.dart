import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_avocat/Login.dart';
import 'package:smart_avocat/RdvClient.dart';
import 'package:smart_avocat/calendrier_client.dart';
import 'package:smart_avocat/more.dart';
import 'ListeAvocat.dart';
import 'Chatbot.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> EmptySP () async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}
Future<String>getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String idUserCo = prefs.getString('userData');
  //String user = jsonEncode(User.fromJson(json));
  //String idUserCo = jsonDecode(idUserCo);
  Map<String, dynamic> userObject = json.decode(idUserCo);
  String id = userObject["email"];
  return id;
}
class TabBarWidget extends StatefulWidget{
  TabBarWidget();
  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();

}


class _TabBarWidgetState extends State<TabBarWidget> {
  String _name = "";


  @override
  void initState() {
    getStringValuesSF().then(updateName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(

        onWillPop: () async{
      Fluttertoast.showToast(
        msg: 'Vous êtes déjà connecté!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      return false;
    },
    child: DefaultTabController(
    length: 5,
    child: Scaffold(
    appBar: AppBar(
    title: Text("Menu"),
    bottom: TabBar(tabs: [
    Tab(
    text: "Liste Avocats",
    icon: Icon(Icons.list),
    ),
    Tab(
    text : "Chatbot",
    icon: Icon(Icons.chat),
    ),
    Tab(
    text : "Rendez-Vous",
    icon: Icon(Icons.access_alarms),
    ),
    Tab(
    text : "Calendrier",
    icon: Icon(Icons.calendar_today_outlined),
    ),
    Tab(
    text : "Plus",
    icon: Icon(Icons.more_vert),
    )
    ]),
    ),
    drawer: Drawer(
    child: ListView(
    children: <Widget>[
    DrawerHeader(

    child: Column(
    children: [
    Center(child: Text("Smart Avocat"),),
    Image.asset("Assets/logo2.png",width: 100,),

    Text(_name)

    ],
    ),
    decoration: BoxDecoration(

    color: Colors.red[800],
    ),
    ),
    ListTile(
    leading: IconButton(
    icon: Icon(Icons.build, color: Colors.grey, size: 30,),
    ),
    title: Text('Changer la disposition'),
    onTap: () {
    Navigator.pushReplacementNamed(context, "/bottom");
    },
    ),

    ListTile(
    leading: IconButton(
    icon: Icon(Icons.account_circle_rounded, color: Colors.grey, size: 30,),
    ),
    title: Text('Profil'),
    onTap: () {
    Navigator.pushReplacementNamed(context, "/bottom");
    },
    ),

    ListTile(
    leading: IconButton(
    icon: Icon(Icons.power_settings_new, color: Colors.grey, size: 30,),
    ),
    title: Text('Déconnexion'),
    onTap: () {
    EmptySP();
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => Login()),
    );
    },
    ),

    ],
    )
    ),
    body: TabBarView(children: [
    ListeAvocat(),
    Chatbot(),
    RdvClient(),
    OnlineJsonData(),
    more()

    ]),
    )
    ),
    );
  }

  void updateName(String name) {
    setState(() {
      this._name = name;
    });
  }

}