import 'package:flutter/material.dart';
import 'package:hang_royal/game_stage_bloc.dart';

class LetterPicker extends StatefulWidget {
  final GameStageBloc gameStageBloc;

  const LetterPicker({Key key, @required this.gameStageBloc}) : super(key: key);

  @override
  _LetterPickerState createState() => _LetterPickerState();
}

class _LetterPickerState extends State<LetterPicker> {
  List<String> alphabetLettersLineOne = [
    'q',
    'w',
    'e',
    'r',
    't',
    'z',
    'u',
    'i',
    'o',
    'p',
  ];

  List<String> alphabetLettersLineTwo = [
    'a',
    's',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
  ];

  List<String> alphabetLettersLineThree = [
    'y',
    'x',
    'c',
    'v',
    'b',
    'n',
    'm',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.gameStageBloc.guessedLetters,
        builder: (ctx, AsyncSnapshot<List<String>> guessedLettersSnap) {
          if (!guessedLettersSnap.hasData) return CircularProgressIndicator();

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, -3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        List.generate(alphabetLettersLineOne.length, (index) {
                      return _buildLetterBox(guessedLettersSnap.data,
                          alphabetLettersLineOne[index]);
                    }),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        List.generate(alphabetLettersLineTwo.length, (index) {
                      return _buildLetterBox(guessedLettersSnap.data,
                          alphabetLettersLineTwo[index]);
                    }),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        List.generate(alphabetLettersLineThree.length, (index) {
                      return _buildLetterBox(guessedLettersSnap.data,
                          alphabetLettersLineThree[index]);
                    }),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildLetterBox(List<String> guessedLetters, String letter) {
    letter = letter.toUpperCase();
    return Container(
      width: 40.0,
      height: 40.0,
      child: FlatButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          letter,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 35.0,
              color: guessedLetters.contains(letter)
                  ? Colors.grey.withOpacity(0.6)
                  : Colors.grey[800]),
        ),
        onPressed: guessedLetters.contains(letter)
            ? null
            : () {
                guessedLetters.add(letter);
                widget.gameStageBloc.updateGuessedLetter(guessedLetters);

                if (widget.gameStageBloc.curGuessWord.value.indexOf(letter) <
                    0) {
                  widget.gameStageBloc.updateHangingBodyParts();
                }
              },
        highlightColor: Colors.black.withOpacity(0.5),
        padding: EdgeInsets.all(0.0),
      ),
      color: Colors.white.withOpacity(0),
    );
  }
}
