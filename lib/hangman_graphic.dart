import 'package:flutter/material.dart';
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

  String getAssetUrl(int hangingStatus) {
    String baseUrl = 'assets/images/hang_characters/orc/';

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

  Widget selectGraphic(hangingStatus) {
    if (hangingStatus.data < 6) {
      return Image.asset(
        getAssetUrl(hangingStatus.data),
        fit: BoxFit.fill,
      );
    } else if (_artboard != null) {
      return Rive(
        artboard: _artboard,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        getAssetUrl(hangingStatus.data),
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
                child: selectGraphic(hangingStatus),
              ),
            ),
          );
        });
  }
}
