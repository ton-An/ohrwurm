import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/usecases/usecase.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/artist/domain/repositories/artist_repository.dart';

class AddArtist extends UseCase<String, Params> {
  final ArtistRepository artistRepository;

  AddArtist({@required this.artistRepository});

  @override
  Future<Either<Failure, String>> call(Params params) =>
      artistRepository.addArtist(params.artist);
}

class Params extends Equatable {
  final Artist artist;

  Params({@required this.artist});

  @override
  List<Object> get props => [artist];
}
