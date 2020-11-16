import 'package:flutter/material.dart';
import 'package:hang_royal/game_stage_bloc.dart';

import 'enum_collection.dart';

class CharacterSelector extends StatefulWidget {
  final GameStageBloc gameStageBloc;

  CharacterSelector({@required this.gameStageBloc});

  @override
  _CharacterSelectorState createState() => _CharacterSelectorState();
}

class _CharacterSelectorState extends State<CharacterSelector> {
  String baseAssetUrl = "assets/images/hang_faces/";
  String assetEnding = ".png";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Second Route"),
      // ),
      body: createGrid(),
    );
  }

  Widget createGrid() {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(PlayableCharacters.values.length, (index) {
        String characterName = (PlayableCharacters.values[index])
            .toString()
            ?.split('.')
            ?.elementAt(1);
        return Center(
          child: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 100.0,
              height: 100.0,
              // color: Colors.red,
              child: FlatButton(
                onPressed: () {
                  widget.gameStageBloc.updatePlayableCharacter(
                      PlayableCharacters.values[index]);
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Image.asset(
                  baseAssetUrl + characterName + assetEnding,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
