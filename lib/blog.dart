import 'package:flutter/cupertino.dart';
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

PickedFile imageURI;
final ImagePicker _picker = ImagePicker();
var file;
Future<String> fetchNomAvocat(String name) async{
  http.Response responsedd = await http.get(Uri.parse(BaseUrl +"api/rendezvous/getNomAvocat/"+name));
  Map<String, dynamic> avocatO = json.decode(responsedd.body);
  String NomAv = avocatO["prenom"];
  //print(NomAv);
  return NomAv;
}
Future<String> fetchPreNomAvocat(String name) async{
  http.Response responsedd = await http.get(Uri.parse(BaseUrl +"api/rendezvous/getNomAvocat/"+name));
  Map<String, dynamic> avocatO = json.decode(responsedd.body);
  String NomAv = avocatO["nom"];
  //print(NomAv);
  return NomAv;
}

Future<String> fetchImgAvocat(String name) async{
  http.Response responsedd = await http.get(Uri.parse(BaseUrl +"api/rendezvous/getNomAvocat/"+name));
  Map<String, dynamic> avocatO = json.decode(responsedd.body);
  String NomAv = avocatO["image"];
  //print(NomAv);
  return NomAv;
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

Future<String>getStringValuesSFROLE() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String idUserCo = prefs.getString('userData');
  //String user = jsonEncode(User.fromJson(json));
  //String idUserCo = jsonDecode(idUserCo);
  Map<String, dynamic> userObject = json.decode(idUserCo);
  String role = userObject["roles"];
  return role;
}



class Blog extends StatefulWidget{
  //var
  String fetchAllURL = BaseUrl +"api/post/getAllposts";
  String _baseImageURL = BaseUrl+"api/avocat/file/";

  //constructor

  Blog();



  @override
  _BlogState createState() => _BlogState();
}



class _BlogState extends State<Blog> {
  String message;
  ///////////////////////////////////////////////////////
  File imageFile;

  Future getImageFromCameraGallery() async{
    var image =  await _picker.getImage(source:  ImageSource.gallery);
    setState(() {
      imageURI = image;
    });
  }


  ///////////////////////////////////////////////////////

  List<PostView> posts = [
  ];


  Future<bool> fetchedPost;
  Future<bool> fetchPost() async {
    http.Response response = await http.get(Uri.parse(widget.fetchAllURL));
    List<dynamic> PostsFromServer = json.decode(response.body);
    for (var item in PostsFromServer) {
      int nbrC=0;
      for (var com in item["comments"])
      {
        nbrC = nbrC+1;
      }
      int nbr = 0;
      for (var like in item["likes"])
      {

        nbr = nbr+1 ;
      }
      String NomPost = item["prenom"] + " "+ item["nom"];
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      DateTime dateTime = dateFormat.parse(item["datepost"]);
      String stringD = dateFormat.format(dateTime);
      posts.add(PostView(item["_id"], NomPost,stringD,widget._baseImageURL+item["image"],item["message"],nbrC,nbr,widget._baseImageURL+item["imageuser"]));

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
                          content:  StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState){
                              return SingleChildScrollView(
                                child: Column(
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
                                      onChanged: (newValue){
                                        setState(() {
                                          message = newValue;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),


                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          child: imageURI == null ? Image(image: AssetImage('Assets/default.jpg',),width: 140) :
                                          ClipRRect(
                                              borderRadius: BorderRadius.circular(200.0),
                                              child:
                                              Image.file(File(imageURI.path),width: 200,)),
                                        ),
                                        SizedBox(height: 10,),
                                        SizedBox(
                                          height: 30,
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
                                        SizedBox(height: 30,),
                                        FloatingActionButton.extended(
                                          heroTag: "btn3",
                                          elevation: 10,
                                          backgroundColor: Colors.red,
                                          splashColor: Colors.redAccent,

                                          label: Text(
                                              "Publier"
                                          ),

                                          onPressed: () async {

                                            String token = await (getStringValuesSF() as FutureOr<String>);
                                            String role = await (getStringValuesSFROLE() as FutureOr<String>);
                                            String prenomd = await fetchNomAvocat(token);
                                            String nomd = await fetchPreNomAvocat(token);
                                            String img = await fetchImgAvocat(token);
                                            var res = await uploadImage(
                                                token,
                                                message,
                                                prenomd,
                                                nomd,
                                                img,
                                                role,
                                                imageURI.path);
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
                                                        Text("Post Ajouté avec succès !"),
                                                        SizedBox(height: 20,),
                                                        Image.asset("Assets/success.png")
                                                      ]
                                                  ),
                                                  actions: [
                                                    CupertinoDialogAction(child: Text("OK"),
                                                      onPressed: () {
                                                        Navigator.push(context, MaterialPageRoute(
                                                          builder: (BuildContext context) {
                                                            return Blog();
                                                          },
                                                        ));
                                                      },),

                                                  ],

                                                );
                                              });
                                            }
                                            else{
                                              return showDialog(context: context,builder: (context){
                                                return CupertinoAlertDialog(
                                                  title: Text("Erreur !"),
                                                  content: Column(
                                                      children:  [
                                                        SizedBox(height: 10,),
                                                        Text("Veuillez réessayer !"),
                                                        SizedBox(height: 20,),
                                                        Image.asset("Assets/erreur.png")
                                                      ]
                                                  ),
                                                  actions: [
                                                    CupertinoDialogAction(child: Text("OK"),
                                                      onPressed: () {
                                                        Navigator.push(context, MaterialPageRoute(
                                                          builder: (BuildContext context) {
                                                            return Blog();
                                                          },
                                                        ));
                                                      },),

                                                  ],

                                                );
                                              });
                                            }

                                          },),

                                      ],
                                    ),



                                  ],
                                ),
                              );
                            },
                          ),
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
  String imageUser;
  int nbrL=0;

  PostView(this._id,this.nom, this.date,this.image,this.message,this.note,this.nbrL,this.imageUser);

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
                  return DetailPost(_id,nom,date,image,message,nbrL,note);
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
                               backgroundImage: NetworkImage(this.imageUser),
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
                        Image.network(this.image,width: 150,),
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
                      Text(this.nbrL.toString()),
                      SizedBox(width: 7,),
                      Icon(
                        Icons.thumb_up,

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
Future<String> uploadImage(userid, message, nom, prenom, imageuser, role,filename) async {
  var url = BaseUrl+"api/post/addpost";
  var request = http.MultipartRequest('POST', Uri.parse(url));

  request.fields['userid'] = userid;
  request.fields['message'] = message;
  request.files.add(await http.MultipartFile.fromPath('file', filename));

  request.fields['nom'] = nom;
  request.fields['prenom'] = prenom;
  request.fields['imageuser'] =imageuser;
  request.fields['role'] = role;
  var res = await request.send();
  return res.reasonPhrase;
}

