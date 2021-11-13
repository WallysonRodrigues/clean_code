import 'dart:convert';

import 'package:clean_arch/core/error/exception.dart';
import 'package:clean_arch/features/number_trivia/data/datasources/number_trivia_local_data_source_impl.dart';
import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));

    test('should return NumberTrivia from SharedPreferences when there is one in the cache', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, tNumberTriviaModel);
    });

    test('should throw a CachException when there is not a cached value', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      expect(() => dataSource.getLastNumberTrivia(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');

    test('should call SharedPreferences to cache the data', () async {
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      final jsonString = jsonEncode(tNumberTriviaModel.toJson());

      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString));
    });
  });
}
