

import 'dart:async';

import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/services/firebase_service.dart';
import 'package:jericho/services/key_generator.dart';

class DataService {

  final FirebaseService _fb;
  final KeyGenerator _gen;

  DataService(this._fb, this._gen);


  Future<Map<String, dynamic>> get(String collection, String id) async {
    var c = Completer<Map<String, dynamic>>();
    var response = await _fb.get(collection + '/' + id);
    c.complete(response);
    return c.future;
  }

  Future<Map<String, dynamic>> delete(String collection, String id) async {
    var c = Completer<Map<String, dynamic>>();
    var response = await _fb.delete(collection + '/' + id);
    c.complete(response);
    return c.future;
  }

  Future<String> set(String collection, Map<String, dynamic> data) async {
    var c = Completer<String>();
    if (!data.containsKey(idFieldName)) {
      data[idFieldName] = _gen.getKey();
    }

    await _fb.set(collection + '/' + data[idFieldName], data);
    c.complete(data[idFieldName]);
    return c.future;
  }

  Future<List<Map<String, dynamic>>> query(String ref, { String? field,  value } ) {
    return _fb.query(ref, field: field, value: value);
  }

}