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

class ListeGroupe extends StatefulWidget{
  //var
  String fetchAllURL = BaseUrl +"api/group/getgroups";
  String _baseImageURL = BaseUrl+"api/avocat/file/";

  //constructor
  ListeGroupe();
  @override
  _ListeGroupeState createState() => _ListeGroupeState();
}



class _ListeGroupeState extends State<ListeGroupe> {
  List<GroupeView> groupes = [
  ];

  Future<bool> fetchedGroupe;
  Future<bool> fetchGroupe() async {
    http.Response response = await http.get(Uri.parse(widget.fetchAllURL));
    List<dynamic> GroupesFromServer = json.decode(response.body);
    for (var item in GroupesFromServer) {
      groupes.add(GroupeView(item["_id"], item["nom"], item ["desc"],widget._baseImageURL+item["image"],item["type"],item["cat"]));
    }
    return true;
  }
  @override
  Future<void> initState() {
    super.initState();
    fetchedGroupe = fetchGroupe();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedGroupe,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          return Scaffold(
            appBar: AppBar(
              title: Text("Groupes"),
            ) ,
            body:  ListView.builder (
                itemBuilder: (BuildContext context, int index) {
                  return groupes[index];
                },
                itemCount: groupes.length,

              ),

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


class GroupeView extends StatelessWidget {
  String _id;
  String nom;
  String desc;
  String image;
  String type;
  String cat;

  GroupeView(this._id,this.nom, this.desc,this.image,this.type,this.cat);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child:Material(
        child:  SizedBox(
          height: 130,
          child:  InkWell(
            onTap: () {
              //Navigator.pushNamed(context, "/add");
             /* Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return DetailsAvocat(_id);
                },
              ));*/
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
                        SizedBox(height: 15,),
                        Text(this.nom.toUpperCase(),style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.redAccent),),
                        SizedBox(height: 3,),
                        Text(this.cat),
                        SizedBox(height: 20,),
                        Text(this.desc),

                      ],
                    ),


                    margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                  Image.asset("Assets/"+this.type+".png",width: 50,),

                  ]
                  ),







                ],
              ),
            ),

          ),
        ),
      ),
    );
  }

}

