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
  final String artistId;
  ArtistAlreadyExistsFailure(
      {@required String message, @required this.artistId})
      : super(message);
}

class SongAlreadyExistsFailure extends Failure {
  final String songId;
  SongAlreadyExistsFailure({@required String message, @required this.songId})
      : super(message);
}

class FileDoesNotExistFailure extends Failure {
  FileDoesNotExistFailure(String message) : super(message);
}

class NoMoreResultsFailure extends Failure {
  NoMoreResultsFailure(String message) : super(message);
}

class NoResultsFailure extends Failure {
  NoResultsFailure(String message) : super(message);
}
