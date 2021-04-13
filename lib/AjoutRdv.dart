import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert' show JSON;
import 'Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AjoutRdv extends StatefulWidget{
  String _idAvocat;

  AjoutRdv(this._idAvocat);

  @override
  _AjoutRdvState createState() => _AjoutRdvState();

}
Future<String>getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String idUserCo = prefs.getString('userData');
  //String user = jsonEncode(User.fromJson(json));
  //String idUserCo = jsonDecode(idUserCo);
  Map<String, dynamic> userObject = json.decode(idUserCo);
  String id = userObject["_id"];
  return id;
}


class _AjoutRdvState extends State<AjoutRdv> {
  String _name = "";
  String _sujet;

  @override
  void initState() {
    getStringValuesSF().then(updateName);
    super.initState();
  }

  final GlobalKey<FormState> _globalKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demande de Rendez-Vous"),
      ),
      body :Form(
      key: _globalKey,
      child: ListView(
        children: [
          SizedBox(
            height: 40,
          ),
          Center(
            child: Text(
              "Décrivez brièvement votre problème",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.all(12),
            height: 5 * 24.0,
            child: TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Sujet"
              ),
              validator: (value){
                if (value.isEmpty)
                  return "Champs Vide";
              },
              onSaved: (newValue) {
                _sujet = newValue;
              },
            ),
          ),
          Center(
            child: RaisedButton(
              color: Colors.red[800],
              child: Text("Valider"),
              onPressed: (){
                if(!_globalKey.currentState.validate())
                  return;
                _globalKey.currentState.save();

                String addRDVUrl =BaseUrl + "api/rendezvous/ajouterRdv";
                Map<String, String> headers = {
                  "Content-Type" : "application/json; chartset=UTF-8"
                };
                DateTime now = new DateTime.now();
                DateTime date = new DateTime(now.year,now.month,now.day);
                Map<String, dynamic> userObject = {

                  "userid" : _name,
                  "avocatid" : this.widget._idAvocat,
                  "sujet" : _sujet,
                  "date" : date.toString()

                };
                http.post(Uri.parse(addRDVUrl), headers: headers, body: json.encode(userObject)).then((http.Response response){
                  var message = response.statusCode != 400 ? "Rendez-Vous ajouté avec succès!" : "Erreur !";
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text(("Succès")),
                        content: Column(
                            children:  [
                              SizedBox(height: 10,),
                              Text("Rendez-Vous ajouté avec succès!"),
                              SizedBox(height: 20,),
                              Image.asset("Assets/success.png")
                            ]
                        ),
                        actions: [
                          CupertinoDialogAction(child: Text("OK"),
                            onPressed: () {
                              Navigator.pushNamed(context, "/list");
                            },)
                        ],

                      );
                    },);
                  if ( message == "Erreur!")
                    showDialog(context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text(("Erreur")),
                          content: Column(
                              children:  [
                                SizedBox(height: 10,),
                                Text("Veuillez vérifier les paramètres"),
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
                });



              },
            ),
          ),
        ],
      ),
    ),);
  }


  void updateName(String name) {
    setState(() {
      this._name = name;
    });
  }
}