import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/features/artist/data/models/artist_model.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';

final Artist tArtist = ArtistModel(id: '321', name: 'Abstract');
final ArtistModel tArtistModel = ArtistModel(id: '321', name: 'Abstract');
Map<String, Object> tArtistModelMap = {'id': '321', 'name': 'Abstract'};
final String tArtistId = '321';

final List<ArtistModel> tArtistModelList = [
  ArtistModel(id: '321', name: 'Abstract'),
  ArtistModel(id: '4321', name: 'RoZe'),
];

final String tArtistName = 'Abstract';

final ArtistAlreadyExistsFailure tArtistAlreadyExistsFailure =
    ArtistAlreadyExistsFailure(
  message: ARTIST_ALREADY_EXISTS_MESSAGE,
  artistId: tArtistId,
);

final NotInDatabaseFailure tNotInDatabaseFailure = NotInDatabaseFailure('');
