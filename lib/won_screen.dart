import 'package:flutter/material.dart';
import 'package:hang_royal/game_stage_bloc.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

class WonScreen extends StatefulWidget {
  final Widget button;
  final GameStageBloc gameStageBloc;

  const WonScreen(
      {Key key, @required this.gameStageBloc, @required this.button})
      : super(key: key);

  @override
  _WonScreenState createState() => _WonScreenState();
}

class _WonScreenState extends State<WonScreen> {
  final riveFileName = 'assets/rive/small_confetti.riv';
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
          SimpleAnimation('explosion'),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: [
              Container(
                width: 500.0,
                height: 500.0,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          width: 500.0,
                          height: 500.0,
                          child:
                              Image.asset('assets/images/texts/flat-won.png')),
                    ),
                  ],
                ),
              ),
              Container(
                width: 700,
                height: 500,
                child: _artboard != null
                    ? Rive(
                        artboard: _artboard,
                        fit: BoxFit.fitWidth,
                      )
                    : Container(),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "The word was: " + widget.gameStageBloc.curGuessWord.value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.grey[800]),
              ),
              widget.button,
            ],
          ),
        ],
      ),
    );
  }
}
