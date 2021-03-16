import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/usecases/usecase.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/data/models/artist_model.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/artist/domain/repositories/artist_repository.dart';
import 'package:ohrwurm/features/artist/domain/usecases/get_artist.dart';

class AddArtist extends UseCase<String, AddArtistParams> {
  final ArtistRepository artistRepository;
  final GetArtist getArtist;
  final IdGenerator idGenerator;

  AddArtist({
    @required this.artistRepository,
    @required this.getArtist,
    @required this.idGenerator,
  })  : assert(artistRepository != null),
        assert(getArtist != null),
        assert(idGenerator != null);

  @override
  Future<Either<Failure, String>> call(AddArtistParams params) async {
    final artistAlreadyExistsEither =
        await artistRepository.getArtistFromName(params.artistName);
    return artistAlreadyExistsEither.fold(
      (l) async {
        if (l is NotInDatabaseFailure) {
          final String id = idGenerator();
          final Either<Failure, Artist> artistIdAlreadyExistsEither =
              await getArtist(GetArtistParams(artistId: id));

          return artistIdAlreadyExistsEither.fold((l) async {
            if (l is NotInDatabaseFailure) {
              await artistRepository
                  .addArtist(ArtistModel(id: id, name: params.artistName));
              return Right(id);
            } else {
              return Left(l);
            }
          }, (r) => call(params));
        } else {
          print(l.message);
          return Left(l);
        }
      },
      (r) => Left(
        ArtistAlreadyExistsFailure(
            message: ARTIST_ALREADY_EXISTS_MESSAGE, artistId: r.id),
      ),
    );
  }
}

class AddArtistParams extends Equatable {
  final String artistName;

  AddArtistParams({@required this.artistName});

  @override
  List<Object> get props => [artistName];
}
