import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/features/artist/data/datasources/artist_local_data_source.dart';
import 'package:ohrwurm/features/artist/data/repositories_impl/artist_repository_impl.dart';
import 'package:ohrwurm/features/artist/domain/repositories/artist_repository.dart';

import '../../../../fixtures/artist_fixtures.dart';

class MockArtistLocalDataSource extends Mock implements ArtistLocalDataSource {}

main() {
  ArtistRepositoryImpl artistRepositoryImpl;
  MockArtistLocalDataSource mockArtistLocalDataSource;

  setUp(() {
    mockArtistLocalDataSource = MockArtistLocalDataSource();
    artistRepositoryImpl =
        ArtistRepositoryImpl(artistLocalDataSource: mockArtistLocalDataSource);
  });

  group('getArtist()', () {
    test(
        'should get an [ArtistModel] from the [ArtistLocalDataSource] and return it',
        () async {
      // arrange
      when(mockArtistLocalDataSource.getArtist(tArtistId))
          .thenAnswer((realInvocation) => Future.value(tArtistModel));

      // act
      final result = await artistRepositoryImpl.getArtist(tArtistId);

      // assert
      expect(result, Right(tArtist));
    });

    test('should return a [DatabaseFailure] on [DatabaseException]', () async {
      // arrange
      when(mockArtistLocalDataSource.getArtist(any))
          .thenThrow(OhrwurmDatabaseException('Failure'));

      // act
      final result = await artistRepositoryImpl.getArtist('1234');

      // assert
      expect(result, Left(DatabaseFaiure('Failure')));
    });

    test('should return a [NotInDatabaseFailure] on [NotInDatabaseException]',
        () async {
      // arrange
      when(mockArtistLocalDataSource.getArtist(any))
          .thenThrow(NotInDatabaseException('Failure'));

      // act
      final result = await artistRepositoryImpl.getArtist('1234');

      // assert
      expect(result, Left(NotInDatabaseFailure('Failure')));
    });
  });

  group('addArtist()', () {
    test(
        'should add an [Artist] using the [ArtistLocalDataSource] and return it\'s id',
        () async {
      // arrange
      when(mockArtistLocalDataSource.addArtist(any))
          .thenAnswer((realInvocation) => Future.value(tArtistId));

      // act
      final result = await artistRepositoryImpl.addArtist(tArtist);

      // assert
      expect(result, Right(tArtistId));
    });

    test('should return a [DatabaseFailure] on [DatabaseException]', () async {
      // arrange
      when(mockArtistLocalDataSource.addArtist(any))
          .thenThrow(OhrwurmDatabaseException('Failure'));

      // act
      final result = await artistRepositoryImpl.addArtist(tArtist);

      // assert
      expect(result, Left(DatabaseFaiure('Failure')));
    });
  });
}
