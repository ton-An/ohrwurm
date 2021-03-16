import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ohrwurm/features/home/presentation/cubit/home_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_cubit/music_player_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_size_cubit/music_player_size_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_animated_positioned.dart';
import 'package:ohrwurm/features/song/presentation/cubit/songs_cubit.dart';
import 'package:ohrwurm/features/song/presentation/pages/songs_page.dart';
import 'package:ohrwurm/injection_container.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: BlocProvider(
            create: (context) => sl<SongsCubit>(),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeDiscover) {
                  return DiscoverPage();
                } else if (state is HomeSearch) {
                  return SearchPage();
                } else if (state is HomeSongs) {
                  return SongsPage();
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note_outlined),
                label: 'Songs',
              ),
            ],
            currentIndex: _pageIndex,
            onTap: (int index) {
              setState(() {
                _pageIndex = index;
              });
              BlocProvider.of<HomeCubit>(context).setPage(index);
            },
          ),
        ),
        BlocBuilder<MusicPlayerSizeCubit, MusicPlayerSizeState>(
          builder: (context, state) {
            double bottom = kBottomNavigationBarHeight;
            if (state is MusicPlayerSizeLarge) bottom = 0;
            if (!(state is MusicPlayerSizeHidden))
              return MusicPlayerAnimatedPositioned(
                bottom: bottom,
                left: 0,
                child: Material(
                  child: MusicPlayer(),
                ),
              );
            return Container();
          },
        ),
      ],
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Search'),
      ),
    );
  }
}

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Discover'),
      ),
    );
  }
}
