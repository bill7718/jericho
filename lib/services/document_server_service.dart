

import 'dart:typed_data';

abstract class DocumentServerService {

  Future<bool> put(String folder, String fileName, Uint8List data);

  Future<Uint8List> get(String folder, String fileName);

}

class DocumentServerException implements Exception {
  final String _message;

  DocumentServerException(this._message);

  @override
  String toString() => _message;
}

class FileTooBigException implements Exception {
  final String _message;

  FileTooBigException(this._message);

  @override
  String toString() => _message;
}