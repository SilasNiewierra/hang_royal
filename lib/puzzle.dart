import 'package:flutter/material.dart';
import 'game_stage_bloc.dart';

class Puzzle extends StatefulWidget {
  final String guessWord;

  final GameStageBloc gameStageBloc;

  const Puzzle(
      {Key key, @required this.guessWord, @required this.gameStageBloc})
      : super(key: key);

  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.gameStageBloc.guessedLetters,
        builder: (ctx, AsyncSnapshot<List<String>> guessedLettersSnap) {
          if (!guessedLettersSnap.hasData) return CircularProgressIndicator();
          return Container(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(widget.guessWord.length, (index) {
                var letter = widget.guessWord[index];
                var hasBeenGuessed = guessedLettersSnap.data.contains(letter);

                return _buildLetterBox(letter, hasBeenGuessed);
              }),
            ),
          );
        });
  }
}

Widget _buildLetterBox(String letter, bool hasBeenGuessed) {
  return Container(
    width: 60.0,
    height: 60.0,
    decoration: BoxDecoration(
      color: Colors.amber[300],
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
        bottomRight: Radius.circular(10.0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: hasBeenGuessed
        ? Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.normal,
                  fontSize: 35.0,
                ),
              ),
            ),
          )
        : null,
  );
}
