import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_test_1/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:training_test_1/features/number_trivia/data/models/number_trivia_model.dart';

import 'mock.dart';

void main() {
  late final MockSharedPreferences mockSharedPreferences;
  late final NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;

  setUpAll(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  test('get trivia number from cache - data', () async {
    mockSharedPreferences.mockNumberTriviaModelValue(numberTriviaModel: mockNumberTriviaModel());
    final result = await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();
    expect(result.text, "TEST1");
    expect(result.number, 0);
    expect(result, isA<NumberTriviaModel>());
    verify(() => mockSharedPreferences.getString(any())).called(1);
  });

  test('get trivia number from cache - error', () async {
    mockSharedPreferences.mockNumberTriviaModelError(error: Exception());
    expect(
      () async => await numberTriviaLocalDataSourceImpl.getLastNumberTrivia(),
      throwsA(const TypeMatcher<Exception>()),
    );
    verify(() => mockSharedPreferences.getString(any())).called(1);
  });
}
