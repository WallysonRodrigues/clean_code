import 'package:clean_arch/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import 'get_random_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get random trivia from the repositoty', () async {
    //binding the return of the mocked repository
    when(mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer((_) async => const Right(tNumberTrivia));

    // executing the method from the use case to get a NumberTrivia entity on right size of either
    final result = await usecase(NoParams());

    // comparing if the result is the same that NumberTrivia mocked
    expect(result, const Right(tNumberTrivia));

    // verifying if method was executed with correct args
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());

    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
