import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smart_avocat/Chatbot.dart';
import 'package:smart_avocat/config.dart';
import 'dart:convert';
import 'ListeAvocat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'User.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
//10.0.2.2
String BaseUrl = "http://10.0.2.2:3006/";
class Login extends StatefulWidget{
  Login();

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State <Login> {
  //var
  String email,password;
  final GlobalKey<FormState> _globalKey = new GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _globalKey,
        child: ListView(
          children: [
            Image.asset("Assets/logo2.png"),
            SizedBox(height: 0),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Email"
              ),
              // ignore: missing_return, missing_return
              validator: (value){
                if (value.isEmpty)

                  return "Champs email vide";
              },
              onSaved: (newValue){
                email = newValue;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder() , labelText: "Mot de Passe"
              ),
              // ignore: missing_return
              validator: (value){
                if (value.isEmpty)
                  return "Le champs Mot de Passe vide";
              },
              onSaved: (newValue){
                password = newValue;
              },
            ),
            Padding(padding: EdgeInsets.fromLTRB(275, 0, 0, 0),
            child:  InkWell(
              onTap: (){
                Navigator.pushNamed(context, "/Reset");
              },
              child: Text("Mot de passe oublié?",style: TextStyle(
                  decoration: TextDecoration.underline
              ),) ,
            ),),


            SizedBox(
              height: 10,
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(child: Text("Se connecter"),
                    color: Colors.red[800],
                    onPressed:(){

                  if(!_globalKey.currentState.validate())
                    return;
                  _globalKey.currentState.save();

                  //URL
                      String loginUrl = BaseUrl+"api/user/login";
                      Map<String ,String> headers = {
                        "Content-Type" : "application/json; chartset=UTF-8"
                      };
                  Map<String, dynamic> loginObject = {

                    "email" : email,
                    "password" : password
                  };
                  http.post(Uri.parse(loginUrl),headers: headers, body: json.encode (loginObject)).then((http.Response response) async {
                    var message = response.statusCode == 200 ? "Login Success " : "Erreur!";
                    var role = response.body;
                    if ( message == "Erreur!")
                      showDialog(context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text(("Erreur")),
                            content: Column(
                            children:  [
                              SizedBox(height: 10,),
                              Text("Veuillez vérifier vos paramètres"),
                              SizedBox(height: 20,),
                              Image.asset("Assets/erreur.png")
                            ]
                            ),
                            actions: [
                              CupertinoDialogAction(child: Text("Annuler"),
                              onPressed: () {
                                Navigator.pop(context);
                              },)
                            ],

                          );

                        },
                      );
                    else {
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      Map json = jsonDecode(role);
                      String user = jsonEncode(User.fromJson(json as Map<String, dynamic>));
                      pref.setString('userData', user);
                      print("Shared ="+ user);
                      if (role.contains("Client")) {
                        Fluttertoast.showToast(
                          msg: 'Bienvenue !',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                        Navigator.pushNamed(context, "/list");
                       /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListeAvocat()),
                        );*/
                      }
                      else if (role.contains("Avocat")) {

                     //   Navigator.pushNamed(context, "/list");
                        Fluttertoast.showToast(
                          msg: 'Bienvenue Maitre!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                        Navigator.pushNamed(context, "/bottomAvocat");
                      }
                    }
                  });


                    },
                ),
                SizedBox(
                  height: 30,
                ),

                new InkWell(
                  onTap: () {
                    const url = 'http://192.168.1.22:4200/pages/auth/register-2';
                    launchURL(url);
                  //  Navigator.pushNamed(context, "/choix");
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Center(
                      child: Text("Pas encore membre? inscrivez vous!",style: TextStyle(
                          decoration: TextDecoration.underline
                      ),) ,
                    ),
                  ),
                ),

              ],
            )
          ],
        )
    ),
    );
  }

}
launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url,
      forceWebView: true,
    enableJavaScript: true,
      enableDomStorage: true
    );
  } else {
    throw 'Could not launch $url';
  }
}