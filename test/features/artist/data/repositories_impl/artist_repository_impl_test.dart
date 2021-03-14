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

  group('getArtistFromId()', () {
    test(
        'should get an [ArtistModel] from the [ArtistLocalDataSource] for an ID and return it',
        () async {
      // arrange
      when(mockArtistLocalDataSource.getArtistFromId(tArtistId))
          .thenAnswer((realInvocation) => Future.value(tArtistModel));

      // act
      final result = await artistRepositoryImpl.getArtistFromId(tArtistId);

      // assert
      expect(result, Right(tArtist));
      verify(mockArtistLocalDataSource.getArtistFromId(tArtistId));
      verifyNoMoreInteractions(mockArtistLocalDataSource);
    });

    test('should return a [DatabaseFailure] on [DatabaseException]', () async {
      // arrange
      when(mockArtistLocalDataSource.getArtistFromId(any))
          .thenThrow(OhrwurmDatabaseException('Failure'));

      // act
      final result = await artistRepositoryImpl.getArtistFromId('1234');

      // assert
      expect(result, Left(DatabaseFailure('Failure')));
    });

    test('should return a [NotInDatabaseFailure] on [NotInDatabaseException]',
        () async {
      // arrange
      when(mockArtistLocalDataSource.getArtistFromId(any))
          .thenThrow(NotInDatabaseException('Failure'));

      // act
      final result = await artistRepositoryImpl.getArtistFromId('1234');

      // assert
      expect(result, Left(NotInDatabaseFailure('Failure')));
    });
  });

  group('getArtistFromName()', () {
    test(
        'should get an [ArtistModel] from the [ArtistLocalDataSource] for a name and return it',
        () async {
      // arrange
      when(mockArtistLocalDataSource.getArtistFromName(tArtistName))
          .thenAnswer((realInvocation) => Future.value(tArtistModel));

      // act
      final result = await artistRepositoryImpl.getArtistFromName(tArtistName);

      // assert
      expect(result, Right(tArtist));
      verify(mockArtistLocalDataSource.getArtistFromName(tArtistName));
      verifyNoMoreInteractions(mockArtistLocalDataSource);
    });

    test('should return a [DatabaseFailure] on [DatabaseException]', () async {
      // arrange
      when(mockArtistLocalDataSource.getArtistFromName(any))
          .thenThrow(OhrwurmDatabaseException('Failure'));

      // act
      final result = await artistRepositoryImpl.getArtistFromName(tArtistName);

      // assert
      expect(result, Left(DatabaseFailure('Failure')));
    });

    test('should return a [NotInDatabaseFailure] on [NotInDatabaseException]',
        () async {
      // arrange
      when(mockArtistLocalDataSource.getArtistFromName(any))
          .thenThrow(NotInDatabaseException('Failure'));

      // act
      final result = await artistRepositoryImpl.getArtistFromName(tArtistName);

      // assert
      expect(result, Left(NotInDatabaseFailure('Failure')));
    });
  });

  group('addArtist()', () {
    test('should add an [Artist] using the [ArtistLocalDataSource]', () async {
      // arrange
      when(mockArtistLocalDataSource.addArtist(any))
          .thenAnswer((realInvocation) => Future.value(tArtistId));

      // act
      await artistRepositoryImpl.addArtist(tArtist);

      // assert
      verify(mockArtistLocalDataSource.addArtist(tArtist));
      verifyNoMoreInteractions(mockArtistLocalDataSource);
    });

    test('should return a [DatabaseFailure] on [DatabaseException]', () async {
      // arrange
      when(mockArtistLocalDataSource.addArtist(any))
          .thenThrow(OhrwurmDatabaseException('Failure'));

      // act
      final result = await artistRepositoryImpl.addArtist(tArtist);

      // assert
      expect(result, Left(DatabaseFailure('Failure')));
    });
  });
}
