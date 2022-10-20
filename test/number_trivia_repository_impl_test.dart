import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_test_1/core/error/exceptions.dart';
import 'package:training_test_1/core/error/failures.dart';
import 'package:training_test_1/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

import 'mock.dart';

void main() {
  late final MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSourced;
  late final MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late final MockNetworkInfo mockNetworkInfo;
  late final NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;

  setUpAll(() {
    mockNumberTriviaRemoteDataSourced = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      localDataSource: mockNumberTriviaLocalDataSource,
      remoteDataSource: mockNumberTriviaRemoteDataSourced,
      networkInfo: mockNetworkInfo,
    );

    registerFallbackValue(NumberTriviaModelStub());
  });

  setUp(() {
    reset(mockNumberTriviaRemoteDataSourced);
    reset(mockNumberTriviaLocalDataSource);
    reset(mockNetworkInfo);
  });

  test('get concrete trivia number from cache - data', () async {
    mockNetworkInfo.mockIsConnected(isConnectedFlag: false);
    mockNumberTriviaLocalDataSource.mockLastNumberValue(
        numberTriviaModel: mockNumberTriviaModel(text: "TEST1", number: 1));
    final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(0);
    expect(result, isA<Right>());
    result.fold((l) => null, (data) {
      expect(data.text, "TEST1");
      expect(data.number, 1);
    });
    verify(() => mockNumberTriviaLocalDataSource.getLastNumberTrivia()).called(1);
    verifyZeroInteractions(mockNumberTriviaRemoteDataSourced);
  });

  test('get concrete trivia number from cache - error', () async {
    mockNetworkInfo.mockIsConnected(isConnectedFlag: false);
    mockNumberTriviaLocalDataSource.mockLastNumberError(error: CacheException());
    final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(0);
    expect(result, isA<Left>());
    result.fold((error) {
      expect(error, isA<CacheFailure>());
    }, (data) => null);
    verify(() => mockNumberTriviaLocalDataSource.getLastNumberTrivia()).called(1);
    verifyZeroInteractions(mockNumberTriviaRemoteDataSourced);
  });

  test('get concrete trivia number from remote - data', () async {
    mockNetworkInfo.mockIsConnected(isConnectedFlag: true);
    mockNumberTriviaLocalDataSource.mockCacheNumberTriviaSuccess();
    mockNumberTriviaRemoteDataSourced.mockGetConcreteNumberTriviaValue(
        numberTriviaModel: mockNumberTriviaModel(text: "TEST1", number: 1));
    final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(0);
    expect(result, isA<Right>());
    result.fold((l) => null, (data) {
      expect(data.text, "TEST1");
      expect(data.number, 1);
    });
    verify(() => mockNumberTriviaRemoteDataSourced.getConcreteNumberTrivia(0)).called(1);
    verify(() => mockNumberTriviaLocalDataSource.cacheNumberTrivia(any())).called(1);
    verifyNever(
      () => mockNumberTriviaLocalDataSource.getLastNumberTrivia(),
    );
  });
}
