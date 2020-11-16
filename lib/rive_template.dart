import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

import 'game_stage_bloc.dart';

class RiveTemplate extends StatefulWidget {
  final GameStageBloc gameStageBloc;
  final String assetName;

  const RiveTemplate(
      {Key key, @required this.gameStageBloc, @required this.assetName})
      : super(key: key);

  @override
  _RiveTemplateState createState() => _RiveTemplateState();
}

class _RiveTemplateState extends State<RiveTemplate> {
  Artboard _artboard;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  // loads a Rive file
  void _loadRiveFile() async {
    final riveFileName = 'assets/rive/' + widget.assetName + '.riv';
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

  Widget selectGraphic(hangingStatus) {
    return _artboard != null
        ? Rive(artboard: _artboard, fit: BoxFit.fill)
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.gameStageBloc.hangingParts,
        builder: (BuildContext ctx, AsyncSnapshot<int> hangingStatus) {
          return Container(
            width: 550.0,
            height: 350.0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 350.0,
                height: 350.0,
                child: selectGraphic(hangingStatus),
              ),
            ),
          );
        });
  }
}
