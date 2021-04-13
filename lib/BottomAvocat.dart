import 'package:flutter/material.dart';
import 'package:smart_avocat/Chatbot.dart';
import 'package:smart_avocat/RdvClient.dart';
import 'package:smart_avocat/moreAvocat.dart';
import 'ListeAvocat.dart';
import 'Login.dart';
import 'Profil.dart';
import 'RdvAvocat.dart';
import 'calendrier_client.dart';
import 'more.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
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




class BottomNavigationAvocat extends StatefulWidget {
  @override
  _BottomNavigationAvocatState createState() => _BottomNavigationAvocatState();
}

class _BottomNavigationAvocatState extends State<BottomNavigationAvocat> {
  //var
  int _bottomIndex = 0;
  List<Widget> interfaces = [RdvAvocat(), Chatbot(), RdvClient(), OnlineJsonData(), moreAvocat()];

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
    child:Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      drawer: Drawer(


        child: ListView(
          children: <Widget>[
            DrawerHeader(

              child: Column(
                children: [
                  Center(child: Text("Smart Avocat"),),
                  Image.asset("Assets/logo2.png",width: 100,),

                  Text("Tarek")

                ],
              ),
              decoration: BoxDecoration(

                color: Colors.red[800],
              ),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.build, color: Colors.black87, size: 30,),
              ),
              title: Text('Changer la disposition'),
              onTap: () {
               // Navigator.pushReplacementNamed(context, "/bottom");
              },
            ),

            ListTile(
              leading: IconButton(
                icon: Icon(Icons.account_circle_rounded, color: Colors.grey, size: 30,),
              ),
              title: Text('Profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profil()),
                );

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
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: "Mes Rendez-Vous",backgroundColor: Colors.black87,
            icon: Icon(Icons.access_alarm,color: Colors.white60,),
          ),
          BottomNavigationBarItem(
              label: "Chatbot",backgroundColor: Colors.black87,
              icon: Icon(Icons.chat,color: Colors.white60)
          ),
          BottomNavigationBarItem(
              label: "Rendez-Vous ",backgroundColor: Colors.black87,
              icon: Icon(Icons.access_alarms,color: Colors.white60)
          ),
          BottomNavigationBarItem(
              label: "Calendrier ",backgroundColor: Colors.black87,
              icon: Icon(Icons.calendar_today_outlined,color: Colors.white60)
          ),
          BottomNavigationBarItem(
              label: "Plus ",backgroundColor: Colors.black87,
              icon: Icon(Icons.more_vert,color: Colors.white60)
          ),
        ],
        currentIndex: _bottomIndex,
        onTap: (int value){
          setState(() {
            _bottomIndex = value;
          });
        },
      ),
      body: interfaces[_bottomIndex],
    ));
  }
}