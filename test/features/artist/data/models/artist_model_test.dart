import 'package:flutter_test/flutter_test.dart';
import 'package:ohrwurm/features/artist/data/models/artist_model.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';

import '../../../../fixtures/artist_fixtures.dart';

main() {
  test('should be descendant of [Artist]', () {
    // assert
    expect(tArtistModel, isA<Artist>());
  });

  group('fromMap()', () {
    test('should convert an artist map to an [ArtistModel] object', () {
      // act
      final result = ArtistModel.fromMap(tArtistModelMap);

      // assert
      expect(result, tArtistModel);
    });
  });

  group('toMap()', () {
    test('should convert an [ArtistModel] to an artist map', () async {
      // act
      final result = tArtistModel.toMap();

      // assert
      expect(result, tArtistModelMap);
    });
  });
}
