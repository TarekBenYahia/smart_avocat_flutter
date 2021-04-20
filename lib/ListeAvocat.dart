import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:smart_avocat/Login.dart';
import 'DetailsAvocat.dart';
import 'User.dart';
import 'main.dart';

class ListeAvocat extends StatefulWidget{
  //var
  String fetchAllURL = BaseUrl +"api/avocat/getAll";
  String _baseImageURL = BaseUrl+"api/avocat/file/1613733269416.jpg";

  //constructor

  ListeAvocat();



  @override
  _ListeAvocatState createState() => _ListeAvocatState();
}



class _ListeAvocatState extends State<ListeAvocat> {
  List<AvocatView> avocats = [
  ];

  Future<bool> fetchedAvocat;
  Future<bool> fetchAvocat() async {
    http.Response response = await http.get(Uri.parse(widget.fetchAllURL));
    List<dynamic> avocatsFromServer = json.decode(response.body);
    for (var item in avocatsFromServer) {
      avocats.add(AvocatView(item["_id"], item["nom"], item ["prenom"],widget._baseImageURL));
    }
    return true;
  }
  @override
  Future<void> initState() async {
    super.initState();
    fetchedAvocat = fetchAvocat();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchedAvocat,
        builder: (context, snapshot) {
          if(snapshot.hasData){

            return ListView.builder (
              itemBuilder: (BuildContext context, int index) {
                return avocats[index];
              },
              itemCount: avocats.length,

            );
          } else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
    );
  }
  
}


 class AvocatView extends StatelessWidget {
  String _id;
  String nom;
  String prenom;
  String image;
  String note;

  AvocatView(this._id,this.nom, this.prenom,this.image);

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

    child:Material(
      child:  SizedBox(
        height: 130,
        child:  InkWell(
          onTap: () {
            //Navigator.pushNamed(context, "/add");
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return DetailsAvocat(_id);
              },
            ));
          },

          child:  Card (
            semanticContainer: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row (
              children: [
                Container(
                  height: 80,
                  width: 80,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(this.image),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Text(this.nom),
                      Text(this.prenom),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
                ),
                SizedBox(width: 120,),
                Image.asset("Assets/star.png",width: 40,),
                Text(" 5",style: TextStyle(fontSize: 25),)





              ],
            ),
          ),

        ),
      ),
    ),
    );
  }

}

