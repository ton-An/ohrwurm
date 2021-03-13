import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/features/artist/domain/repositories/artist_repository.dart';
import 'package:ohrwurm/features/artist/domain/usecases/add_artist.dart';

import '../../../../fixtures/artist_fixtures.dart';

class MockArtistRepository extends Mock implements ArtistRepository {}

main() {
  AddArtist addArtist;
  MockArtistRepository mockArtistRepository;

  setUp(() {
    mockArtistRepository = MockArtistRepository();
    addArtist = AddArtist(artistRepository: mockArtistRepository);
  });

  test(
      'should add an [Artist] using the [ArtistRepository] and return it\'s id',
      () async {
    when(mockArtistRepository.addArtist(any))
        .thenAnswer((realInvocation) => Future.value(Right(tArtistId)));
    // act
    final result = await addArtist(Params(artist: tArtist));

    // assert
    expect(result, Right(tArtistId));
    verify(mockArtistRepository.addArtist(tArtist));
    verifyNoMoreInteractions(mockArtistRepository);
  });
}
