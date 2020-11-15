import 'package:flutter/material.dart';
import 'package:hang_royal/game_stage_bloc.dart';
import 'package:hang_royal/enum_collection.dart';
import 'package:hang_royal/hangman_graphic.dart';
import 'package:hang_royal/power_items.dart';
import 'package:hang_royal/puzzle.dart';
import 'package:hang_royal/rive_template.dart';
import 'letter_picker.dart';

class GameStage extends StatefulWidget {
  @override
  _GameStageState createState() => _GameStageState();
}

class _GameStageState extends State<GameStage> {
  GameStageBloc _gameStageBloc;

  @override
  void initState() {
    super.initState();
    _gameStageBloc = GameStageBloc();
  }

  @override
  void dispose() {
    _gameStageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber,
      body: Container(
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //         begin: Alignment.topRight,
        //         end: Alignment.bottomLeft,
        //         colors: [Colors.blue, Colors.red])),
        child: _buildGameScreen(),
      ),
    );
  }

  Widget _buildGameScreen() {
    return ValueListenableBuilder(
        valueListenable: _gameStageBloc.curGuessWord,
        builder: (ctx, guessWord, child) {
          if (guessWord == null || guessWord == '') {
            return _buildIntro();
          }
          return ValueListenableBuilder(
              valueListenable: _gameStageBloc.curGameState,
              builder: (ctx, gameState, child) {
                if (gameState == GameState.succeeded ||
                    gameState == GameState.failed) {
                  return _buildEnd(gameState);
                }

                return _buildGame(guessWord);
              });
        });
  }

  Widget _buildGame(String guessWord) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(color: Colors.blue, child: _buildGraphics()),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
              child: Center(
                  child: Puzzle(
                      guessWord: guessWord, gameStageBloc: _gameStageBloc)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Stack(
                children: [
                  LetterPicker(gameStageBloc: _gameStageBloc),
                  // PowerItems(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphics() {
    return Stack(
      children: [
        HangmanGraphic(gameStageBloc: _gameStageBloc),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: 70,
            height: 70,
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 70.0,
                height: 70.0,
                // color: Colors.red,
                child: FlatButton(
                  onPressed: () {
                    // _gameStageBloc.endGame();
                  },
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.asset(
                    'assets/images/hang_faces/orc.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ), // later this will be the selector dart for a character
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              _gameStageBloc.endGame();
            },
            icon: Icon(Icons.clear),
          ),
        ),
      ],
    );

    // Column(
    //   children: [
    //     Container(
    //       width: 700,
    //       height: 500,
    //       // decoration: BoxDecoration(
    //       //   // image: DecorationImage(
    //       //   //   image: AssetImage('assets/images/graphics-background.png'),
    //       //   //   fit: BoxFit.cover,
    //       //   // ),
    //       //   color: Colors.white,
    //       //   borderRadius: BorderRadius.only(
    //       //     bottomLeft: Radius.circular(15.0),
    //       //     bottomRight: Radius.circular(15.0),
    //       //   ),
    //       //   boxShadow: [
    //       //     BoxShadow(
    //       //       color: Colors.black.withOpacity(0.3),
    //       //       spreadRadius: 5,
    //       //       blurRadius: 10,
    //       //       offset: Offset(0, 3),
    //       //     ),
    //       //   ],
    //       // ),
    //       child: HangmanGraphic(gameStageBloc: _gameStageBloc),
    //     ),
    //     Container(
    //       width: 70,
    //       height: 70,
    //       transform: Matrix4.translationValues(0.0, -35.0, 0.0),
    //       padding: EdgeInsets.all(0),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(10.0),
    //         color: Colors.white,
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.black.withOpacity(0.3),
    //             spreadRadius: 5,
    //             blurRadius: 10,
    //             offset: Offset(0, 3),
    //           ),
    //         ],
    //       ),
    //       child: Align(
    //         alignment: Alignment.topCenter,
    //         child: Container(
    //           width: 70.0,
    //           height: 70.0,
    //           // color: Colors.red,
    //           child: FlatButton(
    //             onPressed: () {
    //               _gameStageBloc.endGame();
    //             },
    //             padding: EdgeInsets.zero,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(10.0),
    //             ),
    //             child: Image.asset(
    //               'assets/images/hang_faces/orc.png',
    //               fit: BoxFit.fill,
    //             ),
    //           ),
    //         ),
    //       ), // later this will be the selector dart for a character
    //     )
    //   ],
    // );
  }

  Widget _buildIntro() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(30.0),
            child: Image.asset('assets/images/texts/flat-intro.png'),
          ),
          Container(
            height: 50,
          ),
          _buildNewGameButton()
        ],
      ),
    );
  }

  Widget _buildEnd(GameState gameState) {
    if (gameState == GameState.failed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // _buildGraphics(),
            Container(
              width: 300.0,
              height: 300.0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 300.0,
                  height: 300.0,
                  child: RiveTemplate(
                    assetName: 'orc.riv',
                    gameStageBloc: _gameStageBloc,
                  ),
                  // Image.asset('assets/images/texts/game-over.png')
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  "The word was: " + _gameStageBloc.curGuessWord.value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.grey[800]),
                ),
                _buildNewGameButton(),
              ],
            ),
            Container()
          ],
        ),
      );
    } else if (gameState == GameState.succeeded) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 500.0,
              height: 500.0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                    width: 500.0,
                    height: 500.0,
                    child: Image.asset('assets/images/texts/flat-won.png')),
              ),
            ),
            Container(
              height: 50,
            ),
            _buildNewGameButton(),
          ],
        ),
      );
    } else {
      return null;
    }
  }

  Widget _buildNewGameButton() {
    return Container(
      width: 200,
      height: 70,
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/buttons/button.png"),
              fit: BoxFit.fill)),
      child: FlatButton(
        onPressed: () {
          _gameStageBloc.createNewGame();
        },
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          'NEW GAME',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white,
              letterSpacing: 5.0),
        ),

        // child: Image.asset("assets/images/buttons/button.png"),
      ),
    );
  }
}
