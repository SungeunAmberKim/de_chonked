import 'package:de_chonked/pages/add_cat.dart';
import 'package:de_chonked/pages/cat_details_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../util/cat_list.dart';
import 'dart:math';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var catList = [];

  _HomePageState() {
    refreshCatList();
    FirebaseDatabase.instance.ref().child("cat").onChildChanged.listen((event) {
      refreshCatList();
    });
    FirebaseDatabase.instance.ref().child("cat").onChildRemoved.listen((event) {
      refreshCatList();
    });
    FirebaseDatabase.instance.ref().child("cat").onChildAdded.listen((event) {
      refreshCatList();
    });
  }

  void refreshCatList(){
    FirebaseDatabase.instance.ref().child("cat").once()
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
      appBar: AppBar(
        title: Text('DeChonked !'), // need to adjust font and position
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: catList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CatDetailsPage(catList[index])),
                );
              },
              title: Container(
                height: 50,
                margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:20),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage('${catList[index]['imageUrl']}'),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            '${catList[index]['name']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            )
                        ),
                        Text(
                          '${catList[index]['phone']}',
                        )
                      ],
                    ),
                    Spacer(),
                    Text(
                        '${catList[index]['type']}'
                    )
                  ],
                ),
              ),
            );
          }),




      // new cat
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddCatPage()),
        );},
        child: Icon(Icons.add),

      ),
      // probably have to fix later


    );
  }
}
