import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mocks.dart';

void main() {
  setUp(() async {});

  group('Base test', () {
    testWidgets('When test runs - it passes ', (WidgetTester tester) async {
      expect(true, true);
    });
  });
}
