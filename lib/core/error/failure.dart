import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  late List properties;

  Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [properties];
}

//General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
