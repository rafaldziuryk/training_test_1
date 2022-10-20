import 'package:flutter_test/flutter_test.dart';
import 'package:training_test_1/features/number_trivia/data/models/number_trivia_model.dart';

void main() {
  test('parse wity fulfilled dictionary', () {
    final map = {
      "text": "TEST1",
      "number": 1,
    };
    final result = NumberTriviaModel.fromJson(map);
    expect(result.text, "TEST1");
    expect(result.number, 1);
    expect(result, isA<NumberTriviaModel>());
  });

  test('parse wity empty dictionary', () {
    final map = <String, dynamic>{};
    final result = NumberTriviaModel.fromJson(map);
    expect(result.text, "");
    expect(result.number, 0);
    expect(result, isA<NumberTriviaModel>());
  });

  test('parse wity empty dictionary', () {
    final map = {
      "text": "TEST1",
      "number": "chleb",
    };
    final result = NumberTriviaModel.fromJson(map);
    expect(result.text, "TEST1");
    expect(result.number, 0);
    expect(result, isA<NumberTriviaModel>());
  });
}
