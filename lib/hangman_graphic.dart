import 'package:flutter/material.dart';
// import 'package:hang_royal/enum_collection.dart';

import 'game_stage_bloc.dart';

class HangmanGraphic extends StatefulWidget {
  final GameStageBloc gameStageBloc;

  const HangmanGraphic({Key key, @required this.gameStageBloc})
      : super(key: key);

  @override
  _HangmanGraphicState createState() => _HangmanGraphicState();
}

class _HangmanGraphicState extends State<HangmanGraphic> {
  String getAssetUrl(int hangingStatus) {
    String baseUrl = 'assets/images/hang_characters/orc/';

    switch (hangingStatus) {
      case 1:
        return baseUrl + 'orc-head.png';
        break;
      case 2:
        return baseUrl + 'orc-body.png';
        break;
      case 3:
        return baseUrl + 'orc-arm-left.png';
        break;
      case 4:
        return baseUrl + 'orc-arm-right.png';
        break;
      case 5:
        return baseUrl + 'orc-leg-left.png';
        break;
      case 6:
        return baseUrl + 'orc-leg-right.png';
        break;
      default:
        return baseUrl + 'orc-default.png';
    }

    // if (widget.gameStageBloc.hangingBodyParts.value
    //     .contains(BodyParts.leg_right)) {
    //   return baseUrl + 'orc-leg-right.png';
    // } else if (widget.gameStageBloc.hangingBodyParts.value
    //     .contains(BodyParts.leg_left)) {
    //   return baseUrl + 'orc-leg-left.png';
    // } else if (widget.gameStageBloc.hangingBodyParts.value
    //     .contains(BodyParts.arm_right)) {
    //   return baseUrl + 'orc-arm-right.png';
    // } else if (widget.gameStageBloc.hangingBodyParts.value
    //     .contains(BodyParts.arm_left)) {
    //   return baseUrl + 'orc-arm-left.png';
    // } else if (widget.gameStageBloc.hangingBodyParts.value
    //     .contains(BodyParts.body)) {
    //   return baseUrl + 'orc-body.png';
    // } else if (widget.gameStageBloc.hangingBodyParts.value
    //     .contains(BodyParts.head)) {
    //   return baseUrl + 'orc-head.png';
    // } else {
    //   return '';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.gameStageBloc.hangingParts,
        builder: (BuildContext ctx, AsyncSnapshot<int> hangingStatus) {
          return Center(
            child: Container(
              width: 100,
              child: Image.asset(getAssetUrl(hangingStatus.data)),
            ),
          );
        });
  }
}