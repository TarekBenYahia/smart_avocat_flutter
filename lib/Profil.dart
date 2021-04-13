import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AjoutRdv.dart';
import 'Login.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {

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
  String _tel;



  //constructor
  Profil();

  @override
  _ProfilState createState() => _ProfilState();

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


class _ProfilState extends State <Profil> {
  Future<bool> fetchedAvocat;
  String getByIdUrl = BaseUrl +"api/avocat/getAvocat/60360b056c09d894aa34b4e6";
  String _baseImageURL = BaseUrl +"api/avocat/file/1613733269416.jpg";

  Future<bool> getAvocat() async {
    String token = await getStringValuesSF();
    http.Response response = await http.get(Uri.parse(getByIdUrl ));
    Map<String , dynamic> avocatObject = json.decode(response.body);
    widget._prenom = avocatObject["prenom"]+" "+ avocatObject["nom"];
    widget._city = avocatObject["city"];
    widget._domaine = avocatObject["domaine"];
    widget._sexe = avocatObject["sexe"];
    widget._descritpion = avocatObject["description"];
    widget._tel = avocatObject["phone"];
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
        title: Text("Mon Profil" ),
      ),
      drawer: Drawer(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Menu"),
          ),
          body: ListTile(
            title: Text("Menu Principal"),


            onTap: () {
              Navigator.pushNamed(context, "/bottomAvocat");
            },
          ),
        ),
      ),
      body:SingleChildScrollView(
        child:  FutureBuilder(
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
                        backgroundImage: NetworkImage(_baseImageURL),

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

                  RichText(
                    text: TextSpan(
                        text: ' ', style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.normal),
                        children: <TextSpan>[
                          TextSpan(text: 'Téléphone:    ', style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.bold)),
                          TextSpan(text: this.widget._tel, style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.normal))
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
                      elevation: 10,
                      child: Text("Modifier Mon Profil"),
                      onPressed: (){
                       /* Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) {
                          return AjoutRdv(widget._id);
                          },
                        ))*/;
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
      )
      ,

    );
  }
}