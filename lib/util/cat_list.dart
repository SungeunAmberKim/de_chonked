import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:de_chonked/pages/home_page.dart';

class CatList extends StatelessWidget {
  String catName;
  double catWeight;
  bool catGender;
  bool catNut;
  bool catAge;
  Function(BuildContext)? deleteFunction;

  CatList({
    super.key,
    required this.catName,
    required this.catWeight,
    required this.catGender,
    required this.catNut,
    required this.catAge,
    required this.deleteFunction
  });



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 25.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(70),
          child: Row(
            children: [
              Text(catName,
              )
            ]
          ),
          decoration: BoxDecoration(
            color: Colors.purple[200],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
