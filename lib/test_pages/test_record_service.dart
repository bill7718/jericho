import 'package:jericho/journeys/service/add_service_controller.dart';
import 'package:jericho/journeys/service/record_service_page.dart';
import 'package:jericho/test_pages/generic_journey.dart';

testRecordService() => TestRecordService();

class TestRecordService extends GenericJourneyInput {
  TestRecordService() : super(AddServiceController.recordServiceRoute, TestRecordServiceStateInput());
}

class TestRecordServiceStateInput implements RecordServiceStateInput {
  TestRecordServiceStateInput() {
    serviceContents.addAll([
      {'name': 'Hello', 'type': 'ThisType'},
      {'name': 'Hello2', 'type': 'ThisType'}
    ]);
  }

  @override
  String get name => '';

  @override
  List<Map<String, String>> serviceContents = [];
}
