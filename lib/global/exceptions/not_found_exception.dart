import 'package:mongo_dart/mongo_dart.dart';

class NotFoundException implements Exception {
  NotFoundException(this.message);

  String message;

  @override
  String toString() {
    return message;
  }
}
