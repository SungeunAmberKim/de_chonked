import 'package:de_chonked/pages/food_calorie.dart';
import 'package:de_chonked/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:de_chonked/pages/ideal_cat.dart';

import 'add_cat.dart';

class InfoPage extends StatefulWidget {
  final int catId;
  const InfoPage(this.catId, {super.key});

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  var currentWeight;
  var idealWeight;
  var idealCalorie;
  var chonk;
  var age;
  var nut;
  Map<int, int> RERValues = {};
  Map<String, dynamic> catData = {};

  @override
  void initState() {
    super.initState();
    fetchRERValues();
    fetchCatData();
  }

  void fetchRERValues() async {
    try {
      var snapshot = await FirebaseDatabase.instance.ref().child("RER").once();
      var data = snapshot.snapshot.value as List<dynamic>;
      print("Raw RER data from Firebase: $data");

      RERValues.clear();
      for (int i = 0; i < data.length; i++) {
        if (data[i] != null) {
          RERValues[i] = int.tryParse(data[i].toString()) ?? 0; // Add to RERValues map
        }
      }
      print("Fetched RER data: $RERValues");
    } catch (e) {
      print("Error fetching RER data: $e");
    }
  }

  void fetchCatData() async {
    try {
      var snapshot = await FirebaseDatabase.instance.ref().child("cats/cat${widget.catId}").once();
      var data = snapshot.snapshot.value;

      // Check if data is actually a Map and not null
      if (data is Map) {
        catData.clear();
        data.forEach((key, value) {
          // Ensure keys are converted to String and handle potential null values
          catData[key.toString()] = value ?? "Unknown";
        });

        print("Fetched cat data: $catData");
        processCatData();
      } else {
        print("No valid data found for catId: ${widget.catId}");
      }
    } catch (e) {
      print("Error fetching cat data: $e");
    }
  }

  void processCatData() {
    if (catData.containsKey('weight') && catData.containsKey('Chonkiness')) {
      // Convert 'weight' to double
      currentWeight = (catData['weight'] is int ? catData['weight'].toDouble() : catData['weight']);

      chonk = catData['Chonkiness'] is int ? catData['Chonkiness'] : int.parse(catData['Chonkiness'].toString());
      age = catData['bigboy'] is int ? catData['bigboy'] : int.parse(catData['bigboy'].toString());
      nut = catData['nuetered'] is int ? catData['nuetered'] : int.parse(catData['nuetered'].toString());

      idealWeight = calculateIdealWeight(age, chonk, currentWeight);
      idealCalorie = calculateIdealCalorie(age, chonk, currentWeight, nut);
      print("Calculated ideal weight: $idealWeight");
      setState(() {});
    } else {
      print("Required keys not found in catData");
    }
  }

  double calculateIdealWeight(var age, int chonkiness, var weight) {
    if(age > 0) {
        return weight;
      } else {
      switch (chonkiness) {
        case 5:
          return weight;
        case 6:
          return weight * 0.9;
        case 7:
          return weight * 0.8;
        case 8:
          return weight * 0.7;
        case 9:
          return weight * 0.6;
        default:
          return weight;
      }
    }
  }

  double calculateIdealCalorie(var age, int chonkiness, var weight, var nut) {
    int weightKey = weight.round();
    // checking if weight is in RERValues
    if(!RERValues.containsKey(weightKey)){
      print("RER does not contain weight: $weightKey");
      return 0;
    }

    var baseCal = RERValues[weight];
    var tmpWeight;

    var cal;
    if (age < 1) { // kitten
      cal = baseCal! * 2.5;
      return cal;
    } else if (age > 0 && chonkiness < 6 &&
        nut < 1) { // adult, not chonky, not nuetered
      cal = (baseCal! * 1.4);
      return cal;
    } else if (age > 0 && chonkiness < 6 && nut > 0) { // adult, not chonky, nuetered
      cal = (baseCal! * 1.2);
      return cal;
    } else{ // chonky adult
      tmpWeight = weight * 0.99;
      baseCal = RERValues[tmpWeight];
      cal = baseCal;
      return cal;
    }
  }

  void saveToFirebase() {
    print("Saving ideal weight to Firebase: $idealWeight");
    FirebaseDatabase.instance.ref().child("cats/cat${widget.catId}").update(
        {
          "idealweight": idealWeight,
          "idealcalorie": idealCalorie,
        }
    ).then((value) {
      print("Successfully updated the data");

    }).catchError((error) {
      print("Failed to update. Error: " + error.toString());
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
                'blah$idealWeight'
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  saveToFirebase();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IdealCatPage(catId)),
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