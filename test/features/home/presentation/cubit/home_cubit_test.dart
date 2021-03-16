import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohrwurm/features/home/presentation/cubit/home_cubit.dart';

main() {
  HomeCubit homeCubit;

  setUp(() {
    homeCubit = HomeCubit();
  });

  group('setPage', () {
    // ToDo: Change to HomeDiscover when ready
    test('Initial state should be [HomeSongs]', () {
      // assert
      expect(homeCubit.state, HomeSongs());
    });

    blocTest(
      'should emit the [HomeDiscover] state if supplied index is 0',
      build: () => homeCubit,
      act: (cubit) => cubit.setPage(0),
      expect: () => [HomeDiscover()],
    );

    blocTest(
      'should emit the [HomeSearch] state if supplied index is 1',
      build: () => homeCubit,
      act: (cubit) => cubit.setPage(1),
      expect: () => [HomeSearch()],
    );

    // to pass this test the state first needs to be changed to a different one (HomeDiscover) than the initial one (HomeSongs)
    blocTest(
      'should emit the [HomeSongs] state if supplied index is 2',
      build: () => homeCubit,
      act: (cubit) {
        cubit.setPage(0);
        cubit.setPage(2);
      },
      expect: () => [HomeDiscover(), HomeSongs()],
    );
  });
}
