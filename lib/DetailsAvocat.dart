import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AjoutRdv.dart';
import 'Login.dart';

class DetailsAvocat extends StatefulWidget {

  //var
  String _id;
  String _nom;
  String _prenom;
  String _image;
  String _sexe;
  String _descritpion;
  String _city;
  String _domaine;
  int _note;



  //constructor
  DetailsAvocat(this._id);

  @override
  _DetailAvocatState createState() => _DetailAvocatState();
}

class _DetailAvocatState extends State <DetailsAvocat> {
  Future<bool> fetchedAvocat;
  String getByIdUrl = BaseUrl +"api/avocat/getAvocat/";
  String _baseImageURL = BaseUrl +"api/avocat/file/";

  Future<bool> getAvocat() async {
    http.Response response = await http.get(Uri.parse(getByIdUrl + widget._id));
    Map<String , dynamic> avocatObject = json.decode(response.body);
    widget._prenom = avocatObject["prenom"]+" "+ avocatObject["nom"];
    widget._city = avocatObject["city"];
    widget._domaine = avocatObject["domaine"];
    widget._sexe = avocatObject["sexe"];
    widget._descritpion = avocatObject["description"];
    widget._image = avocatObject["image"];
    return true;
  }


  @override
  void initState() {
    super.initState();
    fetchedAvocat=getAvocat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détail Avocat" ),
      ),
      drawer: Drawer(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Menu"),
          ),
          body: ListTile(
            title: Text("Go to Menu to Top Bar GUI"),


            onTap: () {
              Navigator.pushNamed(context, "/list");
            },
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchedAvocat,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    height: 250,
                    width: 250,
                    child: CircleAvatar(
                          backgroundImage: NetworkImage(_baseImageURL+this.widget._image),

                    ),
                  ),
                ),
                SizedBox(
                height: 20,
                ),

                Center(
                  child: Text(" "+this.widget._domaine,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.redAccent),),
                ),
                SizedBox(height: 10,),

                RichText(
                  text: TextSpan(
                      text: ' ', style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.normal),
                      children: <TextSpan>[
                        TextSpan(text: 'Nom:    ', style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.bold)),
                        TextSpan(text: this.widget._prenom, style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.normal))
                      ]
                  ),

                ),
                SizedBox(height: 10,),
          RichText(
          text: TextSpan(
          text: ' ', style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.normal),
          children: <TextSpan>[
          TextSpan(text: 'Sexe:    ', style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.bold)),
          TextSpan(text: this.widget._sexe, style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.normal))
          ]
          ),

          ),
                SizedBox(height: 10,),

                RichText(
                  text: TextSpan(
                      text: ' ', style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.normal),
                      children: <TextSpan>[
                        TextSpan(text: 'Emplacement:    ', style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.bold)),
                        TextSpan(text: this.widget._city, style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.normal))
                      ]
                  ),

                ),
                SizedBox(height: 10,),

                Text(" "+"Description:",style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text(" "+this.widget._descritpion),

                SizedBox(height: 10,),
                Center(
                  child: RaisedButton(
                    color: Colors.red[800],
                    child: Text("Demander Rendez-Vous"),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return AjoutRdv(widget._id);
                        },
                      ));
                    },
                  ),
                ),

              ],

          );

          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

    );
  }
}