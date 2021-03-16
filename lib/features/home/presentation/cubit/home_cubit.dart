import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeSongs());

  void setPage(int index) {
    if (index == 0 && !(super.state is HomeDiscover)) {
      emit(HomeDiscover());
    } else if (index == 1 && !(super.state is HomeSearch)) {
      emit(HomeSearch());
    } else if (index == 2 && !(super.state is HomeSongs)) {
      emit(HomeSongs());
    }
  }
}
