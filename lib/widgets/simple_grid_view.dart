

import 'package:flutter/widgets.dart';


///
/// 
///
class SimpleGridView extends StatelessWidget {
  final List<Widget> children;
  final int numberOfColumns;
  final EdgeInsets spacing;

  const SimpleGridView(
      {Key? key, required this.children, this.numberOfColumns = 3, this.spacing = const EdgeInsets.all(0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rows = <Widget>[];
    var rowContents = <Widget>[];
    rowContents.add(
      Container(
        margin: spacing,
      ),
    );
    for (var item in children) {
      rowContents.add(item);
      rowContents.add(
        Container(
          margin: spacing,
        ),
      );
      if (rowContents.length == 2 * numberOfColumns + 1) {
        rows.add(Row(
          children: rowContents,
        ));
        rows.add(Container(
          margin: spacing,
        ));
        rowContents = <Widget>[];
        rowContents.add(
          Container(
            margin: spacing,
          ),
        );
      }
    }

    rows.add(Row(
      children: rowContents,
    ));

    return Column(
      children: rows,
    );
  }
}