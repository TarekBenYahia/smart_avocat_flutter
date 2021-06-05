import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_avocat/CheckList.dart';
import 'Login.dart';

class RdvClient extends StatefulWidget {
  String fetchRdvC = BaseUrl +"api/rendezvous/getMyRdvList/";


  RdvClient();
  @override
  _RdvClientState createState() => _RdvClientState();
}

Future<String> fetchNomAvocat(String name) async{
  http.Response responsedd = await http.get(Uri.parse(BaseUrl +"api/rendezvous/getNomAvocat/"+name));
  Map<String, dynamic> avocatO = json.decode(responsedd.body);
  String NomAv = avocatO["prenom"]+" "+avocatO["nom"];
 // print(NomAv);
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

class _RdvClientState extends State<RdvClient> {
  String _name = "";
  String NomAvocat="Maitre Houssem Ferjani";


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


  List<RdvView> listRdv = [];
  Future<bool> fetchedRdv;
  Future<bool> fetchRdv() async{
    String token = await (getStringValuesSF());
    http.Response response= await http.get(Uri.parse(widget.fetchRdvC+token));
    List<dynamic> RdvFromServer = json.decode(response.body);
    for (var item in RdvFromServer) {
/*
      http.Response responsedd = await http.get(Uri.parse(widget.getNomAvocat+item["avocatid"]));
      Map<String, dynamic> avocatO = json.decode(responsedd.body);
      NomAvocat = avocatO["prenom"]+" "+avocatO["nom"];*/

     // String names = "tarek";
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      DateTime dateTime = dateFormat.parse(item["date"]);
      String stringD = dateFormat.format(dateTime);
      String names = await fetchNomAvocat(item["avocatid"]);
      listRdv.add(RdvView(names,item["sujet"], stringD, item ["etat"]));
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

class RdvView extends StatelessWidget{
  String id,sujet,date,etat,nom;

  RdvView(this.id,this.sujet,this.date,this.etat);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 130,
        child:  InkWell(
          onTap: () {
            if(this.etat=="1"){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CheckList()),
              );
            }
          },
          onLongPress: (){

          },
          child:  Card (
            semanticContainer: true,
            shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row (
              children: [

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
               Padding(
                   padding: EdgeInsets.only(left: 120),
                 child:  Image.asset("Assets/"+this.etat+".png",width: 50,),
               )



              ],
            ),
          ),

        ),
      ),
    );
  }


}
