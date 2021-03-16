class OhrwurmDatabaseException implements Exception {
  String message;
  OhrwurmDatabaseException([this.message]);
}

class NotInDatabaseException implements Exception {
  String message;
  NotInDatabaseException([this.message]);
}

class FileDoesNotExistException implements Exception {
  String message;
  FileDoesNotExistException([this.message]);
}

class NoResultsException implements Exception {
  String message;
  NoResultsException([this.message]);
}

class NoMoreResultsException implements Exception {
  String message;
  NoMoreResultsException([this.message]);
}

class UnidentifiableException implements Exception {
  String message;
  UnidentifiableException([this.message]);
}
