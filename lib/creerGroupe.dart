import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_avocat/ListeGroupe.dart';
import 'dart:convert';
import 'dart:io';

import 'AjoutRdv.dart';
import 'Login.dart';
PickedFile imageURI;
final ImagePicker _picker = ImagePicker();
String state = "";
var file;

class CreationGroupe extends StatefulWidget {
  CreationGroupe();
  @override
  _CreationGroupeState createState() => _CreationGroupeState();
}

class _CreationGroupeState extends State<CreationGroupe> {
  //var
  File imageFile;
  final GlobalKey<FormState> _globalKey = new GlobalKey();
  final nomController = TextEditingController();
  final catController = TextEditingController();
  int idB = 1;
  String dropdownValue = 'Droit des Personnes';
  String typeG;

  Future getImageFromCameraGallery() async{
    var image =  await _picker.getImage(source:  ImageSource.gallery);
    setState(() {
      imageURI = image;
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer Groupe"),),
      body: Form(
        key: _globalKey,
        child: ListView(
          children: [
            //SizedBox(height: 3,),
            Image.asset("Assets/group.png",width: 10,height: 200,),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Nom"
              ),
              controller: nomController,
              // ignore: missing_return, missing_return
              validator: (value){
                if (value.isEmpty)
                  return "Champs vide";
              },
            ),
            SizedBox(
              height: 10,
            ),
            Container(

              height: 5 * 24.0,
              child: TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Description"
                ),
                validator: (value){
                  if (value.isEmpty)
                    return "Champs Vide";
                },
                controller: catController,

              ),
            ),
            SizedBox(height: 10,),
            SizedBox(width: 10,child: Text("Type : "),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text("Privé "),
                Radio(value: 1,activeColor: Colors.red, groupValue: idB, onChanged: (val){ setState(() {
                  idB = 1;
                });}),
                Text("Public "),
                Radio(value: 2,activeColor: Colors.red, groupValue: idB, onChanged: (val){ setState(() {
                  idB = 2 ;
                });}),
              ],
            ),
        DropdownButton<String>(
          value: dropdownValue,

          icon: const Icon(Icons.arrow_drop_down_circle_rounded),
          iconSize: 24,
          elevation: 16,
          iconEnabledColor: Colors.redAccent,
          underline: Container(
            height: 2,
            color: Colors.redAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['Droit des Personnes', 'Droit Rural', 'Droit Pénal', 'Droit Immobilier','Droit économique']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
            SizedBox(
              height: 40,
              width: 100,
              child: FloatingActionButton.extended(
                heroTag: "btn2",
                elevation: 10,
                splashColor: Colors.redAccent,

                icon: Icon(Icons.image),
                label: Text(
                    "Choisir une image"
                ),

                onPressed: () {
                  getImageFromCameraGallery();
                },),
            ),
            SizedBox(height: 10,),
            SizedBox(
              height: 150,
              child: Container(
                child: imageURI == null ? Image(image: AssetImage('Assets/default.jpg',),width: 50) :
                ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child:
                    Image.file(File(imageURI.path),width: 50,)),
              ),
            ),
            SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                    child: Text("Créer"),
                    color: Colors.red[800],
                    onPressed: () async {
                      if(!_globalKey.currentState.validate())
                        return;
                      if(idB == 1){typeG="Private";}
                      else{typeG="Public";}
                      String token = await (getStringValuesSF() as FutureOr<String>);
                      var res = await uploadImage(
                          nomController.text,
                          catController.text,
                          imageURI.path,
                          typeG,
                          token,
                          dropdownValue);
                      setState(() {
                        print(res);
                      });
                      if (res == "OK"){
                        return showDialog(context: context,builder: (context){
                          imageURI = null;
                          return CupertinoAlertDialog(
                            title: Text("Succès"),
                            content: Column(
                                children:  [
                                  SizedBox(height: 10,),
                                  Text("Groupe Créé avec succès !"),
                                  SizedBox(height: 20,),
                                  Image.asset("Assets/success.png")
                                ]
                            ),
                            actions: [
                              CupertinoDialogAction(child: Text("OK"),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ListeGroupe();
                                    },
                                  ));
                                },),

                            ],

                          );
                        });
                      }
                    }),
              ],
            )
          ],
        ),
        
      ),
    );
  }
}

Future<String> uploadImage(nom, desc, filename, type, userid, cat) async {
  var url = BaseUrl+"api/group/ajouter";
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.fields['nom'] = nom;
  request.fields['desc'] = desc;
  request.files.add(await http.MultipartFile.fromPath('file', filename));
  request.fields['type'] = type;
  request.fields['userid'] = userid;
  request.fields['cat'] =cat;
  var res = await request.send();
  return res.reasonPhrase;
}
