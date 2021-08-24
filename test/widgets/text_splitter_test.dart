import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/service/service_item.dart';

import 'package:jericho/widgets/text_splitter.dart';

import '../util.dart';

const String line = 'Hello 123';
const String line2 = 'Hello 123\n';

void main() {
  var complete = false;
  setUp(() {
    complete = false;
  });

  group('Test TextSplitter', () {
    testWidgets(
        'When the system initiates TextSplitter with a single TextSpan I expect there ot be a single range item ',
            (WidgetTester tester) async {
          MockPage page = MockPage(
              Column(children: [TextSplitter(
                width: 800,
                maxHeight: 600,
                spans: const [TextSpan(text: line)],
                callback: (List <SpanRange> separators) {
                  expect(separators.length, 1);
                  expect(separators.first.start, 0);
                  expect(separators.first.end, 1);
                  complete = true;
                },
              ),
                const SizedBox(width: 50, height: 50)]));
          while (!complete) {
            await tester.pumpWidget(page, const Duration(milliseconds: 1000));
          }
        });

    testWidgets(
        'When the system initiates TextSplitter with two TextSpans I expect there to be a single range item ',
            (WidgetTester tester) async {
          MockPage page = MockPage(
              Column(children: [TextSplitter(
                width: 800,
                maxHeight: 600,
                spans: const [TextSpan(text: line2), TextSpan(text: line2)],
                callback: (List <SpanRange> separators) {
                  expect(separators.length, 1);
                  expect(separators.first.start, 0);
                  expect(separators.first.end, 2);
                  complete = true;
                },
              ),
                const SizedBox(width: 50, height: 50)]));
          while (!complete) {
            await tester.pumpWidget(page, const Duration(milliseconds: 1000));
          }
        });

    testWidgets(
        'When the system initiates TextSplitter with 42 TextSpans (just more than one page) I expect there to be a two range items ',
            (WidgetTester tester) async {

          var spans = <TextSpan>[];
          while (spans.length < 42) {
            spans.add(const TextSpan(text: line2));
          }

          MockPage page = MockPage(
              Column(children: [TextSplitter(
                width: 800,
                maxHeight: 600,
                spans: spans,
                callback: (List <SpanRange> separators) {
                  expect(separators.length, 2);
                  expect(separators.first.start, 0);
                  expect(separators.first.end, 41);
                  expect(separators[1].start, 41);
                  expect(separators[1].end, 42);
                  complete = true;
                },
              ),
                const SizedBox(width: 50, height: 50)]));
          while (!complete) {
            await tester.pumpWidget(page, const Duration(milliseconds: 1000));
          }
        });


    testWidgets(
        'When the system initiates TextSplitter with 84 TextSpans (just more than two pages) I expect there to be three range items ',
            (WidgetTester tester) async {


          var spans = <TextSpan>[];
          while (spans.length < 84) {
            spans.add(const TextSpan(text: line2));
          }

          MockPage page = MockPage(
              Column(children: [TextSplitter(
                width: 800,
                maxHeight: 600,
                spans: spans,
                callback: (List <SpanRange> separators) {
                  expect(separators.length, 3);
                  expect(separators.first.start, 0);
                  expect(separators.first.end, 41);
                  expect(separators[1].start, 41);
                  expect(separators[1].end, 82);
                  expect(separators[2].start, 82);
                  expect(separators[2].end, 84);
                  complete = true;
                },
              ),
                const SizedBox(width: 50, height: 50)]));

          while (!complete) {
            await tester.pumpWidget(page, const Duration(milliseconds: 1000));
          }

        });
  });
}