import 'package:uuid/uuid.dart';
import 'package:meta/meta.dart';

class IdGenerator {
  final Uuid uuid;

  IdGenerator({@required this.uuid});

  String call() => uuid.v1();
}
