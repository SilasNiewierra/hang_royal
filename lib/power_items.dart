import 'package:flutter/material.dart';
import 'package:hang_royal/game_stage_bloc.dart';
import 'package:hang_royal/enum_collection.dart';

// import 'game_stage_bloc.dart';

class PowerItems extends StatefulWidget {
  final GameStageBloc gameStageBloc;

  PowerItems({@required this.gameStageBloc});

  @override
  _PowerItemsState createState() => _PowerItemsState();
}

class _PowerItemsState extends State<PowerItems> {
  String baseAssetUrl = "assets/images/power_items/";
  List powers = [
    ['Freeze', 'power-freeze.png', Powers.freeze],
    [
      'Crystal',
      'power-cristal.png',
      Powers.reveal,
    ],
    [
      'Wand',
      'power-wand.png',
      Powers.reset,
    ],
  ];

  void selectPower(Powers powerItems) {
    switch (powerItems) {
      case Powers.freeze:
        widget.gameStageBloc.freezeBodyParts();
        break;
      case Powers.reset:
        widget.gameStageBloc.resetBodyParts();
        break;
      case Powers.reveal:
        widget.gameStageBloc.revealLetter();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 80,
        transform: Matrix4.translationValues(0.0, -120.0, 0.0),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
              powers.length,
              (index) => _buildPowerItem(
                  powers[index][0], powers[index][1], powers[index][2])),
        ),
      ),
    );
  }

  Widget _buildPowerItem(String name, String assetUrl, Powers powerFunction) {
    String imageUrl = baseAssetUrl + assetUrl;
    return Container(
      width: 60.0,
      height: 60.0,
      child: FlatButton(
        child: Image.asset(imageUrl),
        onPressed: () {
          selectPower(powerFunction);
          // onPowerOne();
        },
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(-5, 5),
          ),
        ],
      ),
    );
  }
}
