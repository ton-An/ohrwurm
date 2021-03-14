import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';

abstract class Failure extends Equatable {
  final String message;
  final List properties;

  Failure(this.message, [this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [message, properties];
}

class UnidentifiableFailure extends Failure {
  UnidentifiableFailure(String message) : super(message);
}

class DatabaseFailure extends Failure {
  DatabaseFailure(String message) : super(message);
}

class NotInDatabaseFailure extends Failure {
  NotInDatabaseFailure(String message) : super(message);
}

class ArtistAlreadyExistsFailure extends Failure {
  final Artist artist;
  ArtistAlreadyExistsFailure({@required String message, @required this.artist})
      : super(message);
}
