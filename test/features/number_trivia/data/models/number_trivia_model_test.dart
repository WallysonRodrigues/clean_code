import 'dart:convert';

import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(
    text: 'Test Text',
    number: 1,
  );

  test(
    'shold be a number NumberTrivia entity',
    () async {
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson test', () {
    test(
      'Should return a valid model when the JSON number is a integer',
      () {
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'Should return a valid model when the JSON number is regarded as a double',
      () {
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));

        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test(
      'Should return a JSON map containgthe proper data',
      () {
        final result = tNumberTriviaModel.toJson();

        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };

        expect(result, expectedMap);
      },
    );
  });
}
