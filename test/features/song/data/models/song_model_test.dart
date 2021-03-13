import 'package:flutter_test/flutter_test.dart';
import 'package:ohrwurm/features/artist/data/models/artist_model.dart';
import 'package:ohrwurm/features/song/data/models/song_model.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';

import '../../../../fixtures/song_fixtures.dart';

main() {
  test('should be descendant of [Song]', () {
    // assert
    expect(tSongModel, isA<Song>());
  });

  group('fromMap()', () {
    test('should convert a song map to [SongModel] object', () {
      // act
      final result = SongModel.fromMap(tSongModelMap);
      print(result);
      // assert
      expect(result, tSongModel);
    });
  });

  group('toMap()', () {
    test('should convert a [Song] object to a song map', () {
      // act
      final result = tSongModel.toMap();

      // assert
      expect(result, tSongModelMap);
    });
  });
}
