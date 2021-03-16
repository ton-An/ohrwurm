import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/features/song/domain/usecases/get_song_list.dart';
import 'package:ohrwurm/features/song/presentation/cubit/songs_cubit.dart';

import '../../../../fixtures/artist_fixtures.dart';
import '../../../../fixtures/song_fixtures.dart';

// class MockSongsCubit extends MockBloc<int> implements SongsCubit {}

class MockGetSongList extends Mock implements GetSongList {}

main() {
  SongsCubit songsCubit;
  MockGetSongList mockGetSongList;

  setUp(() {
    mockGetSongList = MockGetSongList();
    songsCubit = SongsCubit(getSongListUseCase: mockGetSongList);
  });
  group('getSongList()', () {
    setUp(() {
      when(mockGetSongList(any))
          .thenAnswer((realInvocation) => Future.value(Right(tSongModelList)));
    });
    test('should get a List of [Song]s from the [GetSongList] UseCase',
        () async {
      // act
      await songsCubit.getSongList(tSongPage);

      // assert
      verify(mockGetSongList(GetSongListParams(page: tSongPage)));
      verifyNoMoreInteractions(mockGetSongList);
    });
    blocTest(
      'should emit [SongsLoading, SongsLoaded] states if call to UseCase was successful',
      build: () => songsCubit,
      act: (cubit) => cubit.getSongList(tSongPage),
      expect: () => [SongsLoading(), SongsLoaded(songs: tSongModelList)],
    );

    group('if call to GetSongList was unsuccessful', () {
      setUp(() {
        when(mockGetSongList(any)).thenAnswer((realInvocation) =>
            Future.value(Left(NoResultsFailure('failure'))));
      });
      blocTest(
        'should emit [SongsLoading, SongsError] states if call to UseCase was unsuccessful',
        build: () => songsCubit,
        act: (cubit) => cubit.getSongList(tSongPage),
        expect: () => [SongsLoading(), SongsError(message: 'failure')],
      );
    });
  });
}

//  group('GetTriviaForRandomNumber', () {
//     final tNumberTrivia = NumberTrivia(1, 'test');

//     test('should get [NumberTrivia] from [GetRandomNumberTrivia] usecase',
//         () async {
//       // arrange
//       when(mockGetRandomNumberTrivia(any))
//           .thenAnswer((_) => Future.value(Right(tNumberTrivia)));

//       // act
//       bloc.add(GetRandomNumberTriviaEvent());
//       await untilCalled(mockGetRandomNumberTrivia(any));

//       // assert
//       verify(mockGetRandomNumberTrivia(NoParams()));
//     });

//     test(
//         'should dispatch [Loading, Loaded] state if call to usecase was successful',
//         () {
//       // arrange
//       when(mockGetRandomNumberTrivia(any))
//           .thenAnswer((_) => Future.value(Right(tNumberTrivia)));

//       // assert later
//       expectLater(bloc, emitsInOrder([Loading(), Loaded(tNumberTrivia)]));

//       // act
//       bloc.add(GetRandomNumberTriviaEvent());
//     });

//     test(
//         'should dispatch [Loading, Error] if call to usecase was unsuccessful (returns a Failure)',
//         () {
//       // arrange
//       when(mockGetRandomNumberTrivia(any))
//           .thenAnswer((_) async => Left(ServerFailure()));

//       // assert later
//       expectLater(bloc, emitsInOrder([Loading(), Error('Failure')]));

//       // act
//       bloc.add(GetRandomNumberTriviaEvent());
//     });
//   });
// }
