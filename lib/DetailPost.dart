import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'Login.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class DetailPost extends StatefulWidget {
  String _id,nom,date,image,message;

  String fetchPostT = BaseUrl +"api/post/getmypostT/";
  String _baseImageURL = BaseUrl+"api/avocat/file/1613733269416.jpg";

  DetailPost(this._id,this.nom,this.date,this.image,this.message);
  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {

  List<PostView> posts = [];
  int nbr = 0;

  Future<bool> fetchedPostT;
  Future<bool> fetchPostT() async {
    http.Response response = await http.get(Uri.parse(widget.fetchPostT+widget._id));
    List<dynamic> PostFromServer = json.decode(response.body);
    for (var item in PostFromServer) {
      for (var com in item["comments"])
      {
        String NomPost = com["prenom"] + " "+ com["nom"];
        DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm");
        DateTime dateTime = dateFormat.parse(com["time"]);
        String stringD = dateFormat.format(dateTime);
        posts.add(PostView(com["_id"], NomPost,stringD,widget._baseImageURL,com["message"]));
      }
      for (var like in item["likes"])
        {

          nbr = nbr + 1;
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

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: fetchedPostT,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Scaffold(
            appBar: AppBar(title: Text("Commentaires"),),

              body: Column(

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
                                            color: Colors.black45),),
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
                                Image.network(widget.image, width: 200,),
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
                              Text(nbr.toString()),
                              SizedBox(width: 7,),
                              Icon(
                                  Icons.thumb_up
                              ),
                              SizedBox(width: 120,),
                              Text("12"),
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
                      trailing: IconButton(
                        icon: Icon(Icons.send,
                          size: 30,
                          color: Colors.red,
                        ) ,
                        onPressed: (){
                          if(messageController.text.isEmpty){
                            Fluttertoast.showToast(
                                msg: "Commentaire Vide",
                                toastLength: Toast.LENGTH_SHORT
                            );
                          }
                          else {
                            setState(() {
                              messages.insert(0, {
                                "data" : 1,
                                "message" : messageController.text
                              });
                              messageController.clear();

                            }
                            );
                            String addCommentUrl= BaseUrl +"api/post/addcomment";
                            Map<String, String> headers = {
                              "Content-Type" : "application/json; chartset=UTF-8"
                            };
                            Map<String, dynamic> commentObj = {

                              "message" : messageController.text,
                              "nom" : "Tarek",
                              "prenom" : "Ben Yahia",
                              "userid" : "6040d70c8d5c8469d0020ab3",
                              "rating" : "4",
                              "imagecomment" : "fsdfdsfdfd.jpg"

                            };

                            http.post(Uri.parse(addCommentUrl), headers: headers, body: json.encode(commentObj)).then((http.Response response){
                              var message = response.statusCode == 201 ? "Car added successfully." : "Something wrong !";
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Comment Added"),
                                    content: Text(message),
                                  );
                                },);
                            });

                          }
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if(!currentFocus.hasPrimaryFocus)
                          {
                            currentFocus.unfocus();
                          }
                        },
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

  PostView(this._id,this.nom, this.date,this.image,this.message);

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
              color: Colors.white70,
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
