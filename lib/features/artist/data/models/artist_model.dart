import 'package:flutter/widgets.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';

class ArtistModel extends Artist {
  ArtistModel({@required String id, @required String name})
      : assert(id != null),
        assert(name != null),
        super(id: id, name: name);

  factory ArtistModel.fromMap(Map<String, dynamic> artistMap) =>
      ArtistModel(id: artistMap['id'], name: artistMap['name']);

  Map<String, String> toMap() => {'id': super.id, 'name': super.name};
}
