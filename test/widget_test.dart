import 'package:flutter_test/flutter_test.dart';

import 'package:ruang_geo/main.dart';

void main() {
  testWidgets('RuangGeo app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RuangGeoApp());
    // Biarkan frame pertama selesai
    await tester.pump();
  });
}
