import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class Artist extends Equatable {
  final String id;
  final String name;

  Artist({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);

  @override
  List<Object> get props => [id, name];
}
