import 'package:flutter/widgets.dart';
import 'package:hang_royal/guess_word_generator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enum_collection.dart';

class GameStageBloc {
  ValueNotifier<GameState> curGameState =
      ValueNotifier<GameState>(GameState.idle);
  ValueNotifier<String> curGuessWord = ValueNotifier<String>('');
  ValueNotifier<List<BodyParts>> hangingBodyParts =
      ValueNotifier<List<BodyParts>>([]);
  var _guessedCharacterController = BehaviorSubject<List<String>>();
  Stream<List<String>> get guessedLetters => _guessedCharacterController.stream;
  var _hangingBodyPartsController = BehaviorSubject<int>();
  Stream<int> get hangingParts => _hangingBodyPartsController.stream;
  ValueNotifier<PlayableCharacters> curPlayableCharacter =
      ValueNotifier<PlayableCharacters>(PlayableCharacters.orc);

  ValueNotifier<FreezeState> curFreezeState =
      ValueNotifier<FreezeState>(FreezeState.none);

  ValueNotifier<int> curLevel = ValueNotifier<int>(0);

  ValueNotifier<bool> selectedCategory = ValueNotifier<bool>(false);

  void _incrementLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int _level = (prefs.getInt('level') ?? 0) + 1;
    prefs.setInt('level', _level);
    curLevel.value = _level;
  }

  void resetBodyParts() {
    hangingBodyParts.value.clear();
    _hangingBodyPartsController.sink.add(0);
  }

  void freezeBodyParts() {
    if (curFreezeState.value == FreezeState.none) {
      curFreezeState.value = FreezeState.cracks_none;
    }
  }

  void setGuessWord(String incomingWord) {
    curGuessWord.value = incomingWord;
    selectedCategory.value = true;
  }

  void createGuessWord(String category) {
    GuessWordGenerator().generateWordFromCategory(category, this);
  }

  void updateFreezeBodyParts() {
    switch (curFreezeState.value) {
      case FreezeState.none:
        curFreezeState.value = FreezeState.cracks_none;
        break;
      case FreezeState.cracks_none:
        curFreezeState.value = FreezeState.cracks_one;
        break;
      case FreezeState.cracks_one:
        curFreezeState.value = FreezeState.cracks_two;
        break;
      case FreezeState.cracks_two:
        curFreezeState.value = FreezeState.cracks_three;
        break;
      case FreezeState.cracks_three:
        curFreezeState.value = FreezeState.none;
        break;
      case FreezeState.explode:
        curFreezeState.value = FreezeState.none;
        break;
      default:
        curFreezeState.value = FreezeState.none;
    }
  }

  void revealLetter() {
    List<String> curGuessedLetters = _guessedCharacterController.value;
    List splitted = curGuessWord.value.split('');
    bool revealed = false;
    splitted.forEach((element) {
      if (!revealed && element != ' ') {
        if (!curGuessedLetters.contains(element)) {
          revealed = true;
          List<String> updatedGuessedLetters = curGuessedLetters;
          updatedGuessedLetters.add(element);
          _guessedCharacterController.sink.add(updatedGuessedLetters);
          _checkIfWon(updatedGuessedLetters);
          return;
        }
      }
    });
  }

  void createNewGame() {
    curGameState.value = GameState.running;
    curPlayableCharacter.value = PlayableCharacters.orc;
    hangingBodyParts.value.clear();
    var guessWord = GuessWordGenerator().generateWord();
    curGuessWord.value = guessWord;
    _guessedCharacterController.sink.add([]);
    _hangingBodyPartsController.sink.add(0);
    curFreezeState.value = FreezeState.none;
    selectedCategory.value = false;
  }

  void endGame() {
    curGameState.value = GameState.idle;
    hangingBodyParts.value.clear();
    var guessWord = '';
    curGuessWord.value = guessWord;
    _guessedCharacterController.sink.add([]);
    _hangingBodyPartsController.sink.add(0);
    curFreezeState.value = FreezeState.none;
    selectedCategory.value = false;
  }

  void updateGuessedLetter(List<String> updatedGuessedLetters) {
    _guessedCharacterController.sink.add(updatedGuessedLetters);
    _checkIfWon(updatedGuessedLetters);
  }

  void updateLevel(int level) {
    curLevel.value = level;
  }

  void updatePlayableCharacter(PlayableCharacters playableCharacter) {
    curPlayableCharacter.value = playableCharacter;
  }

  void _checkIfWon(List<String> guessedLetters) {
    var letters =
        curGuessWord.value.replaceAll(new RegExp(r"\s+"), "").split('');
    var won = true;
    letters.forEach((letter) {
      if (!guessedLetters.contains(letter)) {
        won = false;
        return;
      }
    });
    if (won) {
      curGameState.value = GameState.succeeded;
      _incrementLevel();
    }
  }

  void updateHangingBodyParts() {
    if (curFreezeState.value != FreezeState.none) {
      updateFreezeBodyParts();
      return;
    }
    if (!hangingBodyParts.value.contains(BodyParts.head)) {
      hangingBodyParts.value.add(BodyParts.head);
      _hangingBodyPartsController.sink.add(1);
      return;
    }
    if (!hangingBodyParts.value.contains(BodyParts.body)) {
      hangingBodyParts.value.add(BodyParts.body);
      _hangingBodyPartsController.sink.add(2);
      return;
    }
    if (!hangingBodyParts.value.contains(BodyParts.arm_left)) {
      hangingBodyParts.value.add(BodyParts.arm_left);
      _hangingBodyPartsController.sink.add(3);

      return;
    }
    if (!hangingBodyParts.value.contains(BodyParts.arm_right)) {
      hangingBodyParts.value.add(BodyParts.arm_right);
      _hangingBodyPartsController.sink.add(4);

      return;
    }
    if (!hangingBodyParts.value.contains(BodyParts.leg_left)) {
      hangingBodyParts.value.add(BodyParts.leg_left);
      _hangingBodyPartsController.sink.add(5);

      return;
    }
    if (!hangingBodyParts.value.contains(BodyParts.leg_right)) {
      hangingBodyParts.value.add(BodyParts.leg_right);
      _hangingBodyPartsController.sink.add(6);

      curGameState.value = GameState.failed;
      return;
    }
  }

  dispose() {
    _guessedCharacterController.close();
    _hangingBodyPartsController.close();
  }
}
