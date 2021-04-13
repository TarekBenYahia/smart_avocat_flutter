import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_avocat/ListeGroupe.dart';

class more extends StatelessWidget {
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

                SizedBox(height: 20,),
                Container(
                  width: 350,
                  child: FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      elevation: 20,
                      splashColor: Colors.redAccent,

                      icon: Icon(Icons.accessibility_new),
                      label: Text(
                          "Blog"
                      ),

                      onPressed: (){}),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
