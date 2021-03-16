import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/features/song/domain/usecases/scan_directory_for_songs.dart';

class MockDirectory extends Mock implements Directory {}

main() {
  ScanDirectoryForSongs scanDirectoryForSongs;
  MockDirectory mockDirectory;

  setUp(() {
    mockDirectory = MockDirectory();
    scanDirectoryForSongs = ScanDirectoryForSongs();
  });

  setUp(() {
    when(mockDirectory.list())
        .thenAnswer((realInvocation) => Stream.value(File('')));
  });
  test('should call list on directory', () async {
    // arrange

    // act
    await scanDirectoryForSongs(Params(directory: mockDirectory));

    // assert
    verify(mockDirectory.list(recursive: true));
  });

  test('should call listen on the direcory stream', () async {
    // arrange

    // act
    await scanDirectoryForSongs(Params(directory: mockDirectory));

    // assert
    verify(mockDirectory.list().listen(any));
  });
}
