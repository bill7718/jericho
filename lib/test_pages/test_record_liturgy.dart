
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

  @override
  String get messageReference => '';

  @override

  String get name => '';

  @override
  String get content => '[{"insert":"Hear the commandments which God has given to his people, and examine your hearts. I am the Lord your God: you shall have no other gods but me."},{"insert":"Amen. Lord, have mercy.","attributes":{"b":true}},{"insert":"You shall not make for yourself any idol. All  "},{"insert":" Amen. Lord, have mercy.","attributes":{"b":true}}]';

}
