import 'package:flutter/material.dart';
import 'package:hang_royal/character_selector.dart';
import 'package:hang_royal/game_stage_bloc.dart';
import 'package:hang_royal/enum_collection.dart';
import 'package:hang_royal/hangman_graphic.dart';
import 'package:hang_royal/power_items.dart';
import 'package:hang_royal/puzzle.dart';
import 'package:hang_royal/rive_template.dart';
import 'package:hang_royal/won_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'letter_picker.dart';

class GameStage extends StatefulWidget {
  @override
  _GameStageState createState() => _GameStageState();
}

class _GameStageState extends State<GameStage> {
  GameStageBloc _gameStageBloc;
  int _level = 0;
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _selectedItem = '';

  @override
  void initState() {
    super.initState();
    _gameStageBloc = GameStageBloc();
    _dropdownMenuItems = buildDropDownMenuItems();
    _selectedItem = _dropdownMenuItems[0].value;
    _loadLevel();
  }

  _loadLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _level = (prefs.getInt('level') ?? 0);
      _gameStageBloc.updateLevel(_level);
    });
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
            flex: 2,
            child: Container(
              // color: Colors.blue,
              child: _buildGraphics(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              // color: Colors.red,
              child: ValueListenableBuilder(
                valueListenable: _gameStageBloc.selectedCategory,
                builder: (ctx, hasSelected, widget) {
                  return hasSelected
                      ? Center(
                          child: Puzzle(
                              guessWord: guessWord,
                              gameStageBloc: _gameStageBloc),
                        )
                      : _buildCategoryDropdown();
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.green,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  LetterPicker(gameStageBloc: _gameStageBloc),
                  PowerItems(gameStageBloc: _gameStageBloc),
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
            width: 50,
            height: 50,
            margin: EdgeInsets.all(10.0),
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
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CharacterSelector(
                                gameStageBloc: _gameStageBloc,
                              )),
                    );
                  },
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: _gameStageBloc.curPlayableCharacter,
                    builder: (BuildContext context,
                        PlayableCharacters character, Widget child) {
                      return Image.asset(
                          'assets/images/hang_faces/' +
                              assetNameBuilder(character) +
                              '.png',
                          fit: BoxFit.fill);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            child: Container(
          margin: EdgeInsets.fromLTRB(70.0, 25, 0, 0),
          child: Text(
            _gameStageBloc.curLevel.value.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.grey[800]),
          ),
        )),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {
                _gameStageBloc.endGame();
              },
              icon: Icon(Icons.clear),
            ),
          ),
        ),
      ],
    );
  }

  String assetNameBuilder(PlayableCharacters character) {
    return character.toString().split('.').elementAt(1).split(')').elementAt(0);
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
      String characterName = _gameStageBloc.curPlayableCharacter
          .toString()
          .split('.')
          .elementAt(1)
          .split(')')
          .elementAt(0);
      return Center(
        child: Column(
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
                    assetName: characterName,
                    gameStageBloc: _gameStageBloc,
                  ),
                ),
              ),
            ),

            Column(
              children: [
                Container(
                  width: 250.0,
                  height: 250.0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        width: 250.0,
                        height: 250.0,
                        child: Image.asset(
                            'assets/images/texts/flat-game-over.png')),
                  ),
                ),
                _buildNewGameButton(),
                Text(
                  "The word was: " + _gameStageBloc.curGuessWord.value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.grey[800]),
                ),
                Text(
                  "Your current level is: " +
                      _gameStageBloc.curLevel.value.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.grey[800]),
                ),
              ],
            ),
            Container()
          ],
        ),
      );
    } else if (gameState == GameState.succeeded) {
      return WonScreen(
          button: _buildNewGameButton(), gameStageBloc: _gameStageBloc);
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

  Widget _buildCategoryDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
          value: _selectedItem,
          items: _dropdownMenuItems,
          onChanged: (value) {
            setState(() {
              _gameStageBloc.createGuessWord(value);
              _selectedItem = value;
            });
          }),
    );
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = List();
    for (var i = 0; i < GuessWordCategories.values.length; i++) {
      String categoryValue =
          GuessWordCategories.values[i].toString()?.split('.')?.elementAt(1);
      String cleanText = categoryValue.replaceAll("_", " ");
      String categoryText =
          "${cleanText[0].toUpperCase()}${cleanText.substring(1)}";
      items.add(
        DropdownMenuItem(
          child: Text(categoryText),
          value: categoryValue,
        ),
      );
    }
    return items;
  }
}
