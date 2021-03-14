import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/domain/repositories/artist_repository.dart';
import 'package:ohrwurm/features/artist/domain/usecases/add_artist.dart';
import 'package:ohrwurm/features/artist/domain/usecases/get_artist.dart';

import '../../../../fixtures/artist_fixtures.dart';

class MockArtistRepository extends Mock implements ArtistRepository {}

class MockIdGenerator extends Mock implements IdGenerator {}

class MockGetArtist extends Mock implements GetArtist {}

main() {
  AddArtist addArtist;
  MockArtistRepository mockArtistRepository;
  MockIdGenerator mockIdGenerator;
  MockGetArtist mockGetArtist;

  setUp(() {
    mockArtistRepository = MockArtistRepository();
    mockIdGenerator = MockIdGenerator();
    mockGetArtist = MockGetArtist();
    addArtist = AddArtist(
        artistRepository: mockArtistRepository,
        idGenerator: mockIdGenerator,
        getArtist: mockGetArtist);
  });

  // should get artist from name
  // should generate id
  // should check if id already exists by calling GetArtist
  // should call addArtist on repository

  test(
      'should check if artist already exists by getting an [Artist] for the artistName from the [ArtistRepository]',
      () async {
    // arrange
    when(mockArtistRepository.getArtistFromName(any))
        .thenAnswer((realInvocation) => Future.value(Right(tArtist)));

    // act
    await addArtist(AddArtistParams(artistName: tArtistName));

    // assert
    verify(mockArtistRepository.getArtistFromName(tArtistName));
    verifyNoMoreInteractions(mockArtistRepository);
  });

  test(
      'should return a [Failure] if getArtistFromName call returns a Failure other than [NotInDatabaseFailure]',
      () async {
    // arrange
    when(mockArtistRepository.getArtistFromName(any)).thenAnswer(
        (realInvocation) => Future.value(Left(DatabaseFailure(''))));

    // act
    final result = await addArtist(AddArtistParams(artistName: tArtistName));

    // assert
    expect(result, Left((DatabaseFailure(''))));
  });

  group('if artist already exists', () {
    test('should return an [ArtistAlreadyExistsFailure]', () async {
      // arrange
      when(mockArtistRepository.getArtistFromName(any))
          .thenAnswer((realInvocation) => Future.value(Right(tArtist)));

      // act
      final result = await addArtist(AddArtistParams(artistName: tArtistName));

      // assert
      expect(result, Left(tArtistAlreadyExistsFailure));
    });
  });

  group('if artist doesn\'t exist', () {
    setUp(() {
      when(mockArtistRepository.getArtistFromName(any)).thenAnswer(
          (realInvocation) => Future.value(Left(tNotInDatabaseFailure)));
      when(mockIdGenerator()).thenReturn(tArtistId);
      when(mockGetArtist(any)).thenAnswer(
          (realInvocation) => Future.value(Left(tNotInDatabaseFailure)));
    });

    test('should generate an id for the new artist', () async {
      // act
      await addArtist(AddArtistParams(artistName: tArtistName));

      // assert
      verify(mockIdGenerator());
      verifyNoMoreInteractions(mockIdGenerator);
    });

    test('should check if id already exists by calling [GetArtist]', () async {
      // act
      await addArtist(AddArtistParams(artistName: tArtistName));

      // assert
      verify(mockGetArtist(GetArtistParams(artistId: tArtistId)));
      verifyNoMoreInteractions(mockGetArtist);
    });

    test(
        'should return a [Failure] if [GetAritst] call returns a Failure other than [NotInDatabaseFailure]',
        () async {
      // arrange
      when(mockGetArtist(any)).thenAnswer(
          (realInvocation) => Future.value(Left(DatabaseFailure(''))));

      // act
      final result = await addArtist(AddArtistParams(artistName: tArtistName));

      // assert
      expect(result, Left((DatabaseFailure(''))));
    });

    group('if artist doesn\'t exist', () {
      test(
          'should call addArtist on [ArtistRepository] and return the artists id',
          () async {
        // arrange
        when(mockGetArtist(any)).thenAnswer(
            (realInvocation) => Future.value(Left(tNotInDatabaseFailure)));
        when(mockArtistRepository.addArtist(any))
            .thenAnswer((realInvocation) => Future.value(Right(tArtistId)));

        // act
        final result =
            await addArtist(AddArtistParams(artistName: tArtistName));

        // assert
        expect(result, Right(tArtistId));
        verify(mockArtistRepository.addArtist(tArtist));
      });
    });
  });

  // test('should add an [Artist] using the [ArtistRepository]', () async {
  //   // act
  //   await addArtist(Params(artistName: tArtistName));

  //   // assert
  //   verify(mockArtistRepository.addArtist(tArtist));
  //   verifyNoMoreInteractions(mockArtistRepository);
  // });
}
