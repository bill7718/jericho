
import 'package:flutter/material.dart';
import 'package:jericho/widgets/named_item_widgets.dart';
import 'package:jericho/widgets/widgets_vm.dart';
import 'package:waterloo/waterloo.dart';

class TestNamedItemTile extends StatelessWidget {

  const TestNamedItemTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var widgets = <Widget>[
      NamedItemTile(
          item: TestNamedItem('Hello', 'YouTube'),
        actionIcon: Icons.add,
        enabled: true,
        selected: false,
      ),
      NamedItemTile(
        item: TestNamedItem('Hello2', 'YouTube'),
        actionIcon: Icons.add,
        onPressed: () { print('Hello2'); } ,
        enabled: true,
        selected: true,
      ),
      NamedItemTile(
        item: TestNamedItem('Hello3', 'Song'),
        actionIcon: Icons.delete,
        onPressed: () { print('Hello3'); } ,
        enabled: false,
        selected: true,
      ),
      NamedItemTile(
        item: TestNamedItem('Hello4', 'Presentation'),
        actionIcon: Icons.delete,
        enabled: true,
        selected: false,
      ),
      DraggableNamedItem(item: TestNamedItem('Hello5', 'Presentation',), selectOnDrag: true, actionIcon: Icons.delete,)

    ];




  return ListView(children: widgets,);

  }



}

class TestNamedItem implements NamedItem {

  @override
  String name;
  @override
  String type;

  TestNamedItem(this.name, this.type);

}

