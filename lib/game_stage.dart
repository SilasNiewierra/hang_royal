import 'package:flutter/material.dart';
import 'package:hang_royal/game_stage_bloc.dart';
import 'package:hang_royal/enum_collection.dart';
import 'package:hang_royal/power_items.dart';
import 'package:hang_royal/puzzle.dart';
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
      backgroundColor: Colors.amber,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[_buildGraphics(), _buildGameField()],
        ),
      ),
    );
  }

  Widget _buildGraphics() {
    return Container(
      width: 700,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
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
    );
  }

  Widget _buildGameField() {
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
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Puzzle(guessWord: guessWord, gameStageBloc: _gameStageBloc),
                  ],
                ),
              ),
            ),
            Container(
              width: 700,
              height: 300,
              padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Stack(
                children: [
                  LetterPicker(gameStageBloc: _gameStageBloc),
                  PowerItems(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(30.0),
            child: Text(
              "Welcome to Hang-Royal!!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
          ),
          _buildNewGameButton()
        ],
      ),
    );
  }

  Widget _buildEnd(GameState gameState) {
    if (gameState == GameState.failed) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("GAME OVER"),
            Text("The word was: " + _gameStageBloc.curGuessWord.value),
            _buildNewGameButton(),
          ],
        ),
      );
    } else if (gameState == GameState.succeeded) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("YAY, congratulations! You guessed it"),
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
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: FlatButton(
        onPressed: () {
          _gameStageBloc.createNewGame();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            "New Game".toUpperCase(),
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
