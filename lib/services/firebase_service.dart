

abstract class FirebaseService {


  Future<List<Map<String, dynamic>>> query(String ref, { String? field,  value } );

  Future<void> set(String ref, Map<String, dynamic> m);
}