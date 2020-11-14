import 'package:flutter/widgets.dart';
import 'package:hang_royal/guess_word_generator.dart';
import 'package:rxdart/rxdart.dart';

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

  void createNewGame() {
    curGameState.value = GameState.running;
    hangingBodyParts.value.clear();
    var guessWord = GuessWordGenerator().generateWord();
    curGuessWord.value = guessWord;
    _guessedCharacterController.sink.add([]);
    _hangingBodyPartsController.sink.add(0);
  }

  void updateGuessedLetter(List<String> updatedGuessedLetters) {
    _guessedCharacterController.sink.add(updatedGuessedLetters);
    _checkIfWon(updatedGuessedLetters);
  }

  void _checkIfWon(List<String> guessedLetters) {
    var letters = curGuessWord.value.split('');
    var won = true;
    letters.forEach((letter) {
      if (!guessedLetters.contains(letter)) {
        won = false;
        return;
      }
    });
    if (won) {
      curGameState.value = GameState.succeeded;
    }
  }

  void updateHangingBodyParts() {
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
