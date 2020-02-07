import 'package:events/locale.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('date range', () {
    final start = DateTime(2020, 2, 1, 14, 28, 22);
    final end = DateTime(2020, 2, 2, 10, 0, 0);
    expect(formatDateRange(null, null), isNull);
    expect(formatDateRange(start, null), equals('2/1/2020 14:28'));
    expect(
        formatDateRange(start, end), equals('2/1/2020 14:28 - 2/2/2020 10:00'));
  });
}
