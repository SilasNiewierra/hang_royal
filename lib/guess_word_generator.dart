import 'dart:math';

class GuessWordGenerator {
  var _possibleWords = [
    'seal',
    'chick',
    'grasshoper',
    'dog',
    'narwhale',
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
