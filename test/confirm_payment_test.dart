import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking_system/components/payment/confirm_payment.dart';

void main() {
  group('extractSlotsAvailable', () {
    test('extracts number from string with slots available', () {
      String result = updateSlot('10/20');
      expect(result, '9/20');
    });

    test('returns 0 if no number is found', () {
      String result = updateSlot('0/20');
      expect(result, '0/20');
    });
  });
}