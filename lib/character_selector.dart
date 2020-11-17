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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Second Route"),
      // ),
      body: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: createGrid()),
    );
  }

  Widget createGrid() {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(PlayableCharacters.values.length, (index) {
        return Center(
          child: Container(
            width: 100.0,
            height: 100.0,
            child: ValueListenableBuilder(
                valueListenable: widget.gameStageBloc.curLevel,
                builder: (ctx, level, child) {
                  String characterName = 'lock';
                  if (level >= (index * 10)) {
                    characterName = (PlayableCharacters.values[index])
                        .toString()
                        ?.split('.')
                        ?.elementAt(1);
                  }
                  return FlatButton(
                    onPressed: () {
                      if (characterName != 'lock') {
                        widget.gameStageBloc.updatePlayableCharacter(
                            PlayableCharacters.values[index]);
                        Navigator.pop(context);
                      }
                    },
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          baseAssetUrl + characterName + ".png",
                          fit: BoxFit.fill,
                        ),
                        characterName == 'lock'
                            ? Positioned(
                                bottom: 0,
                                child: Text(
                                  (index * 10).toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 70.0),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                }),
          ),
        );
      }),
    );
  }
}
