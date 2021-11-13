import 'dart:convert';

import 'package:clean_arch/core/error/exception.dart';
import 'package:clean_arch/features/number_trivia/data/datasources/number_trivia_remote_data_source_impl.dart';
import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

import 'number_trivia_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(mockClient);
  });

  void setUpMockHttpClientSucess200() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('Page not found', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test('should preform a GET request on a URL with number being the endpoint and with application/json header', () {
      setUpMockHttpClientSucess200();

      dataSource.getConcreteNumberTrivia(tNumber);

      verify(mockClient.get(Uri.parse('http://numbersapi.com/$tNumber'), headers: {'Content-Type': 'application/json'}));
    });

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        setUpMockHttpClientSucess200();

        final result = await dataSource.getConcreteNumberTrivia(tNumber);

        expect(result, tNumberTriviaModel);
      },
    );

    test('should throw a ServerException when the reponse code is 404 or other', () async {
      setUpMockHttpClientFailure404();

      expect(() => dataSource.getConcreteNumberTrivia(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test('should preform a GET request on a URL with number being the endpoint and with application/json header', () {
      setUpMockHttpClientSucess200();

      dataSource.getRandomNumberTrivia();

      verify(mockClient.get(Uri.parse('http://numbersapi.com/random'), headers: {'Content-Type': 'application/json'}));
    });

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        setUpMockHttpClientSucess200();

        final result = await dataSource.getRandomNumberTrivia();

        expect(result, tNumberTriviaModel);
      },
    );

    test('should throw a ServerException when the reponse code is 404 or other', () async {
      setUpMockHttpClientFailure404();

      expect(() => dataSource.getRandomNumberTrivia(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
