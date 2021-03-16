import 'package:path_provider/path_provider.dart';

class AppPaths {
  /// Gets the App's Documents Directory
  Future<String> getAppDocumentsDirectoryPath() async =>
      (await getApplicationDocumentsDirectory()).path;
}
