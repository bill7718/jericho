
import 'dart:convert';

import 'package:jericho/journeys/liturgy/add_liturgy_controller.dart';
import 'package:jericho/journeys/liturgy/preivew_liturgy_page.dart';
import 'package:jericho/journeys/liturgy/record_liturgy_content_page.dart';
import 'package:jericho/journeys/liturgy/record_liturgy_name_page.dart';
import 'package:jericho/test_pages/generic_journey.dart';

testRecordLiturgyName()=>TestRecordLiturgyName();

class TestRecordLiturgyName extends GenericJourneyInput {

  TestRecordLiturgyName() : super(AddLiturgyController.recordLiturgyNameRoute, TestRecordLiturgyNameStateInput());
}

class TestRecordLiturgyNameStateInput implements RecordLiturgyNameStateInput {

  @override
  String get messageReference => '';

  @override

  String get name => '';

}

testRecordLiturgyContent()=>TestRecordLiturgyContent();

class TestRecordLiturgyContent extends GenericJourneyInput {

  TestRecordLiturgyContent() : super(AddLiturgyController.recordLiturgyContentRoute, TestRecordLiturgyContentStateInput());
}

class TestRecordLiturgyContentStateInput implements RecordLiturgyContentStateInput {

  @override
  String get messageReference => '';

  @override

  String get name => '';

  @override
  String get content => '[{"insert":"Hear the commandments which God has given to his people, and examine your hearts. I am the Lord your God: you shall have no other gods but me."},{"insert":"Amen. Lord, have mercy.","attributes":{"b":true}},{"insert":"You shall not make for yourself any idol. All  "},{"insert":" Amen. Lord, have mercy.","attributes":{"b":true}}]';

}

testPreviewLiturgy()=>TestPreviewLiturgy();

class TestPreviewLiturgy extends GenericJourneyInput {

  TestPreviewLiturgy() : super(AddLiturgyController.previewLiturgyRoute, TestPreviewLiturgyStateInput());
}

class TestPreviewLiturgyStateInput implements PreviewLiturgyStateInput {

  TestPreviewLiturgyStateInput() {
    initialiseContent();
  }

  initialiseContent() {
    var c = '[';

    c = c + makeLine('Hello1');
    c = c + makeLine('Hello2');
    c = c + makeLine('Hello3');
    c = c + makeLine('Hello4');
    c = c + makeLine('Hello5');
    c = c + makeLine('Hello6');
    c = c + makeLine('Hello7');
    c = c + makeLine('Hello8');
    c = c + makeLine('Hello9');
    c = c + makeLine('Hello10');
    c = c + makeLine('Hello11');
    c = c + makeLine('Hello12');
    c = c + makeLine('Hello121');
    c = c + makeLine('Hello122');
    c = c + makeLine('Hello123');
    c = c + makeLine('Hello124');
    c = c + makeLine('Hello125');
    c = c + makeLine('Hello126');
    c = c + makeLine('Hello127');
    c = c + makeLine('Hello128');
    c = c + makeLine('Hello129');
    c = c + makeLine('Hello130');


    c = c.substring(0, c.length -1) + ']';

    content = c;
  }

  String makeLine(String c, { bool bold = false}) {
    var m = <String, dynamic>{};
    m['insert'] = c;
    return JsonEncoder().convert(m) + ',';
  }

  @override
  String get messageReference => '';

  @override
  String get name => '';

  @override
  String content = '[{"insert":"Hello"}, {"insert":"Hear the commandments which God has given to his people, and examine your hearts. I am the Lord your God: you shall have no other gods but me."},{"insert":"Amen. Lord, have mercy.","attributes":{"b":true}},{"insert":"You shall not make for yourself any idol. All  "},{"insert":" Amen. Lord, have mercy.","attributes":{"b":true}}]';
}
