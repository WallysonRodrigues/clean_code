import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';
import '../models/number_trivia_model.dart';
import 'number_trivia_remote_data_source.dart';

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl(this.client);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async => _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async => _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
