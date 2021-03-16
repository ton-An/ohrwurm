import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/features/song/domain/usecases/add_song.dart';

class ScanDirectoryForSongs extends UseCase<void, ScanDirectoryForSongsParams> {
  final AddSong addSong;

  ScanDirectoryForSongs({@required this.addSong});

  @override
  Future<Either<Failure, void>> call(ScanDirectoryForSongsParams params) async {
    // should call list on directory
    List directoryScanStream;
    print('Scanning Directory');

    directoryScanStream = params.directory.listSync(recursive: true);

    for (var value in directoryScanStream) {
      if (value is File) {
        String filePath = value.path;
        String fileType = filePath.split('.').last;
        if (fileType == 'mp3') {
          await Future.delayed(Duration(milliseconds: 100));
          addSong(AddSongParams(songFile: value));
        }
      }
    }
    return Right(null);
  }
}

class ScanDirectoryForSongsParams extends Equatable {
  final Directory directory;

  ScanDirectoryForSongsParams({@required this.directory});
  @override
  List<Object> get props => [];
}
