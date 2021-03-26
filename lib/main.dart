import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ohrwurm/features/home/presentation/cubit/home_cubit.dart';
import 'package:ohrwurm/features/home/presentation/pages/home_page.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_cubit/music_player_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_size_cubit/music_player_size_cubit.dart';
import 'package:ohrwurm/injection_container.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
  Permission.storage.request();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Manrope',
        primaryColor: Colors.black,
        accentColor: Color(0xFFA7B0D0),
        canvasColor: Colors.white,
        shadowColor: Colors.black.withOpacity(.7),
        primaryTextTheme: TextTheme(
          headline1: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.black),
          headline2: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFFA7B0D0)),
          bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          bodyText2: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFA7B0D0)),
        ),
      ),
      home: BlocProvider(
        create: (context) => sl<MusicPlayerCubit>(),
        child: BlocProvider(
          create: (context) => sl<MusicPlayerSizeCubit>(),
          child: BlocProvider(
            create: (context) => sl<HomeCubit>(),
            child: HomePage(),
          ),
        ),
      ),
    );
  }
}
