import 'package:flutter/material.dart';

class CatDetailsPage extends StatefulWidget {


  var contactDetails;
  CatDetailsPage(this.contactDetails);

  @override
  State<CatDetailsPage> createState() => _CatDetailsPageState();
}

class _CatDetailsPageState extends State<CatDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Text("${widget.contactDetails['name']}"),
            Text("${widget.contactDetails['phone']}"),
            Text("${widget.contactDetails['type']}"),
            Text("${widget.contactDetails['imageUrl']}"),
          ],
        )
    );
  }
}
