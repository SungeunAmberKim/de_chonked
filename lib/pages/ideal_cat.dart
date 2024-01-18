import 'package:de_chonked/pages/food_calorie.dart';
import 'package:de_chonked/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:de_chonked/pages/ideal_cat.dart';

import 'add_cat.dart';

class IdealCatPage extends StatefulWidget {
  final int catId;
  const IdealCatPage(this.catId, {super.key});

  @override
  _IdealCatPageState createState() => _IdealCatPageState();
}

class _IdealCatPageState extends State<IdealCatPage> {
  var currentWeight;
  var idealWeight;
  var idealCalorie;
  var chonk;
  var age;
  var nut;
  var catList = [];

  @override
  void initState() {
    super.initState();
    refreshCatList();
  }
  void refreshCatList(){
    FirebaseDatabase.instance.ref().child("cats/cat$catId").once()
        .then((datasnapshot){
      //print("successfully loaded data");

      //print("Interating the value map: ");
      var catTmpList = [];

      Map<dynamic, dynamic> values = datasnapshot.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((k,v){
        //print(k);
        //print(v);
        catTmpList.add(v);
      });
      //print("Final friend list: ");
      //print(catTmpList);
      catList = catTmpList;
      setState(() {

      });

    }).catchError((error){
      print("failed to load the data");
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                color: Colors.blueGrey[200],
                child: Text(
                  '${catList[2].toString()}',
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text('Done')
              )
            ],
          )
      ),
    );
  }
}