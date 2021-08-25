import 'package:jericho/journeys/service/add_service_controller.dart';
import 'package:jericho/journeys/service/preview_service_page.dart';
import 'package:jericho/journeys/service/service_item.dart';
import 'package:jericho/test_pages/generic_journey.dart';

testPreviewService() => TestPreviewService();

class TestPreviewService extends GenericJourneyInput {
  TestPreviewService() : super(AddServiceController.previewServiceRoute, TestPreviewServiceStateInput());
}

class TestPreviewServiceStateInput implements PreviewServiceStateInput {
  @override
  String get name => 'Test Service Name';

  String get lit1234Text =>
      '[{"insert":"Hear the commandments which God has given to his people, and examine your hearts. I am the Lord your God: you shall have no other gods but me."},{"insert":"Amen. Lord, have mercy.","attributes":{"b":true}},{"insert":"You shall not make for yourself any idol. All  "},{"insert":" Amen. Lord, have mercy.","attributes":{"b":true}}]';

  @override
  List<ServiceItem> get fullServiceContent => <ServiceItem>[
        ServiceItem({'id': 'YT1234', 'type': 'YouTube', 'name': 'Test YT Video', 'videoId': 'Y3j8cAe6M6M'}),
        ServiceItem({'id': 'LIT1234', 'type': 'Liturgy', 'name': 'Test Liturgy', 'text': lit1234Text}),
        ServiceItem({'id': 'YT1235', 'type': 'YouTube', 'name': 'Test YT Video', 'videoId': 'Y3j8cAe6M6M'}),
        ServiceItem({'id': 'LIT1235', 'type': 'Liturgy', 'name': 'Test Liturgy', 'text': lit1234Text})
      ];
}
