import 'package:flutter/material.dart';
import 'package:hang_royal/game_stage_bloc.dart';
import 'package:hang_royal/enum_collection.dart';
import 'package:hang_royal/hangman_graphic.dart';
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
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildGraphics(),
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
      child: HangmanGraphic(gameStageBloc: _gameStageBloc),
    );
  }

  Widget _buildIntro() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(30.0),
            child: Image.asset('assets/images/texts/game-title.png'),
          ),
          _buildNewGameButton()
        ],
      ),
    );
  }

  Widget _buildEnd(GameState gameState) {
    if (gameState == GameState.failed) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildGraphics(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("GAME OVER"),
                  Text("The word was: " + _gameStageBloc.curGuessWord.value),
                  _buildNewGameButton(),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (gameState == GameState.succeeded) {
      return Center(
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
      child: FlatButton(
        onPressed: () {
          _gameStageBloc.createNewGame();
        },
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Image.asset("assets/images/buttons/new-game-button.png"),
      ),
    );
  }
}
