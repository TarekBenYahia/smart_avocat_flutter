import 'package:flutter/material.dart';
import 'package:smart_avocat/Chatbot.dart';
import 'package:smart_avocat/RdvClient.dart';
import 'ListeAvocat.dart';
import 'calendrier_client.dart';
import 'more.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  //var
  int _bottomIndex = 0;
  List<Widget> interfaces = [ListeAvocat(), Chatbot(), RdvClient(), OnlineJsonData(), more()];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      drawer: Drawer(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Choisissez une option"),
          ),
          body: ListTile(
            leading: IconButton(
              icon: Icon(Icons.build, color: Colors.grey, size: 35,), onPressed: () {  },
            ),

            title: Text("Changer la disposition"),
            onTap: () {
              Navigator.pushNamed(context, "/list");
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: "Liste des Avocats",
            icon: Icon(Icons.list,color: Colors.white60,),
          ),
          BottomNavigationBarItem(
              label: "Chatbot",
              icon: Icon(Icons.chat,color: Colors.white60)
          ),
          BottomNavigationBarItem(
              label: "Rendez-Vous ",
              icon: Icon(Icons.access_alarms,color: Colors.white60)
          ),
          BottomNavigationBarItem(
              label: "Calendrier ",
              icon: Icon(Icons.calendar_today_outlined,color: Colors.white60)
          ),
          BottomNavigationBarItem(
              label: "Plus ",
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
    );
  }
}