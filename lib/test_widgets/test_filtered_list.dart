
import 'package:flutter/material.dart';
import 'package:waterloo/waterloo.dart';

class TestFilteredList extends StatelessWidget {

  const TestFilteredList({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    final items = StringScorer.make([ 'Hello', 'Goodbye', 'Colin', 'Mabel']);

    return FilteredList(items: items, builder: (context, item ) {
      return Text(item.value);
    });
  }



}

class StringScorer with Scored {

  final String value;

  StringScorer(this.value);

  @override
  int score(String filter) {
    if (value.contains(filter)) {
      return value.length;
    } else {
      return 0;
    }
  }

  static List<StringScorer> make(List<String> values) {
    var response = <StringScorer>[];

    for (var item in values) {
      response.add(StringScorer(item));
    }

    return response;
  }
  
}