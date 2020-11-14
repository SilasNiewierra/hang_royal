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

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      List.generate(alphabetLettersLineOne.length, (index) {
                    return _buildLetterButton(
                        guessedLettersSnap.data, alphabetLettersLineOne[index]);
                  }),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      List.generate(alphabetLettersLineTwo.length, (index) {
                    return _buildLetterButton(
                        guessedLettersSnap.data, alphabetLettersLineTwo[index]);
                  }),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      List.generate(alphabetLettersLineThree.length, (index) {
                    return _buildLetterButton(guessedLettersSnap.data,
                        alphabetLettersLineThree[index]);
                  }),
                ),
              ),
            ],
          );
        });
  }

  Widget _buildLetterButton(List<String> guessedLetters, String letter) {
    letter = letter.toUpperCase();
    return GestureDetector(
      onTap: () {
        if (!guessedLetters.contains(letter.toUpperCase())) {
          guessedLetters.add(letter);
          widget.gameStageBloc.updateGuessedLetter(guessedLetters);

          if (widget.gameStageBloc.curGuessWord.value.indexOf(letter) < 0) {
            widget.gameStageBloc.updateHangingBodyParts();
          }
        }
      },
      child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
              color: guessedLetters.contains(letter)
                  ? Colors.grey.withOpacity(0.6)
                  : Colors.grey[800],
              borderRadius: BorderRadius.circular(4.0)),
          child: Center(child: Text(letter))),
    );
  }
}
