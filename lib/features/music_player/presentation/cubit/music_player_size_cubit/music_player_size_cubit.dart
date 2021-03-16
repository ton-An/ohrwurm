import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'music_player_size_state.dart';

class MusicPlayerSizeCubit extends Cubit<MusicPlayerSizeState> {
  MusicPlayerSizeCubit() : super(MusicPlayerSizeHidden());
  void toggleMusicPlayerSize() {
    if (super.state is MusicPlayerSizeHidden) {
      emit(MusicPlayerSizeSmall());
    } else if (super.state is MusicPlayerSizeSmall) {
      emit(MusicPlayerSizeLarge());
    } else if (super.state is MusicPlayerSizeLarge) {
      emit(MusicPlayerSizeSmall());
    }
  }
}
