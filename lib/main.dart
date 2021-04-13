import 'package:flutter/material.dart';
import 'package:smart_avocat/BottomAvocat.dart';
import 'package:smart_avocat/Chatbot.dart';
import 'package:smart_avocat/ListeAvocat.dart';
import 'package:smart_avocat/bottom_navbar.dart';
import 'package:smart_avocat/resetPswd.dart';
import 'package:smart_avocat/tabbar_ui.dart';
import 'Login.dart';
import 'package:smart_avocat/ChoixType.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'config.dart';
import 'package:page_transition/page_transition.dart';

import 'existing-cards.dart';


void main() {
  runApp(MyApp());

}




getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('stringValue');
  if(stringValue.length>0)
  return true;
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
var Page  ;
 void checkPrefs() async {
   Page = Login();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String idUserCo = prefs.getString('userData');
  if(idUserCo.contains("Client"))
    {
      Page = TabBarWidget();
    }
  else if(idUserCo.contains("Avocat"))
    {
      Page = BottomNavigationAvocat();
    }

}


class _MyAppState extends State<MyApp> {




  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Smart Lawyer',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.red[800],
       // accentColor: Colors.redAccent,
        accentColor: Colors.white60,
        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      //themeMode: currentTheme.currentTheme(),
      home: AnimatedSplashScreen(
        splash: Image.asset("Assets/logo2.png",),
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: Colors.red[800],
        splashIconSize: 300,



        duration: 1000,
        nextScreen: Page,
        pageTransitionType: PageTransitionType.bottomToTop,


      ),
      routes: {
        "/list" : (BuildContext context)
        {
          return TabBarWidget();
        },
        "/bottom" : (BuildContext context) {
          return BottomNavigation();
        },
        "/bottomAvocat" : (BuildContext context)
        {
          return BottomNavigationAvocat();
        },
        "/choix" : (BuildContext context){
          return choixType();
        },
        "/existing-cards" : (BuildContext context){
          return ExistingCardsPage();
        },
        "/Reset" : (BuildContext context){
          return ResetPswd();
        }




      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkPrefs();
    currentTheme.addListener(() {
      print("changes");
      setState(() {});
    });
  }
}

