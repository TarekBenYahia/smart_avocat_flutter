import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_avocat/PaymentClient.dart';
import 'package:stripe_payment/stripe_payment.dart';

class CheckList extends StatefulWidget {
  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ma CheckList" ),
      ),
      drawer: Drawer(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Menu"),
          ),
          body: ListTile(
            title: Text("Menu Principal"),


            onTap: () {
              Navigator.pushNamed(context, "/bottomAvocat");
            },
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 15,),
          Center(
            child: Text("CheckList",style: TextStyle(
                fontSize: 30
            ),),
          ),
          SizedBox(height: 50,),
          FloatingActionButton.extended(
            heroTag: "btn1",
              backgroundColor: Colors.white,
              elevation: 10,
              splashColor: Colors.redAccent,

              icon: Icon(Icons.check_box,color: Colors.green,size: 40,),
              label: Text(
                  "Demande De Rendez-Vous"
              ),

              onPressed: null),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton.extended(
            heroTag: "btn2",
              backgroundColor: Colors.white,
              elevation: 10,
              splashColor: Colors.redAccent,


              icon: Icon(Icons.check_box,color: Colors.green,size: 40,),
              label: Text(

                  "  Rendez-Vous Accepté      "
              ),

              onPressed: null),
          SizedBox(height: 20,),
          FloatingActionButton.extended(
            heroTag: "btn3",
              backgroundColor: Colors.white,
              elevation: 10,
              splashColor: Colors.redAccent,


              icon: Icon(Icons.check_box_outline_blank,color: Colors.green,size: 40,),
              label: Text(

                  "        Paiement                  "
              ),

              onPressed: null),
          SizedBox(height: 250,),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
                backgroundColor: Colors.redAccent,
                elevation: 10,
                splashColor: Colors.redAccent,
                icon: Icon(Icons.payment_sharp,color: Colors.white,size: 40,),
                label: Text(

                    "Payer"
                ),

                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentClient()),
                  );
                }),
          ),


        ],
      ),
    );
  }
}
