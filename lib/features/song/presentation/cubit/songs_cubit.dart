import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/features/song/domain/usecases/get_song_list.dart';

part 'songs_state.dart';

class SongsCubit extends Cubit<SongsState> {
  final GetSongList getSongListUseCase;
  SongsCubit({@required this.getSongListUseCase}) : super(SongsInitial());

  Future<void> getSongList(int page) async {
    emit(SongsLoading());
    final songListEither =
        await getSongListUseCase(GetSongListParams(page: page));
    songListEither.fold((l) {
      if (l is NoMoreResultsFailure) {
        emit(SongsLoaded(songs: []));
      } else {
        emit(SongsError(message: '${l.message} - $l'));
      }
    }, (r) {
      for (Song song in r) print(song);

      emit(SongsLoaded(songs: r));
    });
  }
}
