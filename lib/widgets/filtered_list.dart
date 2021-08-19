/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_text_field.dart';

///
/// Accepts a list of items and filters them based on a text value entered by a user
///
class FilteredList<T extends Scored> extends StatelessWidget {

  ///
  /// The items to be filtered. These must implement the [Scored] interface
  ///
  final List<T> items;

  /// Accepts an item from the list of [items] and returns a widget
  /// This widget is displayed in the list
  final Function builder;


  /// The label text to use for the text field where the user enters the filter
  final String label;

  static const String filterLabel = 'Filter';
  final _filterValue = ValueNotifier<String>('');

  FilteredList({Key? key, required this.items, required this.builder, this.label = filterLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        WaterlooTextField(valueBinder: (v) => { _filterValue.value = v }, label: label, validator: (v) {}),
        Expanded(
            child: ChangeNotifierProvider<ValueNotifier<String>>.value(
                value: _filterValue,
                child: Consumer<ValueNotifier<String>>(builder: (context, filterValue, _) {
                  var filteredItems = <T>[];
                  for (var item in items) {
                    if (item.getScore(filterValue.value) > 0) {
                      filteredItems.add(item);
                    }
                  }
                  filteredItems.sort((a, b) {
                    if (a.getScore(filterValue.value) > b.getScore(filterValue.value)) {
                      return -1;
                    } else {
                      return 1;
                    }
                  });

                  var widgets = <Widget>[];
                  for (var item in filteredItems) {
                    widgets.add(builder(context, item));
                  }

                  return Card(
                      child: ListView(
                        children: widgets,
                      ));
                })))
      ],
    );
  }
}


///
/// Classes that implement this interface provide a simple integer score when provided with a String
///
/// This can be used to filter lists of data by comparing the data content against a String entered by a user.
///
abstract class Scored extends Object {

  final Map<String, int> _cache = <String, int>{};

  ///
  /// Return a score that, in some way, reflects the match between the String provided and
  /// the data content of this object. By convention a higher score indicates a greater match.
  ///
  /// The score method many be called many times for the same object and filter value.
  ///
  int score(String filter);

  ///
  /// Calls the [score] method caching the result so that it does not need to be recomputed next time
  ///
  int getScore(String filter) {
    if (_cache[filter] == null) {
      var value = score(filter);
      _cache[filter] = value;
      return value;
    } else {
      return _cache[filter]!;
    }
  }

  /// Clears the cache of scores recorded by the [getScore] method
  void clearScoreCache()=>_cache.clear();
}

*/
