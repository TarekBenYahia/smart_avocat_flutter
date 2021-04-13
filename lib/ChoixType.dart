

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class choixType  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Column(
          children:[
            SizedBox(
              height: 30,
            ),
            Image.asset("Assets/logo2.png",width: 180,),
            SizedBox(
              height: 20,
            ),
            Center(
            child: Text(
              "Vous êtes?",style: TextStyle(
                fontSize: 30
            ),
            ),

            ),
            SizedBox(
              height: 40,
            ),

            Row(
              children: [
                SizedBox(width: 25,),
                Image.asset("Assets/avocat.png",width: 120,),
                SizedBox(
                  width: 120,
                ),
                Image.asset("Assets/client.png",width: 120,height: 140,),

              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 55,
                ),
                RaisedButton(
                    child: Text("Avocat"),color:  Colors.red[800],
                    onPressed: (){}
                ),
                SizedBox(
                  width: 128,
                ),
                RaisedButton(
                    child: Text("Client"),
                    onPressed: (){}
                ),
              ],
            ),
          ],
        ),

    );
  }
}
