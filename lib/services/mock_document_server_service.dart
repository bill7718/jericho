import 'dart:async';
import 'dart:typed_data';

import 'package:jericho/services/document_server_service.dart';

class MockDocumentServerService implements DocumentServerService {
  Map<String, Map<String, Uint8List>> _data = <String, Map<String, Uint8List>>{};

  @override
  Future<Uint8List> get(String folder, String fileName) {
    var c = Completer<Uint8List>();

    if (_data[folder] == null) {
      c.complete(null);
    } else {
      c.complete(_data[folder]![fileName]);
    }
    return c.future;
  }

  @override
  Future<bool> put(String folder, String fileName, Uint8List data) {
    var c = Completer<bool>();

    if (_data[folder] == null) {
      _data[folder] = <String, Uint8List>{};
    }

    _data[folder]![fileName] = data;

    c.complete(true);

    return c.future;
  }
}
