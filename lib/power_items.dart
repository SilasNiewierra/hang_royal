import 'package:flutter/material.dart';

import 'game_stage_bloc.dart';

class PowerItems extends StatefulWidget {
  @override
  _PowerItemsState createState() => _PowerItemsState();
}

class _PowerItemsState extends State<PowerItems> {
  List powerItems = [
    ['Poison', '/power-item-poison.png'],
    ['Wand', '/power-item-wand.png'],
    ['Crystal', '/power-item-crystal.png'],
    ['Lamp', '/power-item-lamp.png'],
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 100,
        transform: Matrix4.translationValues(0.0, -150.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: List.generate(
              powerItems.length,
              (index) =>
                  _buildPowerItem(powerItems[index][0], powerItems[index][1])),
        ),
      ),
    );
  }
}

Widget _buildPowerItem(String name, String assetUrl) {
  print(name + assetUrl.toString());
  return Container();
  //   width: 60.0,
  //   height: 60.0,
  //   child: FlatButton(
  //     child: Image.asset(assetUrl),
  //     onPressed: () {
  //       // onPowerOne();
  //     },
  //     highlightColor: Colors.yellow.withOpacity(0.5),
  //     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //   ),
  //   decoration: BoxDecoration(
  //     color: Colors.red.withOpacity(0),
  //     shape: BoxShape.rectangle,
  //     borderRadius: BorderRadius.only(
  //       topLeft: Radius.circular(10.0),
  //       topRight: Radius.circular(10.0),
  //       bottomLeft: Radius.circular(10.0),
  //       bottomRight: Radius.circular(10.0),
  //     ),
  //     boxShadow: [
  //       BoxShadow(
  //         color: Colors.black.withOpacity(0.3),
  //         spreadRadius: 1,
  //         blurRadius: 10,
  //         offset: Offset(-5, 5),
  //       ),
  //     ],
  //   ),
  // );
}
