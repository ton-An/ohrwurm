class OhrwurmDatabaseException implements Exception {
  /// A message describing the database error
  String message;
  OhrwurmDatabaseException([this.message]);
}

class NotInDatabaseException implements Exception {
  /// A message describing the database error
  String message;
  NotInDatabaseException([this.message]);
}
