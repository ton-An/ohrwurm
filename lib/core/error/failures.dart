import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final List properties;

  Failure(this.message, [this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [message, properties];
}

class DatabaseFaiure extends Failure {
  DatabaseFaiure(String message) : super(message);
}

class NotInDatabaseFailure extends Failure {
  NotInDatabaseFailure(String message) : super(message);
}
