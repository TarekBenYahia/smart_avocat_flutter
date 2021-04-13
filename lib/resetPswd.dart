

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Login.dart';

class ResetPswd  extends StatelessWidget {
  String email,password;
  final GlobalKey<FormState> _globalKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Form(
          key: _globalKey,
          child:ListView(
            children: [
              Column(
                children:[
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset("Assets/logo2.png",width: 180,),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Mot de passe oublié?",style: TextStyle(
                        fontSize: 30
                    ),
                    ),

                  ),
                  SizedBox(
                    height: 40,
                  ),




                ],
              ),
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
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                      color: Colors.red[800],

                      child: Text("Réinitialiser "),
                      onPressed: (){
                        if(!_globalKey.currentState.validate())
                          return;
                        _globalKey.currentState.save();


                        String resetUrl = BaseUrl+"api/user/resetPasswordMail";
                        Map<String ,String> headers = {
                          "Content-Type" : "application/json; chartset=UTF-8"
                        };
                        Map<String, dynamic> ResetObject = {

                          "email" : email
                        };
                        http.post(Uri.parse(resetUrl),headers: headers, body: json.encode (ResetObject)).then((http.Response response) async {
                          var message = response.statusCode == 200 ? "email sent " : "Erreur!";
                          var role = response.body;
                          if ( message == "Erreur!")
                            showDialog(context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: Text(("Erreur")),
                                  content: Column(
                                      children:  [
                                        SizedBox(height: 10,),
                                        Text("Email inexistant!"),
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

                               Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()),
                        );


                          }
                        });

                      }
                  )
                ],
              ),


            ],
          ),
      )

    );
  }
}
