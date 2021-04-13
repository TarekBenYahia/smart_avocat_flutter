import 'package:fluttertoast/fluttertoast.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';

class Chatbot extends StatefulWidget {
  @override
  _ChatbotState createState() => _ChatbotState();
}


class _ChatbotState extends State<Chatbot> {
  final messageController = TextEditingController();
  List<Map> messages = List();


  void response(querry) async
  {
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "Assets/maitre-inda-4b2b4ff74f08.json").build();
    Dialogflow dialogflow =  Dialogflow(authGoogle: authGoogle,language: Language.french);
    AIResponse aiResponse = await dialogflow.detectIntent(querry);
    setState(() {
      messages.insert(0, {
        "data" : 0,
        "message" : aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
    print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Text("Aujourd'hui, ${DateFormat("Hm").format(DateTime.now())}", style: TextStyle(
                  fontSize: 20
              ),
              ),
            ),
      ),
            Flexible(
                child: ListView.builder(
                  reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context,index) => chat(
                        messages[index]["message"].toString(),
                        messages[index]["data"]
                    )
                ),
            ),



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
                      hintText: "Entrer un message...",
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
                        msg: "Message Vide",
                        toastLength: Toast.LENGTH_SHORT
                      );
                    }
                    else {
                      setState(() {
                        messages.insert(0, {
                          "data" : 1,
                          "message" : messageController.text
                        });
                        response(messageController.text);
                        messageController.clear();
                      }
                      );
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
      ),
    );
  }
  Widget chat(String message, int data){
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20),
      child: Row(
        mainAxisAlignment: data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0 ? Container(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage("Assets/robot.jpg"),
            ),

          ) : Container(),
          
          Padding(
              padding: EdgeInsets.all(10),
            child: Bubble(
              radius: Radius.circular(15.0),
              color: data == 0 ? Color.fromRGBO(255, 0, 0, 1) : Colors.white,
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: Container(
                         constraints: BoxConstraints(maxWidth: 200),
                          child: Text(
                            message,
                            style: TextStyle(
                              color: Colors.black54, fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),

          data == 1 ? Container(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage("Assets/default.jpg"),
            ),

          ) : Container(),
        ],
      ),
    );
  }
}
