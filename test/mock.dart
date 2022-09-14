import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_test_1/core/network/network_info.dart';
import 'package:training_test_1/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:training_test_1/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:training_test_1/features/number_trivia/data/models/number_trivia_model.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {
  void mockNumberTriviaModelValue({required NumberTriviaModel numberTriviaModel}) {
    when(() => getString(any())).thenReturn(jsonEncode(numberTriviaModel.toJson()));
  }

  void mockNumberTriviaModelError({required Object error}) {
    when(() => getString(any())).thenThrow(error);
  }
}

class MockNumberTriviaRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {
  void mockGetConcreteNumberTriviaValue({required NumberTriviaModel numberTriviaModel}) {
    when(() => getConcreteNumberTrivia(any())).thenAnswer((invocation) async => numberTriviaModel);
  }

  void mockGetConcreteNumberTriviaError({required Object error}) {
    when(() => getConcreteNumberTrivia(any())).thenThrow(error);
  }
}

class MockNumberTriviaLocalDataSource extends Mock implements NumberTriviaLocalDataSource {
  void mockLastNumberValue({required NumberTriviaModel numberTriviaModel}) {
    when(() => getLastNumberTrivia()).thenAnswer((invocation) async => numberTriviaModel);
  }

  void mockLastNumberError({required Object error}) {
    when(() => getLastNumberTrivia()).thenThrow(error);
  }

  void mockCacheNumberTriviaSuccess() {
    when(() => cacheNumberTrivia(any())).thenAnswer((_) async {});
    ;
  }

  void mockCacheNumberTriviaFailure({required Object error}) {
    when(() => cacheNumberTrivia(any())).thenThrow(error);
  }
}

class MockNetworkInfo extends Mock implements NetworkInfo {
  void mockIsConnected({required bool isConnectedFlag}) {
    when(() => isConnected).thenAnswer((invocation) async => isConnectedFlag);
  }
}

NumberTriviaModel mockNumberTriviaModel({String? text, int? number}) {
  return NumberTriviaModel(text: text ?? 'TEST1', number: number ?? 0);
}

Object mockError({Object? error}) {
  return error ?? Exception();
}

class NumberTriviaModelStub extends Fake implements NumberTriviaModel {}
