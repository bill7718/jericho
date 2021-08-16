import 'package:jericho/journeys/service/add_service_controller.dart';
import 'package:jericho/journeys/service/record_service_page.dart';
import 'package:jericho/journeys/service/service_item.dart';
import 'package:jericho/test_pages/generic_journey.dart';

testRecordService() => TestRecordService();

class TestRecordService extends GenericJourneyInput {
  TestRecordService() : super(AddServiceController.recordServiceRoute, TestRecordServiceStateInput());
}

class TestRecordServiceStateInput implements RecordServiceStateInput {
  TestRecordServiceStateInput();

  @override
  String get name => '';

  @override
  List<ServiceItem> serviceItems = [];
}
