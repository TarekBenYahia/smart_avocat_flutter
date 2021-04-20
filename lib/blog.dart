import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:smart_avocat/Login.dart';
import 'DetailPost.dart';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'package:async/async.dart';
import 'DetailsAvocat.dart';
import 'User.dart';
import 'main.dart';

class Blog extends StatefulWidget{
  //var
  String fetchAllURL = BaseUrl +"api/post/getAllposts";
  String _baseImageURL = BaseUrl+"api/avocat/file/1613733269416.jpg";

  //constructor

  Blog();



  @override
  _BlogState createState() => _BlogState();
}



class _BlogState extends State<Blog> {
  ///////////////////////////////////////////////////////

  File _image;
  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }


  ///////////////////////////////////////////////////////

  List<PostView> posts = [
  ];
  int nbrC=1;

  Future<bool> fetchedPost;
  Future<bool> fetchPost() async {
    http.Response response = await http.get(Uri.parse(widget.fetchAllURL));
    List<dynamic> PostsFromServer = json.decode(response.body);
    for (var item in PostsFromServer) {
      for (var com in item["comments"])
      {
        nbrC = nbrC+1;
      }
      String NomPost = item["prenom"] + " "+ item["nom"];
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      DateTime dateTime = dateFormat.parse(item["datepost"]);
      String stringD = dateFormat.format(dateTime);
      posts.add(PostView(item["_id"], NomPost,stringD,widget._baseImageURL,item["message"],nbrC));

    }
    return true;
  }
  @override
  Future<void> initState() {
    super.initState();
    fetchedPost = fetchPost();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedPost,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          return Scaffold(
            appBar: AppBar(title: Text("Blog"),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.add_circle),iconSize: 40,
                  onPressed: (){
                    return showDialog(context: context,builder: (context){
                      return AlertDialog(
                          title: Text("Ajouter une publication", style: TextStyle(fontSize: 20),),
                          content:  Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder() , labelText: "Contenu"
                                ),
                                // ignore: missing_return
                                validator: (value){
                                  if (value.isEmpty)
                                    return "Le champs Mot de Passe vide";
                                },
                                onSaved: (newValue){
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              FloatingActionButton.extended(
                                  heroTag: "btn2",
                                  elevation: 10,
                                  splashColor: Colors.redAccent,

                                  icon: Icon(Icons.image),
                                  label: Text(
                                      "Choisir une image"
                                  ),

                                  onPressed: () async => await getImage()),
                              SizedBox(
                                height: 20,
                              ),



                            ],
                          )
                      );
                    });
              })
            ],
            ),
            body: ListView.builder (
              itemBuilder: (BuildContext context, int index) {
                return posts[index];
              },
              itemCount: posts.length,

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


class PostView extends StatelessWidget {
  String _id;
  String nom;
  String date;
  String image;
  int note;
  String message;

  PostView(this._id,this.nom, this.date,this.image,this.message,this.note);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child:Material(
        child:  SizedBox(
          height: 420,
          child:  InkWell(
            onTap: () {
              //Navigator.pushNamed(context, "/add");
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return DetailPost(_id,nom,date,image,message);
                },
              ));
            },

            child:  Card (
              color: Colors.white24,
              semanticContainer: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [Row (
                children: [
                  SizedBox(
                  width: 10,
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(

                      height: 50,
                     // width: 100,
                      child: Row(
                           mainAxisSize: MainAxisSize.max,
                           children: [
                             SizedBox(height: 10,),
                             CircleAvatar(
                               backgroundImage: NetworkImage(this.image),
                             ),
                             SizedBox(width: 10,),
                             Column(
                               children: [
                                 SizedBox(height: 10,),
                                 Text(this.nom.toUpperCase(),style: TextStyle(fontSize: 17),),
                                 Text(this.date,style: TextStyle(fontSize: 12,color: Colors.black45),),
                               ],
                             ),
                           ],
                         ),
                    ),
                  ),
                ],
              ),
                  new Divider(
                    color: Colors.white,
                    thickness: 1.5,
                  ),
                  Container(
                    height: 300,
                    width: 280,
                    decoration: BoxDecoration(border: Border.all(color: Colors.redAccent,width: 3),borderRadius: BorderRadius.circular(15.0),

                    ),
                    child: Column(
                      children: [
                        Text(this.message,),
                        Image.network(this.image,width: 350,),
                      ],
                    ),
                  ),

                  new Divider(
                    color: Colors.white,
                     thickness: 1.5,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 80,),
                      Text("53"),
                      SizedBox(width: 7,),
                      Icon(
                        Icons.thumb_up
                      ),
                      SizedBox(width: 120,),
                      Text(this.note.toString()),
                      SizedBox(
                        width: 7,
                      ),
                      Icon(Icons.message)

                    ],
                  )


                ]

              ),
            ),

          ),
        ),
      ),
    );
  }

}

