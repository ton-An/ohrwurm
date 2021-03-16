import 'package:flutter_test/flutter_test.dart';
import 'package:ohrwurm/features/song/data/models/song_meta_data_model.dart';

import '../../../../fixtures/song_fixtures.dart';

main() {
  test('should convert the meta data and cover art to a [SongMetaDataModel]',
      () {
    // act
    final result = SongMetaDataModel.fromMetaData(tMetadata, tCoverArt);

    // assert
    expect(result, tSongMetaDataModel);
  });
}
