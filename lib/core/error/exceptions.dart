import 'dart:io';

class OhrwurmDatabaseException implements Exception {
  final String message;
  OhrwurmDatabaseException([this.message]);
}

class NotInDatabaseException implements Exception {
  final String message;
  NotInDatabaseException([this.message]);
}

class FileDoesNotExistException implements Exception {
  final String message;
  FileDoesNotExistException([this.message]);
}

class NoResultsException implements Exception {
  final String message;
  NoResultsException([this.message]);
}

class NoMoreResultsException implements Exception {
  final String message;
  NoMoreResultsException([this.message]);
}

class OhrwurmFileSystemException implements Exception {
  final String message;
  final String path;

  OhrwurmFileSystemException(this.message, this.path);
}

class UnidentifiableException implements Exception {
  final String message;
  UnidentifiableException([this.message]);
}
