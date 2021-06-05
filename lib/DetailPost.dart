import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:smart_avocat/blog.dart';
import 'Login.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

Future<String> fetchNomAvocat(String name) async{
  http.Response responsedd = await http.get(Uri.parse(BaseUrl +"api/rendezvous/getAvocatUserId/"+name));
  Map<String, dynamic> avocatO = json.decode(responsedd.body);
  String NomAv = avocatO["nom"];
  // print(NomAv);
  return NomAv;
}
Future<String> fetchPreNomAvocat(String name) async{
  http.Response responsedd = await http.get(Uri.parse(BaseUrl +"api/rendezvous/getAvocatUserId/"+name));
  Map<String, dynamic> avocatO = json.decode(responsedd.body);
  String NomAv = avocatO["prenom"];
  //print(NomAv);
  return NomAv;
}

File imageFile;
PickedFile imageURI;
final ImagePicker _picker = ImagePicker();
var file;
class DetailPost extends StatefulWidget {
  String _id,nom,date,image,message;
  int nbrL,note;




  String fetchPostT = BaseUrl +"api/post/getmypostT/";
  String _baseImageURL = BaseUrl+"api/avocat/file/1613733269416.jpg";

  DetailPost(this._id,this.nom,this.date,this.image,this.message,this.nbrL,this.note);
  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {

  //*************************************************************************//


  Future getImageFromCameraGallery() async{
    var image =  await _picker.getImage(source:  ImageSource.gallery);
    setState(() {
      imageURI = image;
    });
  }

  //*********************************************************//

  List<PostView> posts = [];

  int nbr = 0;


  Future<bool> fetchedPostT;
  Future<bool> fetchPostT() async {
    http.Response response = await http.get(Uri.parse(widget.fetchPostT+widget._id));
    List<dynamic> PostFromServer = json.decode(response.body);
    for (var item in PostFromServer) {
      int nbrC=0;
      for (var like in item["likes"])
      {

        nbr = nbr+1 ;
      }
      for (var com in item["comments"])
      {
        nbrC= nbrC+1;
        String NomPost = com["prenom"] + " "+ com["nom"];
        DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm");
        DateTime dateTime = dateFormat.parse(com["time"]);
        String stringD = dateFormat.format(dateTime);
        posts.add(PostView(com["_id"], NomPost,stringD,widget._baseImageURL,com["message"],nbrC));
      }


    }
    return true;
  }


  @override
  Future<void> initState() {
    super.initState();
    fetchedPostT = fetchPostT();
  }
  final messageController = TextEditingController();
  List<Map> messages = List();
  bool isPressed=false;
  int nbrL =0;

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: fetchedPostT,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text("Commentaires"),),

              body:  Column(
                mainAxisSize: MainAxisSize.max ,

                children: <Widget>[
                  Card(
                    color: Colors.black26,
                    semanticContainer: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                        children: [Row(
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
                                      backgroundImage: NetworkImage(
                                          widget.image),
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(widget.nom.toUpperCase(),
                                          style: TextStyle(fontSize: 17),),
                                        Text(widget.date, style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70),),
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
                            height: 240,
                            width: 220,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.redAccent,
                                  width: 3),
                              borderRadius: BorderRadius.circular(15.0),

                            ),
                            child: Column(
                              children: [
                                Text(widget.message,),
                                Image.network(widget.image, width: 150,),
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
                              Text(widget.nbrL.toString()),
                              SizedBox(width: 7,),

                              IconButton(icon:Icon( Icons.thumb_up),
                                  onPressed: (){
                                    if(isPressed==false){setState(()
                                    {
                                    widget.nbrL = widget.nbrL+1;
                                      isPressed= true;
                                    });}
                                    else{
                                      setState(() {
                                        widget.nbrL = widget.nbrL-1;
                                        isPressed=false;
                                      });
                                    }
                                  },
                              color: (isPressed) ? Color(0xff007397)
                                  : Color(0xff9A9A9A)),

                              SizedBox(width: 120,),
                              Text(widget.note.toString()),
                              SizedBox(
                                width: 7,
                              ),
                              Icon(Icons.message)

                            ],
                          )


                        ]

                    ),
                  ),

                  new Expanded(child: ListView.builder (
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,

                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return posts[index];
                    },


                  ),),
                  Divider(
                    height: 5,
                    color: Colors.redAccent,
                  ),
                  Container(
                    child: ListTile(

                      title: Container(
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color.fromRGBO(220, 220, 220, 1)
                        ),
                        padding: EdgeInsets.only(left: 15),
                        child: TextFormField(
                          textInputAction: TextInputAction.send,


                          onFieldSubmitted: (value ) async {
                            if(value==""){
                              Fluttertoast.showToast(
                                msg: 'Commentaire Vide !',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            }
                            else{
                              String token = await (getStringValuesSF() as FutureOr<String>);
                              String nomd = await fetchPreNomAvocat(token);
                              String prenomd = await fetchNomAvocat(token);
                              String addCUrl =BaseUrl + "api/post/addcomment";
                              Map<String, String> headers = {
                                "Content-Type" : "application/json; chartset=UTF-8"
                              };

                              Map<String, dynamic> userObject = {

                                "postid" : widget._id ,
                                "message" : value,
                                "nom" : nomd,
                                "prenom" : prenomd,
                                "userid" : token,
                                "imagecomment" : "1613733269416.jpg",
                                "rating" : "3"

                              };
                              http.post(Uri.parse(addCUrl), headers: headers, body: json.encode(userObject)).then((http.Response response){
                                var message = response.statusCode != 400 ? "Commentaire ajouté avec succès!" : "Erreur !";
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DetailPost(widget._id, widget.nom, widget.date, widget.image, widget.message,widget.nbrL,widget.note+1);
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
                            }
                          },
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Entrer un Commentaire...",
                            hintStyle: TextStyle(
                                color: Colors.black26
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,


                          ),
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black
                          ),
                        ),
                      ),

                    ),
                  ),

                ],
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
  String note;
  String message;
  int nbrL;
  int nbrC;

  PostView(this._id,this.nom, this.date,this.image,this.message,this.nbrC);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child:Material(
        child:  SizedBox(
          height: 100,
          child:  InkWell(
            onTap: () {
              //Navigator.pushNamed(context, "/add");

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
                    Padding(padding: EdgeInsets.only(left: 0),
                    child: Text(this.message,),),





                  ]

              ),
            ),

          ),
        ),
      ),
    );
  }

}

Future<String> uploadImage(postid, message, nom, prenom, userid, rating, imagecomment) async {
  var url = BaseUrl+"api/post/addcomment";
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.fields['postid'] = postid;
  request.fields['message'] = message;
  request.fields['nom'] = nom;
  request.fields['imagecomment'] = imagecomment;
  request.fields['prenom'] = prenom;
  request.fields['userid'] = userid;
  request.fields['imagecomment'] =imagecomment;
  request.fields['rating'] = rating;
  var res = await request.send();
  return res.reasonPhrase;
}
