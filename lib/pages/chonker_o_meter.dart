import 'package:de_chonked/pages/ideal_cat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:de_chonked/pages/add_cat.dart';

import 'info_page.dart';

class Chonk_O_MeterPage extends StatefulWidget {
  const Chonk_O_MeterPage(int catId, {super.key});

  @override
  State<Chonk_O_MeterPage> createState() => _Chonk_O_MeterPageState();
}

int chonkiness = 5;

class _Chonk_O_MeterPageState extends State<Chonk_O_MeterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: Text('Chonk-O-Meter'), // need to adjust font and position
        // elevation: 0,
      ),
      body: Center(
        child: ListView(
          children: [
            Image(
              image: AssetImage('assets/dummy.jpeg'),
              fit: BoxFit.cover,
            ),
            CupertinoButton(
              child: Text('$chonkiness'),
              onPressed: () => showCupertinoModalPopup(
                  context: context,
                  builder: (_) => SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent:30,
                      scrollController: FixedExtentScrollController(

                      ),
                      children: [
                        Text('5'),
                        Text('6'),
                        Text('7'),
                        Text('8'),
                        Text('9'),
                      ],
                      onSelectedItemChanged: (int value){
                        setState(() {
                          chonkiness = value+5;
                        });
                      },
                    )
                  )
              ),
            ),
            ElevatedButton(
                onPressed: () {

                  FirebaseDatabase.instance.ref().child("cats/cat$catId").update(
                      {
                        "Chonkiness" : chonkiness,
                      }
                  ).then((value) {
                    print("sucessfully added the friend");
                  }).catchError((error) {
                    print("failed to add. " + error.toString());
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfoPage(catId)),
                  );
                },
                child: Text('Continue')
            )



          ],
        ),
      ),

    );
  }
}
