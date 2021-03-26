import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';
import 'package:ohrwurm/features/song/domain/usecases/add_song.dart';

class ScanDirectoryForSongs extends UseCase<void, ScanDirectoryParams> {
  final SongRepository songRepository;
  final AddSong addSong;

  ScanDirectoryForSongs(
      {@required this.addSong, @required this.songRepository});

  @override
  Future<Either<Failure, void>> call(ScanDirectoryParams params) async {
    // Stream directoryScanStream;

    Either<Failure, List<FileSystemEntity>> directoryContentEither =
        songRepository.scanDirectory(params.directory);

    return directoryContentEither.fold((l) => Left(l), (r) async {
      for (FileSystemEntity fileSystemEntity in r) {
        if (fileSystemEntity is File) {
          String filePath = fileSystemEntity.path;
          String fileType = filePath.split('.').last;
          if (kSupportedFileTypes.contains(fileType)) {
            await addSong(AddSongParams(songFile: fileSystemEntity));
          }
        }
      }
      return Right(null);
    });
  }
}

class ScanDirectoryParams extends Equatable {
  final Directory directory;

  ScanDirectoryParams({@required this.directory});
  @override
  List<Object> get props => [];
}
