import 'package:bloc_test/bloc_test.dart';
import 'package:clean_arch/core/error/failure.dart';
import 'package:clean_arch/core/usecases/usecase.dart';
import 'package:clean_arch/core/util/input_converter.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter,
])
void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    expect(bloc.state, const TypeMatcher<Empty>());
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(
      text: 'test trivia',
      number: 1,
    );

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(
        const Right(tNumberParsed),
      );
    }

    void setUpmockGetConcreteNumberTriviaRight() {
      when(mockGetConcreteNumberTrivia(any)).thenAnswer(
        (_) async => const Right(tNumberTrivia),
      );
    }

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      setUp: () {
        setUpMockInputConverterSuccess();
        setUpmockGetConcreteNumberTriviaRight();
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      verify: (bloc) => verify(mockInputConverter.stringToUnsignedInteger(tNumberString)),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit Error when input is invalid',
      setUp: () => when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure())),
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [Error(message: INVALID_INPUT_FAILURE_MESSAGE)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from the concrete use case',
      setUp: () {
        setUpMockInputConverterSuccess();
        setUpmockGetConcreteNumberTriviaRight();
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      verify: (bloc) => verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed))),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        setUpMockInputConverterSuccess();
        setUpmockGetConcreteNumberTriviaRight();
      },
      build: () => bloc,
      act: (NumberTriviaBloc bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => bloc,
      act: (NumberTriviaBloc bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => bloc,
      act: (NumberTriviaBloc bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(
      text: 'test trivia',
      number: 1,
    );

    void setUpmockGetRandomNumberTriviaRight() {
      when(mockGetRandomNumberTrivia(any)).thenAnswer(
        (_) async => const Right(tNumberTrivia),
      );
    }

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from the random use case',
      setUp: () => setUpmockGetRandomNumberTriviaRight(),
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      verify: (bloc) => verify(mockGetRandomNumberTrivia(NoParams())),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () => setUpmockGetRandomNumberTriviaRight(),
      build: () => bloc,
      act: (NumberTriviaBloc bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      setUp: () => when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure())),
      build: () => bloc,
      act: (NumberTriviaBloc bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      setUp: () => when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure())),
      build: () => bloc,
      act: (NumberTriviaBloc bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
