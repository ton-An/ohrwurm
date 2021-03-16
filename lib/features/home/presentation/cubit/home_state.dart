part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeSongs extends HomeState {}

class HomeDiscover extends HomeState {}

class HomeSearch extends HomeState {}
