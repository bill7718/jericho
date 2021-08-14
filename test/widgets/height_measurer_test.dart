import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/widgets/height_measurer.dart';

import '../mocks/mocks.dart';
import '../util.dart';

const String line = 'Hello 123';
const String line2 = 'Hello 123\n';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();
  });

  group('Test HeightMeasurer', () {
    testWidgets(
        'When the system initiates HeightMeasurer with an empty list of TextSpan I expect the height to be 14 ',
        (WidgetTester tester) async {
      MockPage page = MockPage(
          Column( children: [HeightMeasurer(
        width: 600,
        spans: const [],
        heightCallback: (h) {
          expect(h, 14);
        },
      ),
          const SizedBox(width: 50, height: 50)]));
      await tester.pumpWidget(page, const Duration(milliseconds: 1000));
    });

    testWidgets(
        'When the system initiates HeightMeasurer with a single TextSpan I expect the height to be 14 ',
            (WidgetTester tester) async {
          MockPage page = MockPage(
              Column( children: [HeightMeasurer(
                width: 600,
                spans: const [ TextSpan(text: line)],
                heightCallback: (h) {
                  expect(h, 14);
                },
              ),
                const SizedBox(width: 50, height: 50)]));
          await tester.pumpWidget(page, const Duration(milliseconds: 1000));
        });

    testWidgets(
        'When the system initiates HeightMeasurer with a two TextSpans I expect the height to be 28 ',
            (WidgetTester tester) async {
          MockPage page = MockPage(
              Column( children: [HeightMeasurer(
                width: 600,
                spans: const [ TextSpan(text: line), TextSpan(text: line2)],
                heightCallback: (h) {
                  expect(h, 28);
                },
              ),
                const SizedBox(width: 50, height: 50)]));
          await tester.pumpWidget(page, const Duration(milliseconds: 1000));
        });


    testWidgets(
        'When the system initiates HeightMeasurer with many TextSpans I expect the height to be larger ',
            (WidgetTester tester) async {

          var spans = <TextSpan>[];
          while (spans.length < 100) {
            spans.add(const TextSpan(text: line2));
          }

          MockPage page = MockPage(
              Column( children: [HeightMeasurer(
                width: 600,
                spans: spans,
                heightCallback: (h) {
                  expect(h > 1000, true, reason: h.toString());
                },
              ),
                const SizedBox(width: 50, height: 50)]));
          await tester.pumpWidget(page, const Duration(milliseconds: 1000));
        });
  });
}
