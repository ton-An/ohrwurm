import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/usecases/usecase.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/artist/domain/repositories/artist_repository.dart';

class GetArtist extends UseCase<Artist, GetArtistParams> {
  final ArtistRepository artistRepository;

  GetArtist({@required this.artistRepository});

  @override
  Future<Either<Failure, Artist>> call(GetArtistParams params) =>
      artistRepository.getArtistFromId(params.artistId);
}

class GetArtistParams extends Equatable {
  final String artistId;

  GetArtistParams({@required this.artistId});

  @override
  List<Object> get props => [artistId];
}
