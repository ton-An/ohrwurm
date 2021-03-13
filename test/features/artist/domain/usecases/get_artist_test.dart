import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/features/artist/domain/repositories/artist_repository.dart';
import 'package:ohrwurm/features/artist/domain/usecases/get_artist.dart';

import '../../../../fixtures/artist_fixtures.dart';

class MockArtistRepository extends Mock implements ArtistRepository {}

main() {
  GetArtist getArtist;
  MockArtistRepository mockArtistRepository;

  setUp(() {
    mockArtistRepository = MockArtistRepository();
    getArtist = GetArtist(artistRepository: mockArtistRepository);
  });

  test('should get an [Artist] from the [ArtistRepository]', () async {
    // arrange
    when(mockArtistRepository.getArtist(any))
        .thenAnswer((realInvocation) => Future.value(Right(tArtist)));

    // act
    final result = await getArtist(Params(artistId: tArtistId));

    // assert
    expect(result, Right(tArtist));
    verify(mockArtistRepository.getArtist(tArtistId));
    verifyNoMoreInteractions(mockArtistRepository);
  });
}
