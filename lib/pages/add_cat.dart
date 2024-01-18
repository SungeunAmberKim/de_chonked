import 'package:de_chonked/pages/chonker_o_meter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:de_chonked/pages/chonker_o_meter.dart';



class AddCatPage extends StatefulWidget {
  const AddCatPage({super.key});

  @override
  State<AddCatPage> createState() => _AddCatPageState();
}
var nameController = TextEditingController();
var neutered = 0;
var bigboy = 0;
int weight = 0;
var catId = 0;


class _AddCatPageState extends State<AddCatPage> {
  // var nameController = TextEditingController();
  // var weightController = TextEditingController();
  // var typeController = TextEditingController();
  // var neutered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple[100],
        appBar: AppBar(
          title: Text('Add a new cat'), // need to adjust font and position
          elevation: 0,
        ),
        body: Center(
            child: ListView(
              children: [
                TextField(
                  controller: nameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                CupertinoButton(
                    child: Text('$weight lbs'),
                    onPressed: () => showCupertinoModalPopup(
                        context: context,
                        builder: (_) => SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: CupertinoPicker(
                            backgroundColor: Colors.white,
                            itemExtent: 30,
                            scrollController: FixedExtentScrollController(
                              initialItem: 0,
                            ),
                            children: [
                              Text('0'),
                              Text('1'),
                              Text('2'),
                              Text('3'),
                              Text('4'),
                              Text('5'),
                              Text('6'),
                              Text('7'),
                              Text('8'),
                              Text('9'),
                              Text('10'),
                              Text('11'),
                              Text('12'),
                              Text('13'),
                              Text('14'),
                              Text('15'),
                              Text('16'),
                              Text('17'),
                              Text('18'),
                              Text('19'),
                              Text('20'),
                              Text('21'),
                              Text('22'),
                              Text('23'),
                              Text('24'),
                              Text('25'),
                              Text('26'),
                              Text('27'),
                              Text('28'),
                              Text('29'),
                              Text('30'),
                            ],
                            onSelectedItemChanged: (int value){
                              setState(() {
                                weight = value;
                              });
                            },
                          ),
                        )
                    ),
                ),

                AgeChoice(),
                NutChoice(),
                ElevatedButton(
                    onPressed: () {

                      var timestamp = new DateTime.now().millisecondsSinceEpoch;
                      catId = timestamp;
                      FirebaseDatabase.instance.ref().child("cats/cat$timestamp").set(
                          {
                            "name" : nameController.text,
                            "weight" : weight,
                            "nuetered" : neutered,
                            "bigboy" : bigboy,
                          }
                      ).then((value) {
                        print("sucessfully added the friend");
                      }).catchError((error) {
                        print("failed to add. " + error.toString());
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chonk_O_MeterPage(catId)),
                      );
                    },
                    child: Text('Save')
                )

              ],
            )
        )
    );
  }
  
}

enum Age { kitten, adult }

class AgeChoice extends StatefulWidget {
  const AgeChoice({super.key});

  @override
  State<AgeChoice> createState() => _AgeChoiceState();
}

class _AgeChoiceState extends State<AgeChoice> {
  Age bigBoy = Age.kitten;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Age>(
      segments: const <ButtonSegment<Age>>[
        ButtonSegment<Age>(
            value: Age.kitten,
            label: Text('Kitten'),
            ),
        ButtonSegment<Age>(
            value: Age.adult,
            label: Text('Adult'),
            ),
      ],
      selected: <Age>{bigBoy},
      onSelectionChanged: (Set<Age> newSelection) {
        setState(() {
          bigBoy = newSelection.first;
        });
        if(bigBoy != Age.kitten){
          bigboy = 1;
        } else {
          bigboy = 0;
        }
      },
    );
  }
}

enum Nut { neutered, intact }

class NutChoice extends StatefulWidget {
  const NutChoice({super.key});

  @override
  State<NutChoice> createState() => _NutChoiceState();
}

class _NutChoiceState extends State<NutChoice> {
  Nut nutNonut = Nut.intact;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Nut>(
      segments: const <ButtonSegment<Nut>>[
        ButtonSegment<Nut>(
            value: Nut.neutered,
            label: Text('Neutered'),
            icon: Icon(Icons.check_circle)),
        ButtonSegment<Nut>(
            value: Nut.intact,
            label: Text('Intact'),
            icon: Icon(Icons.cancel)),
      ],
      selected: <Nut>{nutNonut},
      onSelectionChanged: (Set<Nut> newSelection) {
        setState(() {
          nutNonut = newSelection.first;
        });
        if(nutNonut != Nut.intact){
          neutered = 1;
        } else {
          neutered = 0;
        }
      },
    );
  }
}
