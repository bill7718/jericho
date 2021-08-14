import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/liturgy/liturgy.dart';
import 'package:jericho/widgets/height_measurer.dart';

import '../mocks/mocks.dart';
import '../util.dart';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();
  });

  group('Test HeightMeasurer', () {
    testWidgets(
        'When the system initiates HeightMeasurer with an empty list of TextSpan I expect the height to be zero ',
        (WidgetTester tester) async {
      MockPage page = MockPage(
          Column( children: [HeightMeasurer(
        width: 600,
        spans: const [],
        heightCallback: (w) {
          print(w);
        },
      ),
          const SizedBox(width: 50, height: 50)]));
      await tester.pumpWidget(page, const Duration(milliseconds: 1000));
    });
  });
}
