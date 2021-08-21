
import 'package:jericho/journeys/you_tube/add_you_tube_controller.dart';
import 'package:jericho/journeys/you_tube/record_you_tube_page.dart';
import 'package:jericho/test_pages/generic_journey.dart';

testRecordYouTube()=>TestRecordYouTube();

class TestRecordYouTube extends GenericJourneyInput {

  TestRecordYouTube() : super(AddYouTubeController.recordYouTubeRoute, TestRecordYouTubeStateInput());
}

class TestRecordYouTubeStateInput implements RecordYouTubeStateInput {

  @override
  String get messageReference => '';

  @override

  String get name => '';

  @override
  String get videoId => '';

}


