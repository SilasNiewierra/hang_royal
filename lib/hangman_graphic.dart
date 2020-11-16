import 'package:flutter/material.dart';
import 'package:hang_royal/enum_collection.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

import 'game_stage_bloc.dart';

class HangmanGraphic extends StatefulWidget {
  final GameStageBloc gameStageBloc;

  const HangmanGraphic({Key key, @required this.gameStageBloc})
      : super(key: key);

  @override
  _HangmanGraphicState createState() => _HangmanGraphicState();
}

class _HangmanGraphicState extends State<HangmanGraphic> {
  final riveFileName = 'assets/rive/orc.riv';
  Artboard _artboard;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  // loads a Rive file
  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      // Select an animation by its name
      setState(() => _artboard = file.mainArtboard
        ..addController(
          SimpleAnimation('dead'),
        ));
    }
  }

  String getAssetUrl(int hangingStatus, String character) {
    String characterName = character?.split('.')?.elementAt(1).toString();
    String baseUrl = 'assets/images/hang_characters/' + characterName + '/';

    switch (hangingStatus) {
      case 1:
        return baseUrl + 'head.png';
        break;
      case 2:
        return baseUrl + 'body.png';
        break;
      case 3:
        return baseUrl + 'arm-left.png';
        break;
      case 4:
        return baseUrl + 'arm-right.png';
        break;
      case 5:
        return baseUrl + 'leg-left.png';
        break;
      case 6:
        return baseUrl + 'leg-right.png';
        break;
      default:
        return baseUrl + 'default.png';
    }
  }

  Widget selectGraphic(hangingStatus, PlayableCharacters character) {
    if (hangingStatus != null && hangingStatus.data != null) {
      if (hangingStatus.data < 6) {
        return Image.asset(
          getAssetUrl(hangingStatus.data, character.toString()),
          fit: BoxFit.fill,
        );
      } else if (_artboard != null) {
        return Rive(
          artboard: _artboard,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          getAssetUrl(hangingStatus.data, character.toString()),
          fit: BoxFit.fill,
        );
      }
    } else {
      return Image.asset(
        'assets/images/hang_characters/orc/default.png',
        fit: BoxFit.fill,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.gameStageBloc.hangingParts,
        builder: (BuildContext ctx, AsyncSnapshot<int> hangingStatus) {
          return Container(
            // width: 350.0,
            height: 250.0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                // width: 350.0,
                height: 250.0,
                child: ValueListenableBuilder(
                  valueListenable: widget.gameStageBloc.curPlayableCharacter,
                  builder: (BuildContext context, PlayableCharacters character,
                      Widget child) {
                    return selectGraphic(hangingStatus, character);
                  },
                ),
              ),
            ),
          );
        });
  }
}
