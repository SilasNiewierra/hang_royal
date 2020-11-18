import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import 'game_stage_bloc.dart';

class GuessWordGenerator {
  var _possibleWords = [
    "Aardvark",
    "Elephant",
    "GreyParrot",
    "Lion",
    "Dog",
    "Agout",
    "Albacore",
    "Albatross",
    "Alligator",
    "Allosaurus",
    "Badger",
    "Eagle",
    "Python",
    "Owl",
    "Beluga",
    "Duck",
    "Dolphin",
    "Snake",
    "Fish",
    "Shark",
    "Leopard",
    "Goat",
    "Squirrel",
    "Frog"
  ];

  String generateWord() {
    var randomGenerator = Random();
    var randomIndex = randomGenerator.nextInt(_possibleWords.length);

    return _possibleWords[randomIndex].toUpperCase();
  }

  generateWordFromCategory(String category, GameStageBloc gameStageBloc) async {
    String data = await rootBundle
        .loadString('assets/data/categories/' + category + '_guesswords.json');
    final jsonResult = json.decode(data);

    List _allWords = jsonResult['words'];
    var randomGenerator = Random();
    var randomIndex = randomGenerator.nextInt(_allWords.length);
    var guessWord = _allWords[randomIndex].toUpperCase();
    gameStageBloc.setGuessWord(guessWord);
  }
}
