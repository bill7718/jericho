
import 'dart:math';

class KeyGenerator {

  static final int max = pow(2, 30).toInt();

  int keyLength = 15;
  final Random _random = Random();

  String getKey() {

    String s = _random.nextInt(max).toRadixString(34);
    while (s.length < keyLength) {
      s = s + _random.nextInt(max).toRadixString(34);
    }

    return s.substring(0, keyLength);

  }



}