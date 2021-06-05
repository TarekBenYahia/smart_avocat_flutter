import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_avocat/ListeGroupe.dart';
import 'package:smart_avocat/blog.dart';

import 'creerGroupe.dart';

class moreAvocat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 500,
            child: Column
              (
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(width: 20,),
                Padding(
                  padding: EdgeInsets.only(left: 35),
               child: Container(
                 width: 350,
                 child: FloatingActionButton.extended(
                   heroTag: "btnn",
                     backgroundColor: Colors.white,
                     elevation: 20,
                     splashColor: Colors.redAccent,

                     icon: Icon(Icons.group),
                     label: Text(
                         "Groupes"
                     ),

                     onPressed: (){
                       if(true){
                         showDialog(context: context,
                           builder: (BuildContext context) {
                             return CupertinoAlertDialog(
                               title: Text(("Information")),
                               content: Column(
                                   children:  [
                                     SizedBox(height: 10,),
                                     Text("Voulez vous rejoindre ou créer un groupe?"),
                                     SizedBox(height: 20,),
                                     Image.asset("Assets/exclamation.png")
                                   ]
                               ),
                               actions: [
                                 CupertinoDialogAction(child: Text("Rejoindre"),
                                   onPressed: () {
                                     Navigator.push(context, MaterialPageRoute(
                                       builder: (BuildContext context) {
                                         return ListeGroupe();
                                       },
                                     ));
                                   },),
                                 CupertinoDialogAction(child: Text("Créer"),
                                   onPressed: () {
                                    Navigator.push(context,MaterialPageRoute(
                                        builder: (BuildContext context){
                                          return CreationGroupe();
                                        }
                                    )) ;
                                   },)
                               ],

                             );

                           },
                         );
                       }
                     }),
               )
                    ),

                SizedBox(height: 20,),
                Padding(padding: EdgeInsets.only(left: 30),
                child: Container(
                  width: 350,
                  child: FloatingActionButton.extended(
                    heroTag: "btn2",
                      backgroundColor: Colors.white,
                      elevation: 20,
                      splashColor: Colors.redAccent,

                      icon: Icon(Icons.accessibility_new),
                      label: Text(
                          "Blog"
                      ),

                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Blog();
                          },
                        ));
                      }),
                ),),
                SizedBox(height: 20,),
                Padding(padding: EdgeInsets.only(left: 30),
                  child: Container(
                    width: 350,
                    child: FloatingActionButton.extended(
                        heroTag: "btn5",
                        backgroundColor: Colors.white,
                        elevation: 20,
                        splashColor: Colors.redAccent,

                        icon: Icon(Icons.shopping_cart_rounded),
                        label: Text(
                            "Boutique"
                        ),

                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Blog();
                            },
                          ));
                        }),
                  ),),
              ],
            ),
          )
        ],
      ),
    );
  }
}
