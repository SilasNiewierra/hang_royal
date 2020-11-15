import 'dart:math';

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

  // String getWordFromApi() {
  //   // call api to get a word from a special category
  //   // api.get(category)
  // }
}
