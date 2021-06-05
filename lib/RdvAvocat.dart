import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'package:flutter/cupertino.dart';

class RdvAvocat extends StatefulWidget {
  String fetchRdvC = BaseUrl +"api/rendezvous/getMyRdvListAvocat/";


  RdvAvocat();
  @override
  _RdvAvocatState createState() => _RdvAvocatState();
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

Future<String> fetchNom(String name) async{
      http.Response responsedd = await http.get(Uri.parse(BaseUrl +"api/rendezvous/getNomClient/"+name));
      Map<String, dynamic> avocatO = json.decode(responsedd.body);
     String NomCl = avocatO["prenom"]+" "+avocatO["nom"];
  //   print(NomCl);
  return NomCl;
}


class _RdvAvocatState extends State<RdvAvocat> {
  String _name = "";
  String NomAvocat="Tarek Ben Yahia";


  @override
  void initState() {

    getStringValuesSF().then(updateName);
    super.initState();
    fetchedRdv = fetchRdv();

    // print("idd_"+this.name);
  }
  void updateName(String name) {
    setState(() {
      this._name = name;

    });
  }


  List<RdvAvocatView> listRdv = [];
  Future<bool> fetchedRdv;
  Future<bool> fetchRdv() async{
    String token = await (getStringValuesSF() as FutureOr<String>);
    http.Response response= await http.get(Uri.parse(widget.fetchRdvC+token));
    List<dynamic> RdvFromServer = json.decode(response.body);
    for (var item in RdvFromServer) {
     // String nom = await fetchNom(item["userid"]);
/*
      http.Response responsedd = await http.get(Uri.parse(widget.fetchNomClient+item["userid"]));
      Map<String, dynamic> avocatO = json.decode(responsedd.body);
     String NomCl = avocatO["prenom"]+" "+avocatO["nom"];
     print(NomCl);
*/
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      DateTime dateTime = dateFormat.parse(item["date"]);
      String stringD = dateFormat.format(dateTime);
      String names = await fetchNom(item["userid"]);
      listRdv.add(RdvAvocatView(names,item["sujet"], stringD, item ["etat"]));
    }
    return true;
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedRdv,
      builder: (context,snapshot){
        if(snapshot.hasData){
          return ListView.builder(
            itemBuilder: (BuildContext context,int index){
              return listRdv[index];
            },
            itemCount: listRdv.length,
          );
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },);
  }



}

class RdvAvocatView extends StatelessWidget{
  String sujet,date,etat,nom,id;

  RdvAvocatView(this.id,this.sujet,this.date,this.etat);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 130,
        child:  InkWell(
          onTap: () {
          },
          onLongPress: (){
            if(this.etat=="0")
              {

                showDialog(context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: Text(("Information")),
                      content: Column(
                          children:  [
                            SizedBox(height: 10,),
                            Text("Etes Vous sur de vouloir Accepter ce Rendez-vous"),
                            SizedBox(height: 20,),
                            Image.asset("Assets/exclamation.png")
                          ]
                      ),
                      actions: [
                        CupertinoDialogAction(child: Text("Non"),
                          onPressed: () {
                            Navigator.pop(context);
                          },),
                        CupertinoDialogAction(child: Text("Oui"),
                          onPressed: () {
                            Navigator.pop(context);
                          },)
                      ],

                    );

                  },
                );


              }
          },
          child:  Card (
            semanticContainer: true,
            shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row (
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset("Assets/"+this.etat+".png",width: 50,),
                ),

                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(this.id),
                      Text(this.date),
                      Text(this.sujet),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
                ),





              ],
            ),
          ),

        ),
      ),
    );
  }


}
